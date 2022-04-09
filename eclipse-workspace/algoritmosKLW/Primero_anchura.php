<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
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
    
    //Hay que resetear la posición del grafo
    mysqli_data_seek($grafo,0);

    //Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
    //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($grafo)){
        //parámetro de entrada al inicio (numérico) o parámetro de entrada por iteración mediante diccionario (posición de cola)
        if ($row['IdRelPadre'] == $inicio['IdRel']){
            //Comprobamos si el nodo que añadimos a la Cola ha sido visitado, de ser así no se añade (búsqueda en grafos)
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


