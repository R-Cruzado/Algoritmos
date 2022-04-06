<?php


function primeroEnProfundidad($grafo, $inicio, $fin, $stack, $visitados)
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
    
    $aux = new SplStack();
    
    //Pila LIFO. Los elementos se añaden al final y se van sacando por el último
    //Los busca en orden numérico
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio || $row['IdRelPadre'] == $inicio['IdRel']){
            //Comprobamos si el nodo que añadimos a la Cola ha sido visitado, de ser así no se añade (búsqueda en grafos)
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $aux->push($row);
            }
        }
    }
    //Se añaden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
    foreach($aux as $value){
        $stack->push($value);
    }
    primeroEnProfundidad($grafo, $stack->pop(), $fin, $stack, $visitados);
    
    return 0;
}




