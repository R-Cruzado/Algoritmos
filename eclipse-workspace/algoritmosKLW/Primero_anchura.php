<?php

function primeroEnAnchura($grafo, $inicio, $queue, $visitados)
{
    //Para mostrar camino
    if ($inicio != 0)
        print $inicio. " ";
    
    //Hay que resetear la posici�n del grafo
    mysqli_data_seek($grafo,0);
    
    //Cola FIFO. Los elementos se a�aden al final, y se van sacando por el primero
    //Los busca en orden num�rico
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            //Comprobamos si el nodo que a�adimos a la Cola ha sido visitado, de ser as� no se a�ade (b�squeda en grafos)
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $queue->enqueue($row['IdRel']);
            }
        }
    }
    
    //BUCLE QUE ENGLOVE TODO HASTA QUE SE TERMINE LA COLA, RECURSIVIDAD PUEDE CAUSAR DESBORDAMIENTO DE PILA
    primeroEnAnchura($grafo, $queue->dequeue(), $queue, $visitados);

    return 0;
}


