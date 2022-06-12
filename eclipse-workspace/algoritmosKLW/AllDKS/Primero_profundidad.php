<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo de primero en profundidad
 */
require_once ("Distribuido.php");

// Funcion auxiliar para buscar hijos de un nodo (Parte del algoritmo de Primero en Anchura que añade elementos a la cola)
function primeroEnProfundidad($inicio, $conexion, &$stack, &$visitados, &$aux)
{
    
    // Cogemos mediante una consulta a todos los hijos del padre actual
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");

    // Hay que resetear la posición del grafo
    mysqli_data_seek($hijos, 0);

    //$aux = new SplStack();

    // Pila LIFO. Los elementos se añaden al final y se van sacando por el último
    // Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($hijos)) {
        // Si el nodo no está en visitados, se añade a visitados y se añade a la cola
        if (! in_array($row['ClaveHijo'], $visitados)) {
            array_push($visitados, $row['ClaveHijo']);
            $aux->push($row);
        } /*
           * Si el nodo está en visitados, pero es una Instancia o SinTecho, no se añade a visitados porque ya está
           * en visitados, pero se añade a la cola, porque por su naturaleza expanden el árbol mas allá.
           */
        elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
            $aux->push($row);
        }
        /*
         * Si el nodo está en visitados, y es una referencia, se considera un nodo repetido y no se tiene
         * en cuenta para la búsqueda, porque por su naturaleza. (búsqueda en grafos).
         */
    }
    /*
     * Si se han añadido elementos a la pila auxiliar
     * Se añaden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
     */
    /*if (! $aux->isEmpty()) {
        foreach ($aux as $value) {
            $stack->push($value);
        }
    }*/
    
}




