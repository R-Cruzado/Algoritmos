<?php


function primeroEnProfundidad($grafo, $inicio, $stack, $visitados)
{
    //Para mostrar camino
    if ($inicio != 0)
        print $inicio. " ";
    
    //Hay que resetear la posici�n del grafo
    mysqli_data_seek($grafo,0);
    
    $aux = new SplStack();
    
    //Pila LIFO. Los elementos se a�aden al final y se van sacando por el �ltimo
    //Los busca en orden num�rico
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            //Comprobamos si el nodo que a�adimos a la Cola ha sido visitado, de ser as� no se a�ade (b�squeda en grafos)
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $aux->push($row['IdRel']);
            }
        }
    }
    //Se a�aden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
    foreach($aux as $value){
        $stack->push($value);
    }
    primeroEnProfundidad($grafo, $stack->pop(), $stack, $visitados);
    
    return 0;
}




