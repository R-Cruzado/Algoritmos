<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo para buscar antecesor (b�squeda de hijos a padres) que siempre ser� como una b�squeda en
 * profundidad, ya que cada hijo solo puede tener un solo padre
 */


//B�squeda primero en anchura de padre a descendientes
function busquedaAntecesor($grafo, $inicio, $fin, $queue, $visitados)
{
    
    //Para mostrar camino
    print $fin['IdRel']. " ";
    //Para el algoritmo si encuentra el parentesco, muestra por pantalla que est�n relacionados, si no, no lo est�n.
    if ($fin['ClaveHijo'] == $inicio){
        print "(Esta relacionados)";
        //se devuelve 1 como coletilla para que desde llamada el programa sepa que lo ha encontrado
        return 1;
    }
    
    //Hay que resetear la posici�n del grafo
    mysqli_data_seek($grafo,0);
    
    //Cola FIFO. Los elementos se a�aden al final, y se van sacando por el primero
    //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($grafo)){
        //par�metro de entrada al inicio (num�rico) o par�metro de entrada por iteraci�n mediante diccionario (posici�n de cola)
        if ($row['IdRel'] == $fin['IdRelPadre']){
            //Comprobamos si el nodo que a�adimos a la Cola ha sido visitado, de ser as� no se a�ade (b�squeda en grafos)
            //Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $queue->enqueue($row);
            }
            /*
             * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
             * en visitados, pero se a�ade a la cola, porque por su naturaleza expanden el �rbol mas all�.
             * */
            elseif($row['InsRef'] == 0 || $row['InsRef'] == 2){
                $queue->enqueue($row);
            }
            /*
             *Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
             *en cuenta para la b�squeda, porque por su naturaleza
             * */
        }
    }
    
    if($queue->isEmpty())
        //se devuelve 0 como coletilla para que desde llamada el programa sepa que no lo ha encontrado
        return 0;
        
        //hacemos recursividad con el nuevo nodo y los datos actualizados
        primeroEnAnchura($grafo, $inicio, $queue->dequeue(), $queue, $visitados);
        
}



