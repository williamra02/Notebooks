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

-- Query 11: Mostrar la cantidad de proveedores correspondientes por cada insumo
SELECT i.nombre insumo, COUNT(*) cantidadProveedores 
FROM Insumo i
	JOIN DetalleCompra dc ON i.idInsumo = dc.idInsumo
	JOIN Compra c ON c.idCompra = dc.idCompra
    JOIN Proveedor p ON p.rucProveedor = c.rucProveedor
GROUP BY i.idInsumo;

-- Query 12: Mostrar a aquellos proveedores que solo administran un insumo para la fabricación de medicamentos
SELECT i.nombre insumo, p.rucProveedor ruc, p.nombre proveedor 
FROM Insumo i
	JOIN DetalleCompra dc ON i.idInsumo = dc.idInsumo
	JOIN Compra c ON c.idCompra = dc.idCompra
    JOIN Proveedor p ON p.rucProveedor = c.rucProveedor
GROUP BY i.idInsumo HAVING COUNT(*)<2;

-- Query 13: Mostar nombre, apellido y cargo de los cinco empleados que recibieron más bono
SELECT d.nombres, d.apellidos, c.nombre as Cargo, SUM(b.bono) Bono
FROM empleado AS a
	JOIN historialpago AS b ON a.idEmpleado = b.idEmpleado
	JOIN cargo AS c ON c.idCargo = a.idCargo
	JOIN persona AS d ON d.idEmpleado = a.idEmpleado
GROUP BY d.nombres, d.apellidos, c.nombre
ORDER BY Bono DESC
LIMIT 5;

-- Query 14: Mostrar el tiempo total (en días) que le toma a un empleado realizar sus tareas
-- ¿Para qué sirve el DATEDIFF?
-- DATEDIFF devuelve la diferencia entre las partes  de fecha de dos expresiones de fecha u hora.
SELECT C.nombres, C.apellidos, DATEDIFF(B.fechaFinal, B.fechaInicio) as 'TiempoTarea(Dias)', B.idTarea 'numeroTarea'
FROM empleado A 
	JOIN tarea B ON A.idEmpleado=B.idEmpleado 
	JOIN persona C ON A.idEmpleado=C.idEmpleado;

-- Query 15: Mostrar la cantidad de tareas que se realiza en cada fase
SELECT f.nombre, COUNT(*) as '#tareas' FROM Tarea t
	JOIN Fase f ON t.idFase = f.idFase
GROUP BY f.idFase;

-- Query ##: Mostrar las fases con menor cantidad de tareas realizadas (REVISAR)
SELECT B.Nombre nombreFase, A.idFase , count(A.idTarea) AS '#Veces' FROM Tarea A 
	JOIN Fase B ON A.idFase=B.idFase
GROUP BY B.Nombre, A.idFase HAVING COUNT(A.idTarea) IN (
	SELECT m.conteo FROM 
		(SELECT B.Nombre, COUNT(B.idFase) AS conteo
		FROM Tarea A 
			JOIN Fase B ON A.idFase=B.idFase 
		GROUP BY B.Nombre 
        ORDER BY COUNT(B.idFase) 
        LIMIT 1) AS m
);

-- Query 16: Mostrar la cantidad de empleados por fase: CantidadEmpleados y nombrefase
-- ¿Para qué sirve el INNER JOIN?
-- INNER JOIN combina los registros de dos tablas si hay valores coincidentes en un campo común.
SELECT c.nombre AS Fase, COUNT(a.idEmpleado) AS CantidadEmpleados
FROM empleado AS a 
	INNER JOIN tarea AS b ON a.idEmpleado = b.idEmpleado
	INNER JOIN fase AS c ON c.idFase = b.idFase
GROUP BY c.idFase;

-- Query 17: Mencionar los medicamentos y la cantidad vendida de dichos productos.

-- 15 Mencionar los medicamentos y la cantidad vendida de dichos productos. Además, mencionar el porcentaje de venta de cada medicamento.
SELECT @suma:=sum(cantidad) FROM detalleventa;
SELECT A.nombre AS 'medicamento', SUM(D.cantidad) AS 'CantidadVendida',SUM(D.cantidad)/@suma AS 'PorcentajeVenta' FROM medicamento A
	JOIN medicamentopresentacion B ON A.idMedicamento=B.idMedicamentoJOIN Lote C ON B.idMedicamentoPresentacion=C.idMedicamentoPresentacionJOIN DetalleVenta D ON C.idLote=D.idLote 
GROUP BY A.nombre;

-- ¿Para qué sirve el SELECT @? SELECT @ se le conoce como 'declarar variable'. Es una consulta aparte que se hace para declarar cualquier variable, en este caso sería la suma

SELECT A.nombre AS 'medicamento', SUM(D.cantidad) AS 'CantidadVendida' FROM medicamento A 
	JOIN medicamentopresentacion B ON A.idMedicamento=B.idMedicamento
	JOIN Lote C ON B.idMedicamentoPresentacion=C.idMedicamentoPresentacion
	JOIN DetalleVenta D ON C.idLote=D.idLote 
GROUP BY A.idMedicamento;

-- Query 18: Mencionar el insumo necesario para cada medicamento. Además, mencionar al proveedor directo de dicho insumo.
SELECT A.nombre AS 'Medicamento', C.nombre AS 'Insumo', C.cantidad AS 'Cantidad', F.nombre AS 'Proveedor'
FROM medicamento A 
	JOIN formula B ON A.idMedicamento=B.idMedicamento
	JOIN insumo C ON B.idInsumo=C.idInsumo 
    JOIN detallecompra D ON C.idInsumo=D.idInsumo
	JOIN compra E ON D.idCompra=E.idCompra 
    JOIN proveedor F ON E.rucProveedor=F.rucProveedor
ORDER BY A.idMedicamento;

-- Query 19: Mostrar la cantidad de máquinas operativas por fase.
SELECT A.nombre AS Fase, c.esOperativa as 'Operativa(s)', COUNT(c.idMaquina) AS CantidadMaquinas
FROM Fase A 
	JOIN tipomaquina B ON A.idTipoMaquina=B.idTipoMaquina
	JOIN maquina C ON B.idTipoMaquina=C.idTipoMaquina
GROUP BY A.nombre, c.esOperativa HAVING c.esOperativa = 1;

-- Query 20: Mostrar la fecha y el monto de cada venta y comparar dicho monto con el monto de la venta anterior para ver si la variación de dicho monto resulta positivo o negativo en cada venta realizada

-- ¿Para qué sirve el LAG/OVER?
-- El LAG/OVER(ORDER BY) me permite encontrar el dato de la misma columna pero de la fila anterior.
-- En el caso de la consulta propuesta, esos operadores me permitió encontrar el precio de la venta anterior.
-- Esto se hizo con el objetivo de comparar si lo que se ganó en un mes resulta positivo o negativo respecto al mes anterior. 

SELECT fechaVenta, monto, LAG(monto) OVER(ORDER BY fechaVenta) AS MontoMesAnterior,
(monto-LAG(monto) OVER(ORDER BY fechaVenta))/LAG(monto) OVER(ORDER BY fechaVenta) AS 
'VariacionMonto' 
FROM venta;

