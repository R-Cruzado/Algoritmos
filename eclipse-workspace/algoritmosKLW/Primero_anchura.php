<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 */

function primeroEnAnchura($grafo, $inicio, $fin, $queue, $visitados)
{
    
    //Para mostrar camino
    print $inicio['IdRel']. " ";
    //Para el algoritmo si encuentra el parentesco
    if ($inicio['ClaveHijo'] == $fin){
        print "(Esta relacionados)";
        return 0;
    }
    
    //Hay que resetear la posici�n del grafo
    mysqli_data_seek($grafo,0);

    //Cola FIFO. Los elementos se a�aden al final, y se van sacando por el primero
    //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($grafo)){
        //par�metro de entrada al inicio (num�rico) o par�metro de entrada por iteraci�n mediante diccionario (posici�n de cola)
        if ($row['IdRelPadre'] == $inicio['IdRel']){
            //Comprobamos si el nodo que a�adimos a la Cola ha sido visitado, de ser as� no se a�ade (b�squeda en grafos)
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $queue->enqueue($row);
            }
            /*if (!((in_array($row['ClaveHijo'], $visitados)) && ($row['InsRef'] == 1))){
                
            }
            if ((! in_array($row['ClaveHijo'], $visitados)) && ($row['InsRef'] != 1)){
                array_push($visitados, $row['ClaveHijo']);
                $queue->enqueue($row);
            }*/
        }
    }
    
    //hacemos recursividad con el nuevo nodo y los datos actualizados
    primeroEnAnchura($grafo, $queue->dequeue(), $fin, $queue, $visitados);
    
    return 0;
}


