<?php


function primeroEnProfundidad($grafo, $inicio, $stack)
{
    
    if ($inicio != 0)
        print $inicio. " ";
    
    //hay que resetear a 0 la b�squeda del grafo
    mysqli_data_seek($grafo,0);
    
    $aux = new SplStack();
    
    //Pila LIFO. Los elementos se a�aden al final y se van sacando por el �ltimo
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            //$stack->attach($row['IdRel']);
            $aux->push($row['IdRel']);
        }
    }
    //Se a�aden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
    foreach($aux as $value){
        $stack->push($value);
    }
    primeroEnProfundidad($grafo, $stack->pop(), $stack);
    //primeroEnProfundidad($grafo, $stack->shift(), $stack);
    
    return 0;
}



