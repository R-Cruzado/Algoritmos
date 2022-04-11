<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo para buscar antecesor (búsqueda de hijos a padres) que siempre será como una búsqueda en
 * profundidad, ya que cada hijo solo puede tener un solo padre
 */


//Búsqueda primero en anchura de padre a descendientes
function busquedaAntecesor($grafo, $inicio, $stack, $visitados)
{
    
    //Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do{
        
        //Padre actual
        $fin = $stack->pop();
    
        //Para mostrar camino
        print $fin['IdRel']. " ";
        //Para el algoritmo si encuentra el parentesco, muestra por pantalla que están relacionados, si no, no lo están.
        if ($fin['ClaveHijo'] == $inicio){
            print "(Esta relacionados)";
            //se devuelve 1 como coletilla para que desde llamada el programa sepa que lo ha encontrado
            return 1;
        }
    
        //Hay que resetear la posición del grafo
        mysqli_data_seek($grafo,0);
        
        $aux = new SplStack();
    
        //Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
        //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($grafo)){
            //parámetro de entrada al inicio (numérico) o parámetro de entrada por iteración mediante diccionario (posición de cola)
            if ($row['IdRel'] == $fin['IdRelPadre']){
                //Comprobamos si el nodo que añadimos a la Cola ha sido visitado, de ser así no se añade (búsqueda en grafos)
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
                *en cuenta para la búsqueda, porque por su naturaleza
                * */
            }
        }
        //Se añaden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
        foreach($aux as $value){
            $stack->push($value);
        }
    
    //Si la cola acaba vacía es que se ha terminado el algoritmo sin obtener la solución
    }while(!$stack->isEmpty());
    
    //devuelve 0 como indicativo de que no están correlacionados
    return 0;
}



