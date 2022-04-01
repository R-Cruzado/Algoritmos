<?php

function primeroEnAnchura($grafo, $inicio, $queue)
{
    
    if ($inicio != 0)
        print $inicio. " ";
    
    //hay que resetear a 0 la búsqueda del grafo
    mysqli_data_seek($grafo,0);
    
    //busca e imprime por pantalla todos, lo suyo es que encuentre solo uno a partir de otro relacionado
    //comprobar los ya visitados
    //Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            //print $row['IdRel'] . " ";
            $queue->enqueue($row['IdRel']);
        }
    }
    primeroEnAnchura($grafo, $queue->dequeue(), $queue);
    
    return 0;
}


