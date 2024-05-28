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
