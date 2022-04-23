<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo de primero en profundidad
 */

//B�squeda primero en profundidad
function primeroEnProfundidad($grafo, $fin, $stack, $visitados)
{
    
    //Bucle while o do while es mas eficiente que la recursividad en programaci�n imperativa, como lo es PHP
    do{
        
        $inicio = $stack->pop();
    
        //Para mostrar camino
        print $inicio['IdRel']. " ";
    
        //Para el algoritmo si encuentra el parentesco
        if ($inicio['ClaveHijo'] == $fin){
            print "(Esta relacionados)";
            return 1;
        }
    
        //Hay que resetear la posici�n del grafo
        mysqli_data_seek($grafo,0);
    
        $aux = new SplStack();
    
        //Pila LIFO. Los elementos se a�aden al final y se van sacando por el �ltimo
        //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($grafo)){
            //par�metro de entrada por iteraci�n mediante diccionario (posici�n de pila)
            if ($row['IdRelPadre'] == $inicio['IdRel']){
                //Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola
                if (! in_array($row['ClaveHijo'], $visitados)){
                    array_push($visitados, $row['ClaveHijo']);
                    $aux->push($row);
                }
                /*
                * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
                * en visitados, pero se a�ade a la cola, porque por su naturaleza expanden el �rbol mas all�.
                * */
                elseif($row['InsRef'] == 0 || $row['InsRef'] == 2){
                    $aux->push($row);
                }
                /*
                *Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
                *en cuenta para la b�squeda, porque por su naturaleza. (b�squeda en grafos).
                * */
            }
        }
        //Se a�aden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
        foreach($aux as $value){
            $stack->push($value);
        }
    
    //Si la pila acaba vac�a es que se ha terminado el algoritmo sin obtener la soluci�n
    }while(!$stack->isEmpty());
    
    return 0;
}




