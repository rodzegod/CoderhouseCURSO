-- // POSICIONARSE EN LA BASE DE DATOS HECHA POR RODRIGO DIEGO //

USE Ventas_Tech_DB;
GO

/*
==========================================
==========================================
SE AGREGARON VALORES NUEVOS EN VENTAS_TECH PARA HACER MÁS RICO EL ANÁLISIS

EMPEZAMOS CON LAS CONSULTAS SOBRE LA BASE DE DATOS
==========================================
==========================================
*/

/*
==========================================
==========================================
Consulta 1 — Resumen ejecutivo mensual Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. 
Calculá el total como cantidad * precio_unitario. Usá alias descriptivos en español y agrupá por mes con (MONTH FROM fecha_venta).
==========================================
==========================================
*/

SELECT 
	COUNT(*) AS Cantidad_de_Pedidos,
	SUM(cantidad * precio_unitario) AS Total_Facturado,
	SUM(cantidad * precio_unitario) / COUNT(*) AS Ticket_Promedio,
	MONTH(fecha_venta) AS Mes
FROM dbo.ventas
GROUP BY Month(fecha_venta)
ORDER BY Mes;



/*
==========================================
==========================================
Consulta 2 — Ranking de productos Top 5 de id_producto por total facturado, mostrando las unidades vendidas (SUM(cantidad)) y el total generado. 
Usá GROUP BY id_producto, ORDER BY y limitá el resultado a 5.
==========================================
==========================================
*/

SELECT TOP 5 
	id_producto AS id_producto, 
	SUM(cantidad) AS UnidadesVendidas,
	SUM(cantidad * precio_unitario) AS Total_Facturado
	
FROM dbo.ventas
GROUP BY id_producto ORDER BY 3 DESC;


/*
==========================================
==========================================
Consulta 3 — Clientes recurrentes id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. 
Usá GROUP BY id_cliente y HAVING COUNT(*) > 1.
==========================================
==========================================
*/

SELECT
	id_cliente AS Cliente,
	COUNT(*) AS Cantidad_de_Pedidos,
	SUM(cantidad * precio_unitario) AS Total_Gastado
FROM dbo.ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

/*
==========================================
==========================================
Consulta 4 — Meses por encima/por debajo del promedio Total facturado por mes. 
Con una columna adicional que etiquete con CASE WHEN si ese mes quedó 'Por encima' o 'Por debajo' del promedio mensual general.
==========================================
==========================================
*/

SELECT
	SUM(cantidad * precio_unitario) AS Total_Facturado,
	MONTH(fecha_venta) AS Mes,
	CASE
		WHEN SUM(cantidad * precio_unitario) > 5648 THEN 'Por encima'
		ELSE 'Por debajo'
		END AS Promedio_Mensual
FROM dbo.ventas
GROUP BY MONTH(fecha_venta) ORDER BY Mes;


/*
==========================================
==========================================
BLOQUE DE CIERRE // HALLAZGOS A TRAVÉS DE LAS CONSULTAS

==========================================
==========================================

*/

-- HALLAZGO 1: Febrero tuvo una caída del 65% en facturación respecto a enero ($2760 vs $7906).
-- HALLAZGO 2: Si bien el cliente 1 y el cliente 6 tienen la misma cantidad de pedidos, debido a la segmentación (Cliente '6' es B2B y Cliente '1' B2C) supone un 204% más de facturación total.
-- HALLAZGO 3: Nuestro producto estrella es ('Laptop Pro 15') con 8 unidades vendidas, para mejorar la facturación, deberia cada 'venta' tener un mix de producto más alto, vendiendo accesorios como: Producto (2, 5 o 6)