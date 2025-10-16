USE BARTO_TCG;
go

-- ===============================
-- 📈 ÍNDICES RECOMENDADOS
-- ===============================



--================================
-- Indices Para Tabla Clientes 
--================================

--=========================================
-- Indices para Tabla Venta
--=========================================

-- Buscar Ventas por Cliente 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Venta_IdCliente')
	CREATE NONCLUSTERED INDEX IX_Venta_IdCliente ON Venta(IdCliente);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name ='IX_Venta_FechaVenta')
	CREATE NONCLUSTERED INDEX IX_Venta_FechaVenta ON Venta(FechaVenta);
go


-- ========================================
-- Indices para Tabla Detalle Venta 
-- ========================================

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetalleVenta_IdVenta')
	CREATE NONCLUSTERED INDEX IX_DetalleVenta_IdVenta ON Detalle_Venta(IdVenta);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Detalle_IdProducto')
	CREATE NONCLUSTERED INDEX IX_DetalleVenta_IdProducto ON Detalle_Venta(IdProducto);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetalleVenta_IdVenta_IdProducto')
	CREATE NONCLUSTERED INDEX IX_DetalleVenta_IdVenta_IdProducto ON Detalle_Venta(IdVenta, IdProducto); 
go 


-- ========================================
-- Indices de Tabla Producto 
-- ========================================

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Producto_Nombre_Stock')
	CREATE NONCLUSTERED INDEX IX_Producto_Nombre_Stock ON Producto(Nombre, Stock);
go


-- ========================================
-- Indices de Tabla Pedido Proveedor 
-- ========================================

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PedidoProveedor_IdProveedor')
	CREATE NONCLUSTERED INDEX IX_PedidoProveedor_IdProveedor ON Pedido_Proveedor(IdProveedor);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PedidoProveedor_FechaPedido')
	CREATE NONCLUSTERED INDEX IX_PedidoProveedor_FechaPedido ON Pedido_Proveedor(FechaPedido);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PedidoProveedor_Estado')
	CREATE NONCLUSTERED INDEX IX_PedidoProveedor_Estado ON Pedido_Proveedor(Estado);
go


-- =========================================
-- Indices de Tabla Detalle Pedido
-- =========================================

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetallePedido_IdPedidoProveedor')
	CREATE NONCLUSTERED INDEX IX_DetallePedido_IdPedidoProveedor ON Detalle_Pedido(IdPedidoProveedor);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetallePedido_IdProducto')
	CREATE NONCLUSTERED INDEX IX_DetallePedido_IdProducto ON Detalle_Pedido(IdProducto);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetallePedido_IdPedidoProveedor_IdProducto')
	CREATE NONCLUSTERED INDEX IX_DetallePedido_IdPedidoProveedor_IdProducto ON Detalle_Pedido(IdPedidoProveedor, IdProducto);
go


-- ========================================
-- Indices de Tabla Reservas 
-- ========================================

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Reserva_IdCliente')
	CREATE NONCLUSTERED INDEX IX_Reserva_IdCliente ON Reserva(IdCliente);
go 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Reserva_IdProducto')
	CREATE NONCLUSTERED INDEX IX_Reserva_IdProducto ON Reserva(IdProducto);
go

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Reserva_FechaReserva')
	CREATE NONCLUSTERED INDEX IX_Reserva_FechaReserva ON Reserva(FechaReserva);
go 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Reserva_Estado')
	CREATE NONCLUSTERED INDEX IX_Reserva_Estado ON Reserva(Estado);
go
