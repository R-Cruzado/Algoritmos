<?php

function primeroEnAnchura($grafo, $inicio, $visitado)
{
    //hay que resetear a 0 la búsqueda del grafo
    mysqli_data_seek($grafo,0);
    
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            print $row['IdRel'] . " ";
        }
    }
    primeroEnAnchura($grafo, $inicio +1, $visitado);
    
    return 0;
}


