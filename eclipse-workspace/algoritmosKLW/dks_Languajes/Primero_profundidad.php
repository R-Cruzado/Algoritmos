<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo de primero en profundidad
 */
require_once ("Distribuido.php");

// Funcion auxiliar para buscar hijos de un nodo (Parte del algoritmo de Primero en Anchura que a�ade elementos a la cola)
function primeroEnProfundidad($inicio, $conexion, &$stack, &$visitados, &$aux)
{
    
    // Cogemos mediante una consulta a todos los hijos del padre actual
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");

    // Hay que resetear la posici�n del grafo
    mysqli_data_seek($hijos, 0);

    //$aux = new SplStack();

    // Pila LIFO. Los elementos se a�aden al final y se van sacando por el �ltimo
    // Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($hijos)) {
        // Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola
        if (! in_array($row['ClaveHijo'], $visitados)) {
            array_push($visitados, $row['ClaveHijo']);
            $aux->push($row);
        } /*
           * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
           * en visitados, pero se a�ade a la cola, porque por su naturaleza expanden el �rbol mas all�.
           */
        elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
            $aux->push($row);
        }
        /*
         * Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
         * en cuenta para la b�squeda, porque por su naturaleza. (b�squeda en grafos).
         */
    }
    /*
     * Si se han a�adido elementos a la pila auxiliar
     * Se a�aden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
     */
    /*if (! $aux->isEmpty()) {
        foreach ($aux as $value) {
            $stack->push($value);
        }
    }*/
    
}




