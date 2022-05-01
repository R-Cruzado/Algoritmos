<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * P�gina principal
 */


require_once("Llamada.php");
require_once("Semilla1.php");

//Comienzo de contador de tiempo de ejecuci�n
$iniciaTiempo = microtime(true);

/*
 * Par�metros:
 * primer gen (padre)
 * segundo gen (descendiente)
 * DKS al cu�l queremos hacer la consulta "DksBasico, DksDesarrollo, DksGeneric, DksKLW, DksLanguajes"
 * Tipo de algoritmo (Primero_anchura o Primero_profundidad, Coste_uniforme)
 * Nivel de dificultad de la semilla (1, 2, 3) a mayor n�mero, mayor dificultad para el algoritmo
 * */
llamada('a', 'b', 'DksDesarrollo', 'Primero_anchura', 2);

//Fin de tiempo de ejecuci�n y mostrarlo por pantalla
$finalizaTiempo = microtime(true);
$tiempo = $finalizaTiempo - $iniciaTiempo;
$horas = (int)($tiempo/60/60);
$minutos = (int)($tiempo/60)-$horas*60;
$segundos = (int)$tiempo-$horas*60*60-$minutos*60;
echo " (Tiempo de ejecucion: " . $horas.':'.$minutos.':'.$segundos.")";

?>


