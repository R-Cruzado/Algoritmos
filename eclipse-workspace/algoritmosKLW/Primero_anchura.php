<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo de primero en anchura
 */

//Búsqueda primero en anchura de padre a descendientes
function primeroEnAnchura($grafo, $fin, $queue, $visitados)
{
    //Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do{
    
        //Padre actual
        $inicio = $queue->dequeue();
        
        //Para mostrar camino
        print $inicio['IdRel']. " ";
        
        //Para el algoritmo si encuentra el parentesco, muestra por pantalla que están relacionados, si no, no lo están.
        if ($inicio['ClaveHijo'] == $fin){
            print "(Esta relacionados)";
            //Si están relacionados devuelve 1 como indicativo de que lo están
            return 1;
        }
    
        //Hay que resetear la posición del grafo
        mysqli_data_seek($grafo,0);
    
        //Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
        //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($grafo)){
            //parámetro de entrada al inicio (numérico) o parámetro de entrada por iteración mediante diccionario (posición de cola)
            if ($row['IdRelPadre'] == $inicio['IdRel']){
                //Comprobamos si el nodo que añadimos a la Cola ha sido visitado, de ser así no se añade (búsqueda en grafos)
                //Si el nodo no está en visitados, se añade a visitados y se añade a la cola
                if (! in_array($row['ClaveHijo'], $visitados)){
                    array_push($visitados, $row['ClaveHijo']);
                    $queue->enqueue($row);
                }
                /*
                * Si el nodo está en visitados, pero es una Instancia o SinTecho, no se añade a visitados porque ya está
                * en visitados, pero se añade a la cola, porque por su naturaleza expanden el árbol mas allá.
                * */
                elseif($row['InsRef'] == 0 || $row['InsRef'] == 2){
                $queue->enqueue($row);
                }
                /*
                 *Si el nodo está en visitados, y es una referencia, se considera un nodo repetido y no se tiene
                *en cuenta para la búsqueda, porque por su naturaleza
                * */
            }
        }
        
    //Si la cola acaba vacía es que se ha terminado el algoritmo sin obtener la solución 
    }while(!$queue->isEmpty());
    
    //devuelve 0 como indicativo de que no están correlacionados
    return 0;
    
}







