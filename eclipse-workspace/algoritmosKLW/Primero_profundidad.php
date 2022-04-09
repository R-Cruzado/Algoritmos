<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 */

function primeroEnProfundidad($grafo, $inicio, $fin, $stack, $visitados)
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
    
    $aux = new SplStack();
    
    //Pila LIFO. Los elementos se a�aden al final y se van sacando por el �ltimo
    //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($grafo)){
        //par�metro de entrada al inicio (num�rico) o par�metro de entrada por iteraci�n mediante diccionario (posici�n de pila)
        if ($row['IdRelPadre'] == $inicio || $row['IdRelPadre'] == $inicio['IdRel']){
            //Comprobamos si el nodo que a�adimos a la Cola ha sido visitado, de ser as� no se a�ade (b�squeda en grafos)
            if (! in_array($row['ClaveHijo'], $visitados)){
                array_push($visitados, $row['ClaveHijo']);
                $aux->push($row);
            }
        }
    }
    //Se a�aden al final de los que ya hay en $stack en conjuntos ordenados de izquierda a derecha
    foreach($aux as $value){
        $stack->push($value);
    }
    
    //hacemos recursividad con el nuevo nodo y los datos actualizados
    primeroEnProfundidad($grafo, $stack->pop(), $fin, $stack, $visitados);
    
    return 0;
}




