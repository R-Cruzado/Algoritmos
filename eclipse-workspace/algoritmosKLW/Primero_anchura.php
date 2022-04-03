<?php

function primeroEnAnchura($grafo, $inicio, $queue, $visitados)
{
    //Para mostrar camino
    if ($inicio != 0)
        print $inicio. " ";
    
    //Hay que resetear la posición del grafo
    mysqli_data_seek($grafo,0);
    
    //Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
    //Los busca en orden numérico
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            //Comprobamos si el nodo que añadimos a la Cola ha sido visitado, de ser así no se añade (búsqueda en grafos)
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


