<?php


function primeroEnProfundidad($grafo, $inicio, $visitado)
{
    //añadimos el nodo actual a la lista de visitados
    //array_push($visitado, $inicio);
    
    //print $inicio. " ";
    
    //$id = mysqli_fetch_assoc($grafo)['IdRel'];
    
    //hay que resetear a 0 la búsqueda del grafo
    mysqli_data_seek($grafo,0);
    
    //Al buscarse el padre, hay que ir al revés, desde el hijo mas remoto buscando el padre y luego hacer un reverse
    //esto no busca nada, si cambias de orden los balores se va por perteneras, y no tiene que seguir un orden secuencial
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRel'] == $inicio){
            $padre = $row['IdRelPadre'];
            //igual no es necesario comprobar si mete repetidos, porque al generar la base de datos no permite generar id repetidos
            if (in_array($padre, $visitado)){
                print "hijoDe".$row['IdRelPadre']." ";
                //print "Ya_Visitado ";
                primeroEnProfundidad($grafo, $inicio +1, $visitado);
            }
            else{
                primeroEnProfundidad($grafo, $inicio +1, $visitado);
            }
        }
    }
    
    return 0;
}