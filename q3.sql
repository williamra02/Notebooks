-- Query 21: Mostrar la cantidad de insumos que se requiere por fase
SELECT e.nombre Fase, COUNT(a.idInsumo) AS CantidadInsumos FROM insumo AS a 
	JOIN formula AS b ON a.idInsumo = b.idInsumo
	JOIN medicamento AS c ON c.idMedicamento = b.idMedicamento
	JOIN medicamentofase AS d ON d.idMedicamento = c.idMedicamento
	JOIN fase AS e ON e.idFase = d.idFase
GROUP BY e.idFase;

-- Query 22: Mostrar a aquellos empleados (dni, nombres, apellidos y cargo) con un cargo asociado de auxiliar que no recibieron bono
SELECT p.dniPersona dni, p.apellidos, p.nombres, c.nombre cargo FROM Empleado e
	JOIN Persona p ON p.idEmpleado = e.idEmpleado
    JOIN Cargo c ON c.idCargo = e.idCargo
    JOIN HistorialPago hp ON hp.idEmpleado = e.idEmpleado
WHERE (c.nombre LIKE 'Auxiliar%') AND (hp.bono IS NULL)
GROUP BY e.idEmpleado;


-- Query 23: Mostrar que tipo de máquina(s) se encontraba(n) inoperativa(s) en la(s) fase(s) correspondiente(s) en el mes de julio de 2022
SELECT m.nombre maquina, tp.nombre, f.nombre fase, t.fechaInicio inicio, t.fechaFinal final, m.esOperativa FROM Maquina m
	JOIN TipoMaquina tp ON tp.idTipoMaquina = m.idTipoMaquina
    JOIN Fase f ON f.idTipoMaquina = tp.idTipoMaquina
    JOIN Tarea t ON t.idFase = f.idFase
WHERE month(t.fechaInicio)=7 AND year(t.fechaInicio)=2022
GROUP BY tp.idTipoMaquina, m.esOperativa HAVING m.esOperativa = 0;


-- Query 24: Mostrar las fases que operan bajo las siguientes condiciones: una temperatura mayor a 27°C y una humedad menor a 60
SELECT f.nombre fase, a.temperatura 'T°C', a.humedad humedad FROM Ambiente a
	JOIN Maquina m ON a.idAmbiente = m.idAmbiente
    JOIN Tarea t ON t.idMaquina = m.idMaquina
    JOIN Fase f ON f.idFase = t.idFase
WHERE temperatura>27 AND humedad<60
GROUP BY f.idFase;

-- Query 25: Mostrar qué empleados (sin profesión) realizan las tareas
SELECT p.nombres nombres, p.apellidos apellidos, t.idTarea '#tarea' FROM Empleado e
	JOIN Persona p ON p.idEmpleado = e.idEmpleado
    JOIN Profesion pf ON pf.idProfesion = e.idProfesion
    JOIN Tarea t ON t.idEmpleado = e.idEmpleado
WHERE e.idLugarEstudio IS NULL
GROUP BY t.idTarea;

-- Query 26: Mostrar el % de cada insumos que se utiliza para cada presentación de medicamento
SELECT m.nombre medicamento, i.nombre insumo, mpi.datoPorcentaje/100 porcentaje FROM Medicamento m
	JOIN MedicamentoPresentacion mp ON mp.idMedicamento = m.idMedicamento
    JOIN MedicamentoPresentacionInsumo mpi ON mpi.idMedicamentoPresentacion = mp.idMedicamentoPresentacion
    JOIN Insumo i ON i.idInsumo = mpi.idInsumo
ORDER BY m.idMedicamento;

-- Query 27: Mostrar a todos los empleados que tienen el cargo de auxiliar
-- ¿Para qué sirve el CONCAT?  
-- CONCAT toma un número variable de argumentos de cadena  y los concatena (o combina) en una sola cadena. 

SELECT CONCAT(A.apellidos,' ', A.nombres) AS 'Nombre Completo',C.nombre AS 'Cargo'
FROM persona A 
    INNER JOIN empleado B ON A.idEmpleado=B.idEmpleado 
    INNER JOIN cargo C ON B.idCargo=C.idCargo
WHERE C.nombre LIKE '%Auxiliar%';

-- Query 28: Mostrar a aquellos medicamentos cuya presentación tenga un tamaño mayor a 200

SELECT A.nombre AS NombreMedicamento, C.tamaño, D.nombre unidad FROM medicamento A
    INNER JOIN medicamentopresentacion B ON A.idMedicamento = B.idMedicamento
    INNER JOIN presentacion C ON B.idPresentacion = C.idPresentacion
    INNER JOIN UnidadMedida D ON C.idUnidad = D.idUnidad
WHERE C.tamaño >200
GROUP BY A.idMedicamento;

-- Query 29: Mostrar los nombres de los empleados y que máquinas estan a su cargo.
SELECT D.nombre Cargo, C.nombre Maquina FROM empleado A
    INNER JOIN tarea B ON A.idEmpleado = B.idEmpleado
    INNER JOIN maquina C ON B.idMaquina= C.idMaquina
    INNER JOIN cargo D ON A.idCargo= D.idCargo

-- Query 30: Mostrar los 5 menores montos totales del historial de pago y el empleado correspondiente a dicho historial
SELECT D.nombres, D.apellidos, C.nombre AS Cargo, sum(B.monto) monto
FROM empleado A
    INNER JOIN historialpago B ON A.idEmpleado = B.idEmpleado
    INNER JOIN cargo C ON A.idCargo = C.idCargo
    INNER JOIN persona D ON A.idEmpleado = D.idEmpleado
GROUP BY A.idEmpleado
ORDER BY sum(B.monto) ASC
LIMIT 5;