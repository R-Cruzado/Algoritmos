<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo de primero en anchura
 */

require_once("Distribuido.php");


//Funcion auxiliar para buscar hijos de un nodo (Parte del algoritmo de Primero en Anchura que a�ade elementos a la cola)
function primeroEnAnchura($inicio, $conexion, &$queue, &$visitados){
    //Se selecciona el resto de hijos
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
    
    // Hay que resetear la posici�n de la selecci�n
    mysqli_data_seek($hijos, 0);
    
    // Se busca el resto de hijos
    // Cola FIFO. Los elementos se a�aden al final, y se van sacando por el primero
    // Los busca en los seleccionados en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($hijos)) {
        // Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola
        if (! in_array($row['ClaveHijo'], $visitados)) {
            array_push($visitados, $row['ClaveHijo']);
            $queue->enqueue($row);
        } /*
        * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
        * en visitados, pero se a�ade a la cola, porque por su naturaleza expanden el �rbol mas all�.
        */
        elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
            $queue->enqueue($row);
        }
        /*
         * Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
         * en cuenta para la b�squeda, por por su naturaleza. b�squeda en grafos).
         */
        // }
    }
}







