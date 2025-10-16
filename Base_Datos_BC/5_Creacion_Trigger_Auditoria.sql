USE BARTO_TCG;
GO

-- ==========================================
-- SCRIPT COMPLETO DE TRIGGERS
-- ==========================================
-- Autor: Victor Manuel Carranza Yactayo
-- Proyecto: BARTO_TCG - Sistema de Ventas y Stock
-- Descripción: Mantenimiento de integridad, control de stock y auditoría
-- ==========================================


-- ==========================================
-- 🔧 SECCIÓN 1: TRIGGERS PARA CONTROL DE VENTAS
-- ==========================================

-- 🔹 1. Validar stock antes de insertar detalle de venta
CREATE OR ALTER TRIGGER trg_ValidarStockVenta
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Evita ventas que superen el stock disponible
    IF EXISTS (
        SELECT 1
        FROM inserted I
        INNER JOIN Producto P ON I.IdProducto = P.IdProducto
        WHERE I.Cantidad > P.Stock
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50010, 'Stock insuficiente para completar la venta.', 1;
    END
END;
GO


-- 🔹 2. Actualizar total de la venta automáticamente
CREATE OR ALTER TRIGGER trg_ActualizarTotalVenta
ON Detalle_Venta
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdVenta INT;

    -- Detectar la venta afectada
    SELECT TOP 1 @IdVenta = COALESCE(I.IdVenta, D.IdVenta)
    FROM inserted I
    FULL OUTER JOIN deleted D ON I.IdDetalleVenta = D.IdDetalleVenta;

    -- Actualizar total de la venta
    UPDATE V
    SET V.Total = ISNULL((
        SELECT SUM(Subtotal)
        FROM Detalle_Venta DV
        WHERE DV.IdVenta = V.IdVenta
    ), 0)
    FROM Venta V
    WHERE V.IdVenta = @IdVenta;
END;
GO


-- 🔹 3. Ajustar stock al eliminar detalles de venta
CREATE OR ALTER TRIGGER trg_AjustarStockVenta
ON Detalle_Venta
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Devuelve al inventario las cantidades eliminadas
    UPDATE P
    SET P.Stock = P.Stock + D.Cantidad
    FROM Producto P
    INNER JOIN deleted D ON P.IdProducto = D.IdProducto;
END;
GO


-- ==========================================
-- 📦 SECCIÓN 2: TRIGGERS PARA CONTROL DE PEDIDOS A PROVEEDORES
-- ==========================================

-- 🔹 4. Actualizar total del pedido proveedor
-- (Solo aplica si tienes una columna Total en Pedido_Proveedor)
CREATE OR ALTER TRIGGER trg_ActualizarTotalPedidoProveedor
ON Detalle_Pedido
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdPedidoProveedor INT;

    SELECT TOP 1 @IdPedidoProveedor = COALESCE(I.IdPedidoProveedor, D.IdPedidoProveedor)
    FROM inserted I
    FULL OUTER JOIN deleted D ON I.IdDetallePedido = D.IdDetallePedido;

    UPDATE PP
    SET PP.TotalPedido = ISNULL((
        SELECT SUM(Subtotal)
        FROM Detalle_Pedido DP
        WHERE DP.IdPedidoProveedor = PP.IdPedidoProveedor
    ), 0)
    FROM Pedido_Proveedor PP
    WHERE PP.IdPedidoProveedor = @IdPedidoProveedor;
END;
GO


-- ==========================================
-- 🎟️ SECCIÓN 3: TRIGGERS PARA RESERVAS
-- ==========================================

-- 🔹 5. Actualizar stock automáticamente al registrar una reserva
CREATE OR ALTER TRIGGER trg_ActualizarStockReserva
ON Reserva
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Disminuir stock al reservar producto
    UPDATE P
    SET P.Stock = P.Stock - IIF(P.Stock >= 1, 1, 0)
    FROM Producto P
    INNER JOIN inserted I ON P.IdProducto = I.IdProducto
    WHERE P.Stock > 0;
END;
GO


-- 🔹 6. Devolver stock al cancelar o eliminar una reserva
CREATE OR ALTER TRIGGER trg_DevolverStockReserva
ON Reserva
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET P.Stock = P.Stock + 1
    FROM Producto P
    INNER JOIN deleted D ON P.IdProducto = D.IdProducto;
END;
GO


-- ==========================================
-- 🧾 SECCIÓN 4: AUDITORÍA GENERAL
-- ==========================================

-- Crear tabla de auditoría si no existe
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Auditoria' AND type = 'U')
BEGIN
    CREATE TABLE Auditoria (
        IdAuditoria INT IDENTITY PRIMARY KEY,
        Tabla NVARCHAR(50),
        Operacion NVARCHAR(10),
        Fecha DATETIME DEFAULT GETDATE(),
        Detalle NVARCHAR(MAX)
    );
END;
GO


-- 🔹 7. Auditoría para la tabla Cliente
CREATE OR ALTER TRIGGER trg_Auditoria_Cliente
ON Cliente
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
        'Cliente',
        @Operacion,
        CONCAT('IdCliente=', COALESCE(I.IdCliente, D.IdCliente),
               ', Nombre=', COALESCE(I.Nombre, D.Nombre),
               ', Apellidos=', COALESCE(I.Apellidos, D.Apellidos),
               ', Email=', COALESCE(I.Email, D.Email))
    FROM inserted I
    FULL OUTER JOIN deleted D ON I.IdCliente = D.IdCliente;
END;
GO


-- 🔹 8. Auditoría para la tabla Producto
CREATE OR ALTER TRIGGER trg_Auditoria_Producto
ON Producto
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
        'Producto',
        @Operacion,
        CONCAT('IdProducto=', COALESCE(I.IdProducto, D.IdProducto),
               ', Nombre=', COALESCE(I.Nombre, D.Nombre),
               ', Stock=', COALESCE(I.Stock, D.Stock),
               ', PrecioVenta=', COALESCE(I.PrecioVenta, D.PrecioVenta))
    FROM inserted I
    FULL OUTER JOIN deleted D ON I.IdProducto = D.IdProducto;
END;
GO


-- ==========================================
-- ✅ FIN DEL SCRIPT
-- ==========================================

