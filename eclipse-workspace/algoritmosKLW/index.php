<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * P�gina principal
*/

require_once("Llamada.php");
require_once("Semilla1.php");


/*
 * Par�metros:
 * primer gen (padre)
 * segundo gen (descendiente)
 * DKS al cual queremos hacer la consulta "DksBasico, DksDesarrollo, DksGeneric, DksKLW, DksLanguajes"
 * tipo de algoritmo (Primero_anchura o Primero_profundidad)  
 * Tipo de semilla (1, 2, 3, 4, 5) a mayor n�mero, mayor dificultad para el algoritmo
 * */
llamada('gen_prueba_001', 'gen_casa', 'DksDesarrollo', 'Primero_anchura', 1);


?>
