-- Query 01: Mostrar la cantidad de insumos que se utiliza para cada medicamento.
SELECT COUNT(*) AS cantidadInsumos, m.nombre medicamento 
FROM insumo i
    JOIN formula f ON i.idInsumo = f.idInsumo
    JOIN medicamento m ON f.idMedicamento = m.idMedicamento
GROUP BY m.idMedicamento;

-- Query 02: Muestra el nombre del medicamento, la presentacion o presentaciones, el tamaño de la presentacion y la unidad correspondiente (ordenarlo alfabeticamente)
SELECT m.nombre medicamento, tp.nombre tipoPresentacion, p.tamaño, um.nombre unidad 
FROM TipoPresentacion tp
	JOIN Presentacion p ON tp.idTipoPresentacion = p.idPresentacion
    JOIN UnidadMedida um ON um.idUnidad = p.idUnidad
    JOIN MedicamentoPresentacion mp ON mp.idPresentacion = p.idPresentacion
    JOIN Medicamento m ON m.idMedicamento = mp.idMedicamento
ORDER BY m.nombre;


-- Query 03: Mostrar la cantidad por lote que se vendió solo en el mes de noviembre de 2022.
SELECT l.nombre nombreLote, SUM(dv.cantidad) cantidadLotes 
FROM Lote l
	JOIN DetalleVenta dv ON l.idLote = dv.idLote
	JOIN Venta v ON dv.idVenta = v.idVenta
WHERE month(fechaVenta)=11 AND year(fechaVenta)=2022
GROUP BY l.idLote
ORDER BY cantidadLotes DESC;

-- Query 04: Mostrar qué lotes han sido vendidos más de 3 veces. (Indicar el número de veces que se ha vendido y el nombre del lote)
SELECT l.nombre nombreLote, COUNT(*) numVentas 
FROM Lote l
	JOIN DetalleVenta dv ON l.idLote = dv.idLote
GROUP BY l.idLote HAVING COUNT(*)>3
ORDER BY numVentas DESC;

-- Query 05: Mostrar el nombre del cliente y la cantidad de lotes que conforma su compra. Además, ordenar los clientes descendentemense según la cantidad de lotes que compró.
SELECT c.nombreEmpresa, SUM(dv.cantidad) cantidadLotes 
FROM Cliente c
	JOIN Venta v ON c.idCliente = v.idCliente
    JOIN DetalleVenta dv ON dv.idVenta = v.idVenta
GROUP BY c.idCliente
ORDER BY cantidadLotes DESC;

-- Query 06: Mostrar los montos de las ganancias por cada tipo de lote. Cada lote tiene su precio correspondiente.
SELECT l.nombre, l.precio precioLote, dv.cantidad cantidadLotes, SUM(l.precio*dv.cantidad) monto 
FROM Venta v
	JOIN DetalleVenta dv ON dv.idVenta = v.idVenta
    JOIN Lote l ON l.idlote = dv.idLote
GROUP BY l.idLote;

-- Query 07: Mostrar las empresas (clientes) que no han realizado compras en el mes de octubre de 2022
SELECT c.idCliente, c.nombreEmpresa 
FROM Cliente c
WHERE c.idCliente NOT IN (
	SELECT c.idCliente FROM Cliente c
		JOIN Venta v ON v.idCliente = c.idCliente
	WHERE month(fechaVenta)=10 AND year(fechaVenta)=2022
	GROUP BY c.idCliente
);

-- Query 08: -- Mostrar la cantidad de fases que pasa un medicamento. Indicar el nombre del medicamento y la cantidad de fases
SELECT m.nombre medicamento, COUNT(*) cantidadFases 
FROM Medicamento m
	JOIN MedicamentoFase mf ON m.idMedicamento = mf.idMedicamento
	JOIN Fase f ON f.idFase = mf.idFase
GROUP BY m.idMedicamento
ORDER BY m.idMedicamento;

-- Query 09: Mostrar a aquellos medicamentos que pasen solo por una fase e indicar qué fase han pasado
SELECT m.nombre medicamento, f.nombre 
FROM Medicamento m
	JOIN MedicamentoFase mf ON m.idMedicamento = mf.idMedicamento
	JOIN Fase f ON f.idFase = mf.idFase
GROUP BY m.idMedicamento HAVING COUNT(*)<2
ORDER BY m.idMedicamento;


-- Query 10: Mostrar la cantidad que se produce correspondiente a cada medicamentos
-- Se ve según el número de ordenes que tiene hay para cada medicamento. Se conoce la cantidad correspondiente a cada medicamento. Por ejemplo: Si en un medicamento X la cantidad que se produce es de 200 y hay 3 ordenes. Se espera que la cantidad de medicamentos a producir sea de 200*3 = 600
SELECT m.nombre medicamento, SUM(m.cantidad) cantidad 
FROM Medicamento m
	JOIN MedicamentoFase mf ON m.idMedicamento = mf.idMedicamento
	JOIN Fase f ON f.idFase = mf.idFase
GROUP BY m.idMedicamento
ORDER BY cantidad DESC;
