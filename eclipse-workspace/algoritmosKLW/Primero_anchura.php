<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo de primero en anchura
 */

require_once("Distribuido.php");


//Funcion auxiliar para buscar hijos de un nodo (Parte del algoritmo de Primero en Anchura que añade elementos a la cola)
function primeroEnAnchura($inicio, $conexion, &$queue, &$visitados){
    //Se selecciona el resto de hijos
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
    
    // Hay que resetear la posición de la selección
    mysqli_data_seek($hijos, 0);
    
    // Se busca el resto de hijos
    // Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
    // Los busca en los seleccionados en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($hijos)) {
        // Si el nodo no está en visitados, se añade a visitados y se añade a la cola
        if (! in_array($row['ClaveHijo'], $visitados)) {
            array_push($visitados, $row['ClaveHijo']);
            $queue->enqueue($row);
        } /*
        * Si el nodo está en visitados, pero es una Instancia o SinTecho, no se añade a visitados porque ya está
        * en visitados, pero se añade a la cola, porque por su naturaleza expanden el árbol mas allá.
        */
        elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
            $queue->enqueue($row);
        }
        /*
         * Si el nodo está en visitados, y es una referencia, se considera un nodo repetido y no se tiene
         * en cuenta para la búsqueda, por por su naturaleza. búsqueda en grafos).
         */
        // }
    }
}







