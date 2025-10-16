USE BARTO_TCG;
GO

------------------------------------------------------------
-- 1️⃣ TABLA DE PERMISOS
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Permiso')
BEGIN
    CREATE TABLE Permiso (
        IdPermiso INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL UNIQUE,
        Descripcion NVARCHAR(200)
    );
    PRINT '✅ Tabla Permiso creada correctamente.';
END;
GO

------------------------------------------------------------
-- 2️⃣ TABLA INTERMEDIA: RolPermiso (muchos a muchos)
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RolPermiso')
BEGIN
    CREATE TABLE RolPermiso (
        IdRol INT NOT NULL,
        IdPermiso INT NOT NULL,
        PRIMARY KEY (IdRol, IdPermiso),
        FOREIGN KEY (IdRol) REFERENCES Rol(IdRol),
        FOREIGN KEY (IdPermiso) REFERENCES Permiso(IdPermiso)
    );
    PRINT '✅ Tabla RolPermiso creada correctamente.';
END;
GO

------------------------------------------------------------
-- 3️⃣ INSERTAR PERMISOS BASE DEL SISTEMA
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Permiso)
BEGIN
    INSERT INTO Permiso (Nombre, Descripcion)
    VALUES ('Gestionar_Usuarios', 'Puede crear, modificar y eliminar usuarios del sistema'),
           ('Gestionar_Productos', 'Puede agregar, editar o eliminar productos'),
           ('Gestionar_Ventas', 'Puede registrar y consultar ventas'),
           ('Gestionar_Clientes', 'Puede registrar y modificar clientes'),
           ('Ver_Informes', 'Puede ver reportes e informes del sistema');

    PRINT '✅ Permisos base insertados correctamente.';
END;
GO

------------------------------------------------------------
-- 4️⃣ ASIGNAR PERMISOS A CADA ROL
------------------------------------------------------------
-- Obtener IDs dinámicamente
DECLARE @AdminRol INT = (SELECT IdRol FROM Rol WHERE Nombre = 'Administrador');
DECLARE @VendedorRol INT = (SELECT IdRol FROM Rol WHERE Nombre = 'Vendedor');
DECLARE @AlmaceneroRol INT = (SELECT IdRol FROM Rol WHERE Nombre = 'Almacenero');

DECLARE @GestionarUsuarios INT = (SELECT IdPermiso FROM Permiso WHERE Nombre = 'Gestionar_Usuarios');
DECLARE @GestionarProductos INT = (SELECT IdPermiso FROM Permiso WHERE Nombre = 'Gestionar_Productos');
DECLARE @GestionarVentas INT = (SELECT IdPermiso FROM Permiso WHERE Nombre = 'Gestionar_Ventas');
DECLARE @GestionarClientes INT = (SELECT IdPermiso FROM Permiso WHERE Nombre = 'Gestionar_Clientes');
DECLARE @VerInformes INT = (SELECT IdPermiso FROM Permiso WHERE Nombre = 'Ver_Informes');

-- Administrador → todos los permisos
IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @AdminRol)
BEGIN
    INSERT INTO RolPermiso (IdRol, IdPermiso)
    SELECT @AdminRol, IdPermiso FROM Permiso;
    PRINT '✅ Permisos asignados al rol Administrador.';
END;

-- Vendedor → Ventas, Clientes, Informes
IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @VendedorRol)
BEGIN
    INSERT INTO RolPermiso (IdRol, IdPermiso)
    VALUES (@VendedorRol, @GestionarVentas),
           (@VendedorRol, @GestionarClientes),
           (@VendedorRol, @VerInformes);
    PRINT '✅ Permisos asignados al rol Vendedor.';
END;

-- Almacenero → Productos, Informes
IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @AlmaceneroRol)
BEGIN
    INSERT INTO RolPermiso (IdRol, IdPermiso)
    VALUES (@AlmaceneroRol, @GestionarProductos),
           (@AlmaceneroRol, @VerInformes);
    PRINT '✅ Permisos asignados al rol Almacenero.';
END;
GO

------------------------------------------------------------
-- 5️⃣ VISTA PARA CONSULTAR PERMISOS DE USUARIOS
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_PermisosUsuario')
BEGIN
    EXEC('
        CREATE VIEW vw_PermisosUsuario AS
        SELECT 
            U.NombreUsuario,
            R.Nombre AS Rol,
            P.Nombre AS Permiso,
            P.Descripcion
        FROM Usuario U
        INNER JOIN Rol R ON U.IdRol = R.IdRol
        INNER JOIN RolPermiso RP ON R.IdRol = RP.IdRol
        INNER JOIN Permiso P ON RP.IdPermiso = P.IdPermiso;
    ');
    PRINT '✅ Vista vw_PermisosUsuario creada correctamente.';
END;
GO

------------------------------------------------------------
-- 6️⃣ REGISTRO DE CAMBIOS EN AUDITORIA (opcional)
------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_Auditoria_Seguridad
ON Usuario
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Operacion NVARCHAR(10);
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE
        SET @Operacion = 'DELETE';

    INSERT INTO Auditoria (Tabla, Operacion, Detalle)
    SELECT 
        'Usuario',
        @Operacion,
        CONCAT('Usuario=', COALESCE(I.NombreUsuario, D.NombreUsuario), 
               ', Rol=', (SELECT Nombre FROM Rol WHERE IdRol = COALESCE(I.IdRol, D.IdRol)))
    FROM inserted I
    FULL OUTER JOIN deleted D ON I.IdUsuario = D.IdUsuario;
END;
GO


------------------------------------------------------------
-- 7️⃣ PROCEDIMIENTO PARA VERIFICAR PERMISOS DE USUARIO
------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_VerificarPermiso
    @NombreUsuario NVARCHAR(100),
    @NombrePermiso NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Usuario U
        INNER JOIN Rol R ON U.IdRol = R.IdRol
        INNER JOIN RolPermiso RP ON R.IdRol = RP.IdRol
        INNER JOIN Permiso P ON RP.IdPermiso = P.IdPermiso
        WHERE U.NombreUsuario = @NombreUsuario
          AND P.Nombre = @NombrePermiso
    )
    BEGIN
        SELECT 1 AS TienePermiso, 'Permiso concedido.' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 0 AS TienePermiso, 'Permiso denegado.' AS Mensaje;
    END
END;
GO


