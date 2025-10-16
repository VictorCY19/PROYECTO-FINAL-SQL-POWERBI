use BARTO_TCG;
go

-- =============================
-- CREACION DE VISTAS 
-- =============================


-- =============================
-- VISTA EN TABLA CLIENTE 
-- =============================

CREATE OR ALTER VIEW vw_Clientes_Info
AS 
SELECT 
	c.IdCliente,
	c.Dni,
	c.Nombre,
	c.Apellidos,
	c.Email,
	COUNT(DISTINCT v.IdVenta) AS Total_Ventas,
	COUNT(DISTINCT r.IdReserva) AS Total_Reservas,
	SUM(v.Total) AS Monto_Total_Vendido

FROM Cliente c
LEFT JOIN Venta v ON c.IdCliente = v.IdCliente
LEFT JOIN Reserva r ON c.IdCliente = r.IdCliente
GROUP BY c.IdCliente, c.Dni, c.Nombre, c.Apellidos, c.Email;
go


-- ==============================
-- VISTA TABLA VENTA DETALLADA 
-- ==============================

CREATE OR ALTER VIEW vw_Ventas_Detalle
AS
SELECT 
    v.IdVenta,
    v.NumeroFactura,
    v.FechaVenta,
    c.Nombre + ' ' + c.Apellidos AS Cliente,
    p.Nombre AS Producto,
    dv.Cantidad,
    dv.PrecioUnitario,
    dv.Subtotal,
    v.Igv,
    v.Total,
    mp.Nombre AS MetodoPago
FROM Venta v
INNER JOIN Cliente c ON v.IdCliente = c.IdCliente
INNER JOIN Detalle_Venta dv ON v.IdVenta = dv.IdVenta
INNER JOIN Producto p ON dv.IdProducto = p.IdProducto
INNER JOIN Metodo_Pago mp ON v.IdMetodoPago = mp.IdMetodoPago;
GO


-- ==============================
-- VISTA STOCK DE PRODUCTOS
-- ==============================

CREATE OR ALTER VIEW vw_Productos_Stock
AS
SELECT 
    p.IdProducto,
    p.Nombre AS Producto,
    f.Nombre AS Franquicia,
    tp.Nombre AS TipoProducto,
    p.PrecioVenta,
    p.Stock,
    CASE 
        WHEN p.Stock <= 5 THEN 'BAJO'
        WHEN p.Stock BETWEEN 6 AND 20 THEN 'MEDIO'
        ELSE 'ALTO'
    END AS NivelStock
FROM Producto p
INNER JOIN Franquicia f ON p.IdFranquicia = f.IdFranquicia
INNER JOIN Tipo_Producto tp ON p.IdTipoProducto = tp.IdTipoProducto;
GO


-- ==============================
-- VISTA PEDIDOS A PROVEEDOREs 
-- ==============================

CREATE OR ALTER VIEW vw_Pedidos_Proveedor
AS
SELECT 
    pp.IdPedidoProveedor,
    pr.Nombre + ' ' + pr.Apellido AS Proveedor,
    pp.FechaPedido,
    pp.Estado,
    pp.TotalPedido,
    COUNT(dp.IdDetallePedido) AS TotalItems
FROM Pedido_Proveedor pp
INNER JOIN Proveedor pr ON pp.IdProveedor = pr.IdProveedor
LEFT JOIN Detalle_Pedido dp ON pp.IdPedidoProveedor = dp.IdPedidoProveedor
GROUP BY pp.IdPedidoProveedor, pr.Nombre, pr.Apellido, pp.FechaPedido, pp.Estado, pp.TotalPedido;
GO


-- ==============================
-- VISTA RESERVA DETALLADA 
-- ==============================

CREATE OR ALTER VIEW vw_Reservas_Detalle
AS
SELECT 
    r.IdReserva,
    c.Nombre + ' ' + c.Apellidos AS Cliente,
    p.Nombre AS Producto,
    r.FechaReserva,
    r.Cantidad,
    r.Adelanto,
    r.Estado
FROM Reserva r
INNER JOIN Cliente c ON r.IdCliente = c.IdCliente
INNER JOIN Producto p ON r.IdProducto = p.IdProducto;
GO


