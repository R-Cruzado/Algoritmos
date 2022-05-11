<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Página principal
 */


require_once("Llamada.php");

//Comienzo de contador de tiempo de ejecución
$iniciaTiempo = microtime(true);

/*
 * Parámetros:
 * primer gen (padre)
 * segundo gen (descendiente)
 * DKS al cuál queremos hacer la consulta "DksBasico, DksDesarrollo, DksGeneric, DksKLW, DksLanguajes"
 * Tipo de algoritmo (Primero_anchura o Primero_profundidad, Coste_uniforme)
 * Nivel de dificultad de la semilla (1, 2, 3) a mayor número, mayor dificultad para el algoritmo
 * */
llamada('gen_prueba_001', 'gen_ai_es_gen_prueba_001', 'DksDesarrollo', 'Primero_anchura', 2);

//Fin de tiempo de ejecución y mostrarlo por pantalla
$finalizaTiempo = microtime(true);
$tiempo = $finalizaTiempo - $iniciaTiempo;
$horas = (int)($tiempo/60/60);
$minutos = (int)($tiempo/60)-$horas*60;
$segundos = (int)$tiempo-$horas*60*60-$minutos*60;
echo " (Tiempo de ejecucion: " . $horas.':'.$minutos.':'.$segundos.")";

?>


