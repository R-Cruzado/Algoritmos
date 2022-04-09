<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Clase para averiguar que elemento es el primero al que se tiene acceso en la BBDD, para resolver sus precesores
 * posteriormente, haciendo la llamada al algoritmo de b�squeda correspondiente
 */

require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");

/**
 * $primero: primer par�metro, $segundo: segundo par�metro, $grafo: tuplas de la BBDD, 
 * $algoritmo: tipo de algoritmo de b�squeda a utilizar
 */
function llamada($primero, $segundo, $grafo, $algoritmo)
{
    //Hay que resetear la posici�n del grafo por si est� en una posici�n indebida
    mysqli_data_seek($grafo,0);
    
    //b�squeda de tuplas en la base de datos
    while ($row = mysqli_fetch_assoc($grafo)){
        //si el primero encontrado es $primero, $primero (como IdRel) es $inicio y $segundo es $fin
        if ($row['ClaveHijo'] == $primero){
            TipoAlgoritmo($algoritmo, $grafo, $row, $segundo);
            return 0;
        }
        //si el primero encontrado es $segundo, $segundo (como IdRel) es $inicio y $primero es $fin
        elseif ($row['ClaveHijo'] == $segundo){
            TipoAlgoritmo($algoritmo, $grafo, $row, $primero);
            return 0;
        }
        //Si se quiere hacer una b�squeda en toda la base de datos, 0 es $inicio y $segundo es $fin
        /*elseif($primero == 0){
            TipoAlgoritmo($algoritmo, $grafo, 0, $segundo);
            return 0;
        }*/
    }
    //Si no se ha encontrado ning�n par�metro en la BBDD
    print "Los argumentos pasados por par�metro no pertenecen a la base de datos";
    return 0;
}


//funci�n auxiliar para determinar el tipo de algoritmo pasado por par�metro
function TipoAlgoritmo($algoritmo, $grafo, $inicio, $fin){
    //para comprobar si se repiten los nodos
    $visitados = [];
   
    if($algoritmo == 'Primero_anchura'){
        //creamos Cola FIFO
        $queue= new SplQueue();
        /*
         * $inicio es num�rico, dependiendo del IdRelPadre es por el que empieza a buscar, para encontrar su descendiente
         * hasta que encuentra a $fin.
         * Llamada a primero en anchura
         */
        /*
         * HAY QUE HACER UNA COLETILLA EN EL ALGORITMO QUE INDIQUE SI SE HA MOSTRADO UN CAMINO,
         * PARA PARTIR DEL SIGUIENTE YA QUE PUEDE SER QUE EL PRIMER ENCONTRADO NO TENGA HIJOS
         * Y EL SEGUNDO ENCONTRADO TENGA COMO HIJO AL PRIMER ENCONTRADO EJ: GEN_CASA -> GEN_MI_CASA
         * EN CONCEPTOS PARA TEST Y PRUEBAS DE DKS_DESARROLLO, ENCONTRAMOS ANTES VARIOS GEN_MI_CASA QUE NO TIENEN
         * HIJOS, PERO ES HIJO DE GEN_CASA
         * */
        primeroEnAnchura($grafo, $inicio, $fin, $queue, $visitados);
    }
    elseif ($algoritmo == 'Primero_profundidad'){
        //creamos Pila LIFO
        $stack = new SplStack();
        //Llamada a primero en profundidad, de la misma forma que se llama a primero en anchura
        primeroEnProfundidad($grafo, $inicio, $fin, $stack, $visitados);
    }
    else{
        print "El algoritmo seleccionado no es correcto";
    }
    
    return 0;
}
