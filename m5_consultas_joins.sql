-- // POSICIONARSE EN LA BASE DE DATOS HECHA POR RODRIGO DIEGO //

USE Ventas_Tech_DB;
GO


/*
==========================================
==========================================
EMPEZAMOS ALTERANDO TABLAS PARA AGREGAR INFORMACIÓN REQUERIDA POR LA ENTREGA
INFORMACIÓN REQUERIDA QUE NO TENEMOS HASTA EL MOMENTO:
1- Canal (Online/Presencial)
2- Segmento (en clientes, B2B o B2C)
3- Región
==========================================
==========================================
*/

ALTER TABLE dbo.ventas
	ADD Canal VARCHAR(20)

ALTER TABLE dbo.clientes
	ADD Segmento VARCHAR(20),
		Region VARCHAR(50);

/*
==========================================
==========================================
CARGAMOS VALORES EN LAS COLUMNAS NUEVAS
// UPDATE a Ventas y Clientes //
==========================================
==========================================
*/	

UPDATE dbo.clientes
SET	Segmento = 'B2C'
WHERE id_cliente IN (1, 2, 3, 4, 5)

UPDATE dbo.clientes
SET	Segmento = 'B2B'
WHERE id_cliente IN (6, 7, 8, 9, 10)

UPDATE dbo.clientes
SET Region = 'PAMPEANA'
WHERE ciudad IN ('Buenos Aires', 'CABA', 'ROSARIO', 'SANTA FE', 'CORDOBA')

UPDATE dbo.clientes
SET Region = 'NOA'
WHERE ciudad IN ('TUCUMAN','Jujuy', 'Salta', 'Catamarca', 'La Rioja', 'Santiago del Estero')

UPDATE dbo.clientes
SET Region = 'NEA'
WHERE ciudad IN ('Misiones', 'Corrientes', 'Entre Rios', 'Chaco', 'Formosa')

UPDATE dbo.clientes
SET Region = 'CUYO'
WHERE ciudad IN ('Mendoza', 'San Juan', 'San Luis')

UPDATE dbo.clientes
SET Region = 'PATAGONIA'
WHERE ciudad IN ('Neuquen', 'Rio Negro', 'Chubut', 'Santa Cruz', 'Tierra del Fuego')

UPDATE dbo.ventas
SET Canal = 'PRESENCIAL'
WHERE id_venta IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)

UPDATE dbo.ventas
SET Canal = 'ONLINE'
WHERE id_venta IN (16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30)

/*
==========================================
==========================================
CARGA FINALIZADA
COMENZAMOS CON LOS JOIN de Consultas
==========================================
==========================================
*/	

/* 
==============================================================================================================================================================================================
==============================================================================================================================================================================================
Consulta 1 — Vista base del proyecto (INNER JOIN) Combiná ventas, clientes, productos y territorios para obtener en una sola fila: 
Fecha, nombre del cliente, segmento, región, nombre del producto, categoría, cantidad, precio unitario, total de venta y canal. Esta consulta será la fuente de datos principal en Power BI.
==============================================================================================================================================================================================
==============================================================================================================================================================================================
*/


SELECT
	v.fecha_venta AS Fecha,
	c.nombre AS Nombre_Cliente,
	c.Segmento AS Segmento,
	c.Region AS Region,
	p.nombre_producto AS Nombre_del_Producto,
	ct.nombre_categoria AS Categoria,
	v.cantidad as Cantidad,
	v.precio_unitario as Precio_Unitario,
	v.precio_unitario * v.cantidad AS Venta_Total,
	v.canal AS Canal
	
FROM dbo.ventas v
JOIN dbo.clientes c
	ON	c.id_cliente = v.id_cliente
JOIN dbo.productos p
	ON p.id_producto = v.id_producto
JOIN dbo.categorias ct
	ON ct.id_categoria = p.id_categoria


-- CONSULTA 1 TERMINADA

/* 
==============================================================================================================================================================================================
==============================================================================================================================================================================================
Consulta 2 — Clientes sin ventas (LEFT JOIN) Identificá clientes registrados que aún no han realizado ninguna compra. 
Mostrá su nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.
==============================================================================================================================================================================================
==============================================================================================================================================================================================
*/

SELECT
	c.nombre AS Nombre,
	c.email AS email,
	c.fecha_registro AS Fecha_de_Registro
FROM dbo.clientes c
LEFT JOIN dbo.ventas v
	ON c.id_cliente = v.id_cliente
	WHERE v.id_cliente IS NULL

-- CONSULTA 2 TERMINADA.

/* 
==============================================================================================================================================================================================
==============================================================================================================================================================================================
Consulta 3 — Productos sin ventas (LEFT JOIN) Identificá productos del catálogo que no tienen ninguna venta registrada. 
Mostrá nombre del producto, categoría y precio. Usá WHERE ... IS NULL.
==============================================================================================================================================================================================
==============================================================================================================================================================================================
*/

SELECT
	p.nombre_producto AS Nombre_del_Producto,
	ct.nombre_categoria AS Categoria,
	p.precio AS Precio
FROM dbo.productos p
INNER JOIN dbo.categorias ct
	ON ct.id_categoria = p.id_categoria
LEFT JOIN dbo.ventas v
	ON v.id_producto = p.id_producto
	WHERE v.id_producto IS NULL


-- CONSULTA 3 TERMINADA.

/* 
==============================================================================================================================================================================================
==============================================================================================================================================================================================
Consulta 4 — Consolidado por canal (UNION ALL) Usá UNION ALL para combinar en un solo resultado las ventas Online y Presencial.
Agregando una columna canal que identifique el origen de cada fila. Al final calculá el total por canal con un GROUP BY.
==============================================================================================================================================================================================
==============================================================================================================================================================================================
*/

SELECT
	v.id_venta AS ID_Venta,
	v.fecha_venta AS Fecha_Venta,
	v.cantidad * v.precio_unitario AS Venta_Total,
	v.Canal AS Canal
FROM dbo.ventas v
WHERE Canal = 'PRESENCIAL'

UNION ALL

SELECT
	v.id_venta AS ID_Venta,
	v.fecha_venta AS Fecha_Venta,
	v.cantidad * v.precio_unitario AS Venta_Total,
	v.Canal AS Canal
FROM dbo.ventas v
WHERE Canal = 'ONLINE';

SELECT
    canal,
    SUM(cantidad * precio_unitario) AS Total_por_Canal
FROM dbo.ventas v
GROUP BY canal
	

-- CONSULTA 4 TERMINADA.

