<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Página principal
 */


require_once("Llamada.php");
require_once("Semilla1.php");


/*
 * Parámetros:
 * primer gen (padre)
 * segundo gen (descendiente)
 * DKS al cuál queremos hacer la consulta "DksBasico, DksDesarrollo, DksGeneric, DksKLW, DksLanguajes"
 * tipo de algoritmo (Primero_anchura o Primero_profundidad, Coste_uniforme)
 * Nivel de dificultad de la semilla (1, 2, 3, 4, 5) a mayor número, mayor dificultad para el algoritmo
 * */
llamada('gen_prueba_001', 'gen_casa', 'DksDesarrollo', 'Coste_uniforme', 2);


?>


