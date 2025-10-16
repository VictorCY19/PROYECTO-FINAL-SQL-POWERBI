USE BARTO_TCG;
GO

/* ===============================================================
   7️⃣ DATOS INICIALES Y ROLES DE APLICACIÓN
   ---------------------------------------------------------------
   Esta sección contiene la creación de catálogos estáticos 
   (Roles, Usuarios base, Estados y Métodos de pago, etc.)
   =============================================================== */

------------------------------------------------------------
-- 1️⃣ TABLA DE ROLES (Catálogo de roles de la aplicación)
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Rol')
BEGIN
    CREATE TABLE Rol (
        IdRol INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(50) NOT NULL UNIQUE,
        Descripcion NVARCHAR(200)
    );
    PRINT '✅ Tabla Rol creada correctamente.';
END;
GO

------------------------------------------------------------
-- 2️⃣ TABLA DE USUARIOS (Login interno del sistema)
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Usuario')
BEGIN
    CREATE TABLE Usuario (
        IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
        NombreUsuario NVARCHAR(100) NOT NULL UNIQUE,
        ClaveHash NVARCHAR(256) NOT NULL,
        IdRol INT NOT NULL,
        Activo BIT DEFAULT 1,
        FechaRegistro DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (IdRol) REFERENCES Rol(IdRol)
    );
    PRINT '✅ Tabla Usuario creada correctamente.';
END;
GO

------------------------------------------------------------
-- 3️⃣ INSERTAR ROLES BASE DEL SISTEMA
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Rol)
BEGIN
    INSERT INTO Rol (Nombre, Descripcion)
    VALUES ('Administrador', 'Acceso total al sistema y configuración general'),
           ('Vendedor', 'Gestiona ventas, reservas y clientes'),
           ('Almacenero', 'Gestiona productos, pedidos y stock');
    PRINT '✅ Roles base insertados correctamente.';
END;
GO

------------------------------------------------------------
-- 4️⃣ INSERTAR USUARIOS DE PRUEBA
------------------------------------------------------------
-- Nota: ClaveHash debe contener contraseñas encriptadas desde la app (SHA256 o bcrypt)
-- Para entorno de pruebas puedes usar valores simbólicos
IF NOT EXISTS (SELECT 1 FROM Usuario)
BEGIN
    INSERT INTO Usuario (NombreUsuario, ClaveHash, IdRol)
    VALUES ('admin', 'HASH_ADMIN', 1),   -- Rol Administrador
           ('luis.vendedor', 'HASH_VENDEDOR', 2), -- Rol Vendedor
           ('maria.almacen', 'HASH_ALMACEN', 3);  -- Rol Almacenero
    PRINT '✅ Usuarios base insertados correctamente.';
END;
GO

------------------------------------------------------------
-- 5️⃣ MÉTODOS DE PAGO (Catálogo auxiliar)
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Metodo_Pago')
BEGIN
    CREATE TABLE Metodo_Pago (
        IdMetodoPago INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(50) NOT NULL UNIQUE
    );
    PRINT '✅ Tabla Metodo_Pago creada correctamente.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM Metodo_Pago)
BEGIN
    INSERT INTO Metodo_Pago (Nombre)
    VALUES ('Efectivo'),
           ('Tarjeta'),
           ('Transferencia'),
           ('Yape / Plin');
    PRINT '✅ Métodos de pago insertados correctamente.';
END;
GO

------------------------------------------------------------
-- 6️⃣ ESTADOS DE PROCESOS (Catálogo auxiliar)
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Estado')
BEGIN
    CREATE TABLE Estado (
        IdEstado INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(50) NOT NULL UNIQUE,
        Tipo NVARCHAR(50) NOT NULL   -- Ej: 'Venta', 'Pedido', 'Reserva'
    );
    PRINT '✅ Tabla Estado creada correctamente.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM Estado)
BEGIN
    INSERT INTO Estado (Nombre, Tipo)
    VALUES ('Pendiente', 'Venta'),
           ('Pagado', 'Venta'),
           ('Cancelado', 'Venta'),
           ('Pendiente', 'Pedido'),
           ('Completado', 'Pedido'),
           ('Cancelado', 'Pedido'),
           ('Pendiente', 'Reserva'),
           ('Atendida', 'Reserva'),
           ('Anulada', 'Reserva');
    PRINT '✅ Estados base insertados correctamente.';
END;
GO

PRINT '🎯 DATOS INICIALES Y CATÁLOGOS CONFIGURADOS CORRECTAMENTE.';
GO


-- Eliminar la restricción UNIQUE antigua (solo si ya existe)
ALTER TABLE Estado
DROP CONSTRAINT UQ__Estado__75E3EFCFB20EAD79; -- o busca el nombre exacto del constraint en sys.objects
GO

-- Crear un índice único compuesto más correcto
ALTER TABLE Estado
ADD CONSTRAINT UQ_Estado_Nombre_Tipo UNIQUE (Nombre, Tipo);
GO

PRINT '✅ Restricción UNIQUE actualizada correctamente (Nombre + Tipo).';
