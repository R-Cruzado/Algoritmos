<?php

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
    //Los busca en orden num�rico
    while ($row = mysqli_fetch_assoc($grafo)){
        //par�metro de entrada al inicio o par�metro o par�metro de entrada por iteraci�n mediante diccionario
        if ($row['IdRelPadre'] == $inicio || $row['IdRelPadre'] == $inicio['IdRel']){
            //Comprobamos si el nodo que a�adimos a la Cola ha sido visitado, de ser as� no se a�ade (b�squeda en grafos)
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $queue->enqueue($row);
            }
        }
    }
    
    primeroEnAnchura($grafo, $queue->dequeue(), $fin, $queue, $visitados);
    
    return 0;
}


