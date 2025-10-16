use BARTO_TCG;
go

-- =======================================
-- CREACION DE PROCEDIMIENTOS ALMACENADOS 
-- =======================================


-- =========================================
-- TIPOS DE TABLA (para parámetros READONLY)
-- =========================================
CREATE TYPE TipoDetalleVenta AS TABLE
(
    IdProducto INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    Subtotal DECIMAL(10,2)
);
GO

CREATE TYPE TipoDetallePedido AS TABLE
(
    IdProducto INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2)
);
GO




--=======================================
-- Crear Cliente
-- ======================================

CREATE OR ALTER PROCEDURE sp_CrearCliente
    @Nombre NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Dni CHAR(8),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Cliente (Nombre, Apellidos, Dni, Email)
        VALUES (@Nombre, @Apellidos, @Dni, @Email);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Actualizar Cliente
CREATE OR ALTER PROCEDURE sp_ActualizarCliente
    @IdCliente INT,
    @Nombre NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Cliente
        SET Nombre = @Nombre,
            Apellidos = @Apellidos,
            Email = @Email
        WHERE IdCliente = @IdCliente;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Eliminar Cliente
CREATE OR ALTER PROCEDURE sp_EliminarCliente
    @IdCliente INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM Cliente WHERE IdCliente = @IdCliente;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


-- =========================
-- Crear Producto
-- =========================
CREATE OR ALTER PROCEDURE sp_CrearProducto
    @Nombre NVARCHAR(100),
    @PrecioVenta DECIMAL(10,2),
    @Stock INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Producto (Nombre, PrecioVenta, Stock)
        VALUES (@Nombre, @PrecioVenta, @Stock);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Actualizar Producto
CREATE OR ALTER PROCEDURE sp_ActualizarProducto
    @IdProducto INT,
    @Nombre NVARCHAR(100),
    @PrecioVenta DECIMAL(10,2),
    @Stock INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Producto
        SET Nombre = @Nombre,
            PrecioVenta = @PrecioVenta,
            Stock = @Stock
        WHERE IdProducto = @IdProducto;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Actualizar Stock del Producto
CREATE OR ALTER PROCEDURE sp_ActualizarStockProducto
    @IdProducto INT,
    @NuevoStock INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Producto
        SET Stock = @NuevoStock
        WHERE IdProducto = @IdProducto;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- =======================================
-- PROCEDIMIENTOS EN VENTA CRUD 
-- =======================================

CREATE OR ALTER PROCEDURE sp_RegistrarVenta
    @IdCliente INT,
    @FechaVenta DATE,
    @Total DECIMAL(10,2),
    @DetallesVenta TipoDetalleVenta READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar Venta
        INSERT INTO Venta (IdCliente, FechaVenta, Total)
        VALUES (@IdCliente, @FechaVenta, @Total);

        DECLARE @IdVenta INT = SCOPE_IDENTITY();

        -- Insertar detalles
        INSERT INTO Detalle_Venta (IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal)
        SELECT @IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal
        FROM @DetallesVenta;

        -- Actualizar stock
        UPDATE P
        SET P.Stock = P.Stock - D.Cantidad
        FROM Producto P
        INNER JOIN @DetallesVenta D ON P.IdProducto = D.IdProducto;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


-- ==================================================
-- PROCEDIMIENTO PEDIDO PROVEEDOR CRUD
-- ==================================================

CREATE OR ALTER PROCEDURE sp_RegistrarPedidoProveedor
    @IdProveedor INT,
    @FechaPedido DATE,
    @Estado NVARCHAR(50),
    @DetallesPedido TipoDetallePedido READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar Pedido principal
        INSERT INTO Pedido_Proveedor (IdProveedor, FechaPedido, Estado)
        VALUES (@IdProveedor, @FechaPedido, @Estado);

        DECLARE @IdPedidoProveedor INT = SCOPE_IDENTITY();

        -- Insertar detalles (sin Subtotal, porque es columna calculada)
        INSERT INTO Detalle_Pedido (IdPedidoProveedor, IdProducto, Cantidad, PrecioUnitario)
        SELECT @IdPedidoProveedor, IdProducto, Cantidad, PrecioUnitario
        FROM @DetallesPedido;

        -- Actualizar stock automáticamente
        UPDATE P
        SET P.Stock = P.Stock + D.Cantidad
        FROM Producto P
        INNER JOIN @DetallesPedido D ON P.IdProducto = D.IdProducto;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


-- =========================================
-- Registrar Reserva
-- =========================================
CREATE OR ALTER PROCEDURE sp_RegistrarReserva
    @IdCliente INT,
    @IdProducto INT,
    @FechaReserva DATE,
    @Estado NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Reserva (IdCliente, IdProducto, FechaReserva, Estado)
        VALUES (@IdCliente, @IdProducto, @FechaReserva, @Estado);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Actualizar Estado de Reserva
CREATE OR ALTER PROCEDURE sp_ActualizarEstadoReserva
    @IdReserva INT,
    @NuevoEstado NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Reserva
        SET Estado = @NuevoEstado
        WHERE IdReserva = @IdReserva;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


