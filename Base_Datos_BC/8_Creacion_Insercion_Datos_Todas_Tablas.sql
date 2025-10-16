use BARTO_TCG;
go


-- ================================
-- INSERCION DE DATOS EN LAS TABLAS
-- ================================


--======TABLA MARCA ===============
INSERT INTO Marca (Nombre)
VALUES 
    ('Bandai'),
    ('Konami'),
    ('Bushiroad'),
    ('Nintendo'),
    ('Fantasy Flight Games'),
    ('Wizards of the Coast');

PRINT '✅ Datos insertados correctamente en la tabla Marca.';
GO


--==========TABLA FRANQUICIA ======================
INSERT INTO Franquicia (Nombre, IdMarca)
SELECT 'One Piece TCG', M.IdMarca FROM Marca M WHERE M.Nombre = 'Bandai'
UNION ALL
SELECT 'Dragon Ball Super Card Game', M.IdMarca FROM Marca M WHERE M.Nombre = 'Bandai'
UNION ALL
SELECT 'Yu-Gi-Oh! TCG', M.IdMarca FROM Marca M WHERE M.Nombre = 'Konami'
UNION ALL
SELECT 'Cardfight!! Vanguard', M.IdMarca FROM Marca M WHERE M.Nombre = 'Bushiroad'
UNION ALL
SELECT 'Weiß Schwarz', M.IdMarca FROM Marca M WHERE M.Nombre = 'Bushiroad'
UNION ALL
SELECT 'Pokémon TCG', M.IdMarca FROM Marca M WHERE M.Nombre = 'Nintendo'
UNION ALL
SELECT 'Magic: The Gathering', M.IdMarca FROM Marca M WHERE M.Nombre = 'Wizards of the Coast'
UNION ALL
SELECT 'Star Wars Unlimited', M.IdMarca FROM Marca M WHERE M.Nombre = 'Fantasy Flight Games';

PRINT '✅ Datos insertados correctamente en la tabla Franquicia.';
GO


-- ==========TABLA TIPO PRODUCTO ===============
INSERT INTO Tipo_Producto (Nombre)
VALUES ('Booster Box'),
       ('Booster Pack'),
       ('Starter Deck'),
       ('Structure Deck'),
       ('Collector Deck'),
       ('Accesorios'),
       ('Cartas Sueltas'),
       ('Productos Promocionales');

PRINT '✅ Datos insertados correctamente en Tipo_Producto.';
GO


-- ============TABLA PRODUCTO ================
INSERT INTO Producto (Nombre, IdFranquicia, IdTipoProducto, PrecioCompra, PrecioVenta, Stock)
SELECT 'One Piece TCG - Romance Dawn Booster Box', F.IdFranquicia, TP.IdTipoProducto, 350.00, 450.00, 25
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'One Piece TCG' AND TP.Nombre = 'Booster Box'
UNION ALL
SELECT 'One Piece TCG - Starter Deck Straw Hat Crew', F.IdFranquicia, TP.IdTipoProducto, 70.00, 95.00, 40
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'One Piece TCG' AND TP.Nombre = 'Starter Deck'
UNION ALL
SELECT 'Dragon Ball Super - Fusion World Booster Pack', F.IdFranquicia, TP.IdTipoProducto, 12.00, 20.00, 150
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Dragon Ball Super Card Game' AND TP.Nombre = 'Booster Pack'
UNION ALL
SELECT 'Yu-Gi-Oh! - Structure Deck: Fire Kings', F.IdFranquicia, TP.IdTipoProducto, 50.00, 80.00, 35
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Yu-Gi-Oh! TCG' AND TP.Nombre = 'Structure Deck'
UNION ALL
SELECT 'Yu-Gi-Oh! - 25th Anniversary Collector Deck', F.IdFranquicia, TP.IdTipoProducto, 300.00, 399.00, 10
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Yu-Gi-Oh! TCG' AND TP.Nombre = 'Collector Deck'
UNION ALL
SELECT 'Pokémon TCG - Paldea Evolved Booster Box', F.IdFranquicia, TP.IdTipoProducto, 420.00, 550.00, 20
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Pokémon TCG' AND TP.Nombre = 'Booster Box'
UNION ALL
SELECT 'Cardfight!! Vanguard - Booster Pack 06 Blazing Dragon Reborn', F.IdFranquicia, TP.IdTipoProducto, 13.00, 20.00, 120
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Cardfight!! Vanguard' AND TP.Nombre = 'Booster Pack'
UNION ALL
SELECT 'Weiß Schwarz - Attack on Titan Collector Deck', F.IdFranquicia, TP.IdTipoProducto, 230.00, 320.00, 15
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Weiß Schwarz' AND TP.Nombre = 'Collector Deck'
UNION ALL
SELECT 'Star Wars Unlimited - Starter Deck Jedi', F.IdFranquicia, TP.IdTipoProducto, 65.00, 90.00, 25
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Star Wars Unlimited' AND TP.Nombre = 'Starter Deck'
UNION ALL
SELECT 'Magic: The Gathering - Modern Horizons 3 Booster Box', F.IdFranquicia, TP.IdTipoProducto, 780.00, 950.00, 8
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Magic: The Gathering' AND TP.Nombre = 'Booster Box'
UNION ALL
SELECT 'Dragon Ball Super - Card Sleeves Vegeta', F.IdFranquicia, TP.IdTipoProducto, 20.00, 30.00, 60
FROM Franquicia F, Tipo_Producto TP WHERE F.Nombre = 'Dragon Ball Super Card Game' AND TP.Nombre = 'Accesorios';

PRINT '✅ Datos insertados correctamente en la tabla Producto.';
GO


-- ============TABLA PROVEEDOR ==================
INSERT INTO Proveedor (Nombre, Apellido, Telefono, Email)
VALUES 
('Luis', 'Gómez', '+51987456321', 'lgomez@tcgdistribuidora.com'),
('María', 'Rodríguez', '+51965874321', 'mrodriguez@pokemondistribuidores.pe'),
('Jorge', 'Paredes', '+51976321458', 'jparedes@bandai.pe'),
('Carla', 'Huamán', '+51964231587', 'chuaman@yugiohtrading.pe'),
('Ricardo', 'Campos', '+51981234567', 'rcampos@magiclatam.com'),
('Diana', 'Torres', '+51991239876', 'dtorres@vanguardperu.com'),
('Pedro', 'Soto', '+51975412369', 'psoto@weissschwarz.com'),
('Verónica', 'Luna', '+51983451236', 'vluna@starwarscards.pe'),
('Miguel', 'Ruiz', '+51974382159', 'mruiz@dragonballcards.pe'),
('Ana', 'Fernández', '+51961478523', 'afernandez@tcgimport.pe');

PRINT '✅ Datos insertados correctamente en la tabla Proveedor.';
GO


-- ==========TABLA PEDIDO_PROVEEDOR ==================
INSERT INTO Pedido_Proveedor (IdProveedor, FechaPedido, Estado, TotalPedido)
SELECT P.IdProveedor, '2024-07-10', 'Completado', 4200.50 FROM Proveedor P WHERE P.Nombre = 'Luis'
UNION ALL
SELECT P.IdProveedor, '2024-08-22', 'Completado', 3850.75 FROM Proveedor P WHERE P.Nombre = 'María'
UNION ALL
SELECT P.IdProveedor, '2024-09-05', 'Pendiente', 2900.00 FROM Proveedor P WHERE P.Nombre = 'Jorge'
UNION ALL
SELECT P.IdProveedor, '2024-10-18', 'Completado', 5100.00 FROM Proveedor P WHERE P.Nombre = 'Carla'
UNION ALL
SELECT P.IdProveedor, '2024-11-30', 'Cancelado', 0.00 FROM Proveedor P WHERE P.Nombre = 'Ricardo'
UNION ALL
SELECT P.IdProveedor, '2025-01-12', 'Pendiente', 3600.00 FROM Proveedor P WHERE P.Nombre = 'Diana'
UNION ALL
SELECT P.IdProveedor, '2025-02-03', 'Completado', 4100.00 FROM Proveedor P WHERE P.Nombre = 'Pedro'
UNION ALL
SELECT P.IdProveedor, '2025-03-25', 'Pendiente', 2700.50 FROM Proveedor P WHERE P.Nombre = 'Verónica'
UNION ALL
SELECT P.IdProveedor, '2025-04-10', 'Completado', 4550.00 FROM Proveedor P WHERE P.Nombre = 'Miguel'
UNION ALL
SELECT P.IdProveedor, '2025-05-15', 'Completado', 3900.25 FROM Proveedor P WHERE P.Nombre = 'Ana';

PRINT '✅ Datos insertados correctamente en la tabla Pedido_Proveedor.';
GO


-- ==============TABLA DETALLE_PEDIDO ======================
INSERT INTO Detalle_Pedido (IdPedidoProveedor, IdProducto, Cantidad, PrecioUnitario)
SELECT PP.IdPedidoProveedor, P.IdProducto, 30, 110.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Booster Box%'
WHERE PP.IdPedidoProveedor = 1000
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 50, 12.50
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Booster Pack%'
WHERE PP.IdPedidoProveedor = 1000
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 40, 65.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Starter%'
WHERE PP.IdPedidoProveedor = 1001
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 20, 95.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Structure%'
WHERE PP.IdPedidoProveedor = 1001
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 60, 10.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Booster Pack%'
WHERE PP.IdPedidoProveedor = 1002
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 10, 125.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Collector%'
WHERE PP.IdPedidoProveedor = 1003
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 15, 105.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Booster Box%'
WHERE PP.IdPedidoProveedor = 1004
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 25, 60.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Starter%'
WHERE PP.IdPedidoProveedor = 1005
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 40, 11.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Booster Pack%'
WHERE PP.IdPedidoProveedor = 1006
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 8, 250.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Accesorio%'
WHERE PP.IdPedidoProveedor = 1007
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 20, 120.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Booster Box%'
WHERE PP.IdPedidoProveedor = 1008
UNION ALL
SELECT PP.IdPedidoProveedor, P.IdProducto, 25, 65.00
FROM Pedido_Proveedor PP
JOIN Producto P ON P.Nombre LIKE '%Starter%'
WHERE PP.IdPedidoProveedor = 1009;

PRINT '✅ Datos insertados correctamente en la tabla Detalle_Pedido.';
GO


-- ==============TABLA CLIENTE =======================
INSERT INTO Cliente (Dni, Nombre, Apellidos, Telefono, Email, FechaRegistro, Estado)
VALUES
('72543109', 'Luis', 'Ramírez Torres', '987654321', 'lramirez@gmail.com', '2024-07-15', 1),
('74289122', 'María', 'Gonzales Díaz', '912345678', 'maria.gdiaz@hotmail.com', '2024-08-03', 1),
('70891245', 'Carlos', 'Pérez Huamán', '956712389', 'cperez@outlook.com', '2024-09-10', 1),
('76983412', 'Lucía', 'Flores Vega', '998273645', 'luciaflores@gmail.com', '2024-10-22', 1),
('70129348', 'Miguel', 'Soto Rivas', '987112345', 'msoto@gmail.com', '2024-11-08', 1),
('75501928', 'Andrea', 'Castro Ramos', '934562178', 'andrea.castro@gmail.com', '2024-12-19', 1),
('73651234', 'José', 'Quispe Lázaro', '975348219', 'jquispe@yahoo.com', '2025-01-09', 1),
('72984210', 'Valeria', 'Huerta León', '963214785', 'valeria.huerta@gmail.com', '2025-02-14', 1),
('71345690', 'Diego', 'Paredes Salazar', '954872631', 'diego.ps@hotmail.com', '2025-03-03', 1),
('70234987', 'Camila', 'Vásquez Campos', '987654320', 'cvasquez@gmail.com', '2025-04-17', 1),
('72619834', 'Javier', 'Reyes Delgado', '933478901', 'jreyes@gmail.com', '2025-05-29', 1),
('71452309', 'Daniela', 'Cruz Torres', '944123987', 'daniela.cruz@gmail.com', '2025-06-21', 1),
('71209876', 'Fernando', 'Arévalo Ruiz', '955871234', 'farevalo@gmail.com', '2024-07-29', 1),
('73567812', 'Rosa', 'Valdivia López', '912349876', 'rosavl@gmail.com', '2024-08-18', 1),
('71982345', 'Sofía', 'Mendoza Prado', '999888777', 'sofia.mendoza@gmail.com', '2025-01-28', 1);

PRINT '✅ Datos insertados correctamente en la tabla Cliente.';
GO



-- ==========TABLA VENTA ================

-- Inserta 20 ventas aleatorias pero coherentes
DECLARE @clientesv TABLE (IdCliente INT);
INSERT INTO @clientesv SELECT IdCliente FROM Cliente;

DECLARE @metodosv TABLE (IdMetodoPago INT, Metodo NVARCHAR(50));
INSERT INTO @metodosv SELECT IdMetodoPago, Nombre FROM Metodo_Pago;

-- Inserta 20 ventas aleatorias pero coherentes
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
    DECLARE @clienteId INT = (SELECT TOP 1 IdCliente FROM @clientesv ORDER BY NEWID());
    DECLARE @metodoId INT = (SELECT TOP 1 IdMetodoPago FROM @metodosv ORDER BY NEWID());
    DECLARE @fecha DATETIME = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2024-07-01');
    DECLARE @subtotal DECIMAL(10,2) = ROUND((100 + (RAND() * 900)), 2);
    DECLARE @igv DECIMAL(10,2) = ROUND(@subtotal * 0.18, 2);
    DECLARE @total DECIMAL(10,2) = @subtotal + @igv;
    DECLARE @estado NVARCHAR(20) = CASE 
                                      WHEN RAND() < 0.85 THEN 'Pagado'
                                      ELSE 'Cancelado'
                                   END;
    DECLARE @factura NVARCHAR(20) = CONCAT('FAC-', FORMAT(10000 + @i, '00000'));

    INSERT INTO Venta (NumeroFactura, IdCliente, IdMetodoPago, FechaVenta, Subtotal, Igv, Total, Estado)
    VALUES (@factura, @clienteId, @metodoId, @fecha, @subtotal, @igv, @total, @estado);

    SET @i += 1;
END;

PRINT '✅ Ventas simuladas insertadas correctamente.';
GO



-- ============TABLA DETALLE_VENTA ==================
PRINT '--- Insertando datos extendidos en Detalle_Venta ---';
SET IDENTITY_INSERT Detalle_Venta ON;

INSERT INTO Detalle_Venta (IdDetalleVenta, IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal)
VALUES
-- Venta 999
(1000, 999, 1001, 1, 95.00, 95.00),
(1001, 999, 1003, 2, 180.00, 360.00),
(1002, 999, 1008, 1, 210.00, 210.00),

-- Venta 1000
(1003, 1000, 1002, 2, 160.00, 320.00),
(1004, 1000, 1005, 1, 75.00, 75.00),
(1005, 1000, 1009, 3, 35.00, 105.00),

-- Venta 1001
(1006, 1001, 1004, 2, 120.00, 240.00),
(1007, 1001, 1006, 1, 60.00, 60.00),

-- Venta 1002
(1008, 1002, 1007, 3, 70.00, 210.00),
(1009, 1002, 1009, 2, 40.00, 80.00),
(1010, 1002, 1003, 1, 250.00, 250.00),

-- Venta 1003
(1011, 1003, 1005, 2, 140.00, 280.00),
(1012, 1003, 1008, 1, 220.00, 220.00),

-- Venta 1004
(1013, 1004, 1002, 3, 150.00, 450.00),
(1014, 1004, 1006, 2, 90.00, 180.00),
(1015, 1004, 1010, 1, 130.00, 130.00),

-- Venta 1005
(1016, 1005, 1003, 2, 175.00, 350.00),
(1017, 1005, 1004, 1, 115.00, 115.00),

-- Venta 1006
(1018, 1006, 1007, 3, 80.00, 240.00),
(1019, 1006, 1005, 1, 75.00, 75.00),
(1020, 1006, 1008, 2, 210.00, 420.00),

-- Venta 1007
(1021, 1007, 1001, 1, 95.00, 95.00),
(1022, 1007, 1006, 2, 60.00, 120.00),
(1023, 1007, 1009, 3, 30.00, 90.00),

-- Venta 1008
(1024, 1008, 1002, 2, 170.00, 340.00),
(1025, 1008, 1003, 1, 250.00, 250.00),

-- Venta 1009
(1026, 1009, 1008, 2, 265.00, 530.00),
(1027, 1009, 1005, 1, 70.00, 70.00),

-- Venta 1010
(1028, 1010, 1007, 2, 75.00, 150.00),
(1029, 1010, 1009, 3, 40.00, 120.00),
(1030, 1010, 1004, 1, 100.00, 100.00),

-- Venta 1011
(1031, 1011, 1001, 1, 95.00, 95.00),
(1032, 1011, 1006, 2, 60.00, 120.00),

-- Venta 1012
(1033, 1012, 1008, 2, 190.00, 380.00),
(1034, 1012, 1003, 1, 220.00, 220.00),

-- Venta 1013
(1035, 1013, 1002, 3, 150.00, 450.00),
(1036, 1013, 1009, 2, 35.00, 70.00),

-- Venta 1014
(1037, 1014, 1005, 1, 75.00, 75.00),
(1038, 1014, 1007, 3, 85.00, 255.00),

-- Venta 1015
(1039, 1015, 1003, 2, 180.00, 360.00),
(1040, 1015, 1006, 2, 110.00, 220.00),

-- Venta 1016
(1041, 1016, 1008, 1, 210.00, 210.00),
(1042, 1016, 1009, 2, 45.00, 90.00),
(1043, 1016, 1004, 1, 105.00, 105.00),

-- Venta 1017
(1044, 1017, 1002, 3, 160.00, 480.00),
(1045, 1017, 1005, 1, 80.00, 80.00),

-- Venta 1018
(1046, 1018, 1007, 2, 95.00, 190.00),
(1047, 1018, 1003, 1, 250.00, 250.00),
(1048, 1018, 1006, 2, 100.00, 200.00);

SET IDENTITY_INSERT Detalle_Venta OFF;
PRINT '✅ Datos extendidos insertados correctamente en Detalle_Venta.';
GO


-- ==========TABLA RESERVA ===================
INSERT INTO Reserva (IdCliente, IdProducto, FechaReserva, Adelanto, Cantidad, Estado)
VALUES
-- 🧾 Cliente 1000
(1000, 1001, '2024-07-12 10:15', 60.00, 2, 'PENDIENTE'),
(1000, 1004, '2024-08-03 11:45', 80.00, 1, 'CONFIRMADA'),
(1000, 1006, '2024-09-10 09:30', 50.00, 1, 'CANCELADA'),

-- 🧾 Cliente 1001
(1001, 1005, '2024-07-28 15:00', 90.00, 2, 'PENDIENTE'),
(1001, 1008, '2024-09-16 13:25', 110.00, 3, 'CONFIRMADA'),

-- 🧾 Cliente 1002
(1002, 1002, '2024-08-05 09:40', 70.00, 1, 'CONFIRMADA'),
(1002, 1007, '2024-10-01 17:15', 150.00, 2, 'PENDIENTE'),

-- 🧾 Cliente 1003
(1003, 1003, '2024-09-20 12:00', 60.00, 2, 'CONFIRMADA'),
(1003, 1005, '2024-11-02 10:10', 100.00, 3, 'PENDIENTE'),
(1003, 1009, '2025-01-04 18:20', 50.00, 1, 'CANCELADA'),

-- 🧾 Cliente 1004
(1004, 1001, '2024-09-28 08:40', 90.00, 1, 'PENDIENTE'),
(1004, 1004, '2024-11-12 14:35', 120.00, 2, 'CONFIRMADA'),

-- 🧾 Cliente 1005
(1005, 1006, '2024-10-07 16:00', 30.00, 1, 'PENDIENTE'),
(1005, 1008, '2024-12-19 10:55', 150.00, 2, 'CONFIRMADA'),
(1005, 1002, '2025-02-03 09:20', 60.00, 1, 'CONFIRMADA'),

-- 🧾 Cliente 1006
(1006, 1007, '2024-10-26 12:10', 75.00, 2, 'PENDIENTE'),
(1006, 1003, '2025-01-11 15:40', 100.00, 1, 'CONFIRMADA'),

-- 🧾 Cliente 1007
(1007, 1009, '2024-11-05 09:00', 45.00, 1, 'CONFIRMADA'),
(1007, 1001, '2025-02-20 11:35', 80.00, 2, 'PENDIENTE'),

-- 🧾 Cliente 1008
(1008, 1005, '2024-12-15 13:25', 120.00, 3, 'CONFIRMADA'),
(1008, 1008, '2025-03-09 17:10', 70.00, 1, 'PENDIENTE'),
(1008, 1006, '2025-04-02 10:00', 90.00, 2, 'CONFIRMADA'),

-- 🧾 Cliente 1009
(1009, 1003, '2024-11-23 15:30', 60.00, 1, 'PENDIENTE'),
(1009, 1007, '2025-01-27 09:50', 110.00, 2, 'CONFIRMADA'),

-- 🧾 Cliente 1010
(1010, 1002, '2024-12-29 11:45', 70.00, 1, 'CONFIRMADA'),
(1010, 1004, '2025-02-25 14:20', 95.00, 2, 'PENDIENTE'),
(1010, 1009, '2025-05-13 16:30', 50.00, 1, 'CANCELADA'),

-- 🧾 Cliente 1011
(1011, 1001, '2025-01-09 12:15', 90.00, 2, 'CONFIRMADA'),
(1011, 1006, '2025-03-18 18:05', 100.00, 3, 'PENDIENTE'),

-- 🧾 Cliente 1012
(1012, 1005, '2025-02-08 09:10', 60.00, 1, 'CONFIRMADA'),
(1012, 1008, '2025-04-11 13:50', 120.00, 2, 'CONFIRMADA'),

-- 🧾 Cliente 1013
(1013, 1002, '2025-03-02 15:25', 70.00, 2, 'PENDIENTE'),
(1013, 1007, '2025-05-20 09:40', 90.00, 3, 'CONFIRMADA'),

-- 🧾 Cliente 1014
(1014, 1004, '2025-04-06 10:30', 80.00, 1, 'CONFIRMADA');
GO


