<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * P�gina principal
 */


require_once("Llamada.php");

//Comienzo de contador de tiempo de ejecuci�n
$iniciaTiempo = microtime(true);

/*
 * Par�metros:
 * primer gen (padre)
 * segundo gen (descendiente)
 * DKS al cu�l queremos hacer la consulta "DksBasico, DksDesarrollo, DksGeneric, DksKLW, DksLanguajes"
 * Tipo de algoritmo (Primero_anchura o Primero_profundidad, Coste_uniforme)
 * Numero de genes (nodos) generados por cada base de datos de las 5 que hay (5 DKS)
 * Num�rico, profundidad de conexiones a distintos DKS a los que queremos limitar la b�squeda
 * */
llamada('gen_prueba_001', 'gen_amigos', 'DksDesarrollo', 'Primero_anchura', 100, 50);

//Fin de tiempo de ejecuci�n y mostrarlo por pantalla
$finalizaTiempo = microtime(true);
$tiempo = $finalizaTiempo - $iniciaTiempo;
$horas = (int)($tiempo/60/60);
$minutos = (int)($tiempo/60)-$horas*60;
$segundos = (int)$tiempo-$horas*60*60-$minutos*60;
echo " (Tiempo de ejecucion: " . $horas.':'.$minutos.':'.$segundos.")";

?>


