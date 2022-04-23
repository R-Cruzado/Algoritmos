<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo de primero en profundidad
 */

//Búsqueda primero en profundidad
function primeroEnProfundidad($grafo, $fin, $stack, $visitados)
{
    
    //Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do{
        
        $inicio = $stack->pop();
    
        //Para mostrar camino
        print $inicio['IdRel']. " ";
    
        //Para el algoritmo si encuentra el parentesco
        if ($inicio['ClaveHijo'] == $fin){
            print "(Esta relacionados)";
            return 1;
        }
    
        //Hay que resetear la posición del grafo
        mysqli_data_seek($grafo,0);
    
        $aux = new SplStack();
    
        //Pila LIFO. Los elementos se añaden al final y se van sacando por el último
        //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($grafo)){
            //parámetro de entrada por iteración mediante diccionario (posición de pila)
            if ($row['IdRelPadre'] == $inicio['IdRel']){
                //Si el nodo no está en visitados, se añade a visitados y se añade a la cola
                if (! in_array($row['ClaveHijo'], $visitados)){
                    array_push($visitados, $row['ClaveHijo']);
                    $aux->push($row);
                }
                /*
                * Si el nodo está en visitados, pero es una Instancia o SinTecho, no se añade a visitados porque ya está
                * en visitados, pero se añade a la cola, porque por su naturaleza expanden el árbol mas allá.
                * */
                elseif($row['InsRef'] == 0 || $row['InsRef'] == 2){
                    $aux->push($row);
                }
                /*
                *Si el nodo está en visitados, y es una referencia, se considera un nodo repetido y no se tiene
                *en cuenta para la búsqueda, porque por su naturaleza. (búsqueda en grafos).
                * */
            }
        }
        //Se añaden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
        foreach($aux as $value){
            $stack->push($value);
        }
    
    //Si la pila acaba vacía es que se ha terminado el algoritmo sin obtener la solución
    }while(!$stack->isEmpty());
    
    return 0;
}




