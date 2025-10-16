CREATE DATABASE BARTO_TCG;

USE BARTO_TCG;
go


------------------------------------------------------
-- 💼 BASE DE DATOS: Sistema de Ventas
-- Autor: Victor Carranza
-- Versión: 1.1 (mejorada con buenas prácticas)
-- Fecha: 2025-10-10
------------------------------------------------------

-- ===============================
-- 🔁 Eliminación controlada (solo en desarrollo)
-- ===============================
DROP TABLE IF EXISTS Detalle_Venta;
DROP TABLE IF EXISTS Venta;
DROP TABLE IF EXISTS Detalle_Pedido;
DROP TABLE IF EXISTS Pedido_Proveedor;
DROP TABLE IF EXISTS Reserva;
DROP TABLE IF EXISTS Producto;
DROP TABLE IF EXISTS Tipo_Producto;
DROP TABLE IF EXISTS Franquicia;
DROP TABLE IF EXISTS Marca;
DROP TABLE IF EXISTS Metodo_Pago;
DROP TABLE IF EXISTS Proveedor;
DROP TABLE IF EXISTS Cliente;
GO

-- ===============================
-- 👥 CLIENTES
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Cliente')
BEGIN
    CREATE TABLE Cliente (
        IdCliente INT PRIMARY KEY IDENTITY(1000,1),
        Dni CHAR(8) UNIQUE NOT NULL,
        Nombre NVARCHAR(100) NOT NULL,
        Apellidos NVARCHAR(100) NOT NULL,
        Telefono NVARCHAR(15),
        Email NVARCHAR(100) NOT NULL,
        FechaRegistro DATETIME DEFAULT GETDATE(),
        Estado BIT DEFAULT 1  -- Soft delete: 1=Activo, 0=Inactivo
    );
END;
GO

-- ===============================
-- 🚚 PROVEEDORES
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Proveedor')
BEGIN
    CREATE TABLE Proveedor (
        IdProveedor INT PRIMARY KEY IDENTITY(1000,1),
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(100),
        Telefono NVARCHAR(15),
        Email NVARCHAR(100),
        FechaRegistro DATETIME DEFAULT GETDATE()
    );
END;
GO

-- ===============================
-- 💳 MÉTODOS DE PAGO
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Metodo_Pago')
BEGIN
    CREATE TABLE Metodo_Pago (
        IdMetodoPago INT PRIMARY KEY IDENTITY(1000,1),
        Nombre NVARCHAR(50) NOT NULL
    );
END;
GO

-- ===============================
-- 🏷️ MARCAS
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Marca')
BEGIN
    CREATE TABLE Marca (
        IdMarca INT PRIMARY KEY IDENTITY(1000,1),
        Nombre NVARCHAR(100) NOT NULL
    );
END;
GO

-- ===============================
-- 🧩 FRANQUICIAS
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Franquicia')
BEGIN
    CREATE TABLE Franquicia (
        IdFranquicia INT PRIMARY KEY IDENTITY(1000,1),
        Nombre NVARCHAR(100) NOT NULL,
        IdMarca INT NOT NULL,
        CONSTRAINT FK_Franquicia_Marca FOREIGN KEY (IdMarca)
            REFERENCES Marca(IdMarca)
            ON DELETE CASCADE
    );
END;
GO

-- ===============================
-- 🧱 TIPOS DE PRODUCTO
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Tipo_Producto')
BEGIN
    CREATE TABLE Tipo_Producto (
        IdTipoProducto INT PRIMARY KEY IDENTITY(1000,1),
        Nombre NVARCHAR(100) NOT NULL
    );
END;
GO

-- ===============================
-- 📦 PRODUCTOS
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Producto')
BEGIN
    CREATE TABLE Producto (
        IdProducto INT PRIMARY KEY IDENTITY(1000,1),
        IdFranquicia INT NOT NULL,
        IdTipoProducto INT NOT NULL,
        Nombre NVARCHAR(200) NOT NULL,
        PrecioCompra DECIMAL(10,2) NOT NULL,
        PrecioVenta DECIMAL(10,2) NOT NULL,
        Stock INT NOT NULL DEFAULT 0,
        FechaRegistro DATETIME DEFAULT GETDATE(),
        Estado BIT DEFAULT 1,
        CONSTRAINT FK_Producto_Franquicia FOREIGN KEY (IdFranquicia)
            REFERENCES Franquicia(IdFranquicia)
            ON DELETE NO ACTION,
        CONSTRAINT FK_Producto_TipoProducto FOREIGN KEY (IdTipoProducto)
            REFERENCES Tipo_Producto(IdTipoProducto)
            ON DELETE NO ACTION
    );
END;
GO

-- ===============================
-- 🧾 PEDIDOS A PROVEEDORES
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pedido_Proveedor')
BEGIN
    CREATE TABLE Pedido_Proveedor (
        IdPedidoProveedor INT PRIMARY KEY IDENTITY(1000,1),
        IdProveedor INT NOT NULL,
        FechaPedido DATETIME DEFAULT GETDATE(),
        Estado NVARCHAR(20) DEFAULT 'PENDIENTE',
        TotalPedido DECIMAL(10,2),
        CONSTRAINT FK_Pedido_Proveedor FOREIGN KEY (IdProveedor)
            REFERENCES Proveedor(IdProveedor)
            ON DELETE NO ACTION
    );
END;
GO

-- ===============================
-- 📋 DETALLE DE PEDIDO
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Detalle_Pedido')
BEGIN
    CREATE TABLE Detalle_Pedido (
        IdDetallePedido INT PRIMARY KEY IDENTITY(1000,1),
        IdPedidoProveedor INT NOT NULL,
        IdProducto INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (IdPedidoProveedor)
            REFERENCES Pedido_Proveedor(IdPedidoProveedor)
            ON DELETE CASCADE,
        CONSTRAINT FK_DetallePedido_Producto FOREIGN KEY (IdProducto)
            REFERENCES Producto(IdProducto)
            ON DELETE NO ACTION
    );
END;
GO

ALTER TABLE Detalle_Pedido
ADD Subtotal AS (Cantidad * PrecioUnitario) PERSISTED;

-- ===============================
-- 🧾 VENTAS
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Venta')
BEGIN
    CREATE TABLE Venta (
        IdVenta INT PRIMARY KEY IDENTITY(1000,1),
        NumeroFactura VARCHAR(20) UNIQUE,
        IdCliente INT NOT NULL,
        IdMetodoPago INT NOT NULL,
        FechaVenta DATETIME DEFAULT GETDATE(),
        Subtotal DECIMAL(10,2) NOT NULL,
        Igv DECIMAL(10,2) NOT NULL,
        Total DECIMAL(10,2) NOT NULL,
        Estado NVARCHAR(20) DEFAULT 'COMPLETADA',
        CONSTRAINT FK_Venta_Cliente FOREIGN KEY (IdCliente)
            REFERENCES Cliente(IdCliente)
            ON DELETE NO ACTION,
        CONSTRAINT FK_Venta_MetodoPago FOREIGN KEY (IdMetodoPago)
            REFERENCES Metodo_Pago(IdMetodoPago)
            ON DELETE NO ACTION
    );
END;
GO

-- ===============================
-- 🧾 DETALLE DE VENTAS
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Detalle_Venta')
BEGIN
    CREATE TABLE Detalle_Venta (
        IdDetalleVenta INT PRIMARY KEY IDENTITY(1000,1),
        IdVenta INT NOT NULL,
        IdProducto INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10,2) NOT NULL,
        Subtotal DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (IdVenta)
            REFERENCES Venta(IdVenta)
            ON DELETE CASCADE,
        CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (IdProducto)
            REFERENCES Producto(IdProducto)
            ON DELETE NO ACTION
    );
END;
GO

-- ===============================
-- 🕒 RESERVAS (PREVENTAS)
-- ===============================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reserva')
BEGIN
    CREATE TABLE Reserva (
        IdReserva INT PRIMARY KEY IDENTITY(1000,1),
        IdCliente INT NOT NULL,
        IdProducto INT NOT NULL,
        FechaReserva DATETIME DEFAULT GETDATE(),
        Adelanto DECIMAL(10,2) NOT NULL,
        Cantidad INT NOT NULL,
        Estado NVARCHAR(20) DEFAULT 'PENDIENTE',
        CONSTRAINT FK_Reserva_Cliente FOREIGN KEY (IdCliente)
            REFERENCES Cliente(IdCliente)
            ON DELETE NO ACTION,
        CONSTRAINT FK_Reserva_Producto FOREIGN KEY (IdProducto)
            REFERENCES Producto(IdProducto)
            ON DELETE NO ACTION
    );
END;
GO


 
