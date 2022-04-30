<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo de Coste uniforme
 */


//Algoritmo de Coste Uniforme
function costeUniforme($grafo, $fin, $ColaPrioridad, $visitados){
    
    /*
     * A los nodos que no son referencias, hay que ir quitándole prioridad a los posteriormente
     * encontrados para que sigan un orden de encontrados también
     */
    $contador = 0;
    //las referencias cuentan con menos prioridad, y también hay que priorizarlos por el orden de encontrados
    $contadorReferencias = -9999999;
    
    //Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do{
        
        //Padre actual
        $inicio = $ColaPrioridad->extract();
        
        //Para mostrar camino
        print $inicio['IdRel']. " ";
        
        //Para el algoritmo si encuentra el parentesco
        if ($inicio['ClaveHijo'] == $fin){
            print "(Esta relacionados)";
            return 1;
        }
        
        //Hay que resetear la posición del grafo
        mysqli_data_seek($grafo,0);
        
        //Cola de prioridad. Los elementos se van sacando por orden de mayor prioridad
        //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($grafo)){
            //Parámetro de entrada por iteración mediante diccionario (posición de cola de prioridad)
            if ($row['IdRelPadre'] == $inicio['IdRel']){
                //Si el nodo no está en visitados, se añade a visitados y se añade a la cola de prioridad
                if (! in_array($row['ClaveHijo'], $visitados)){
                    array_push($visitados, $row['ClaveHijo']);
                    
                    /*
                     * Se añade el nodo a la cola de prioridad
                     * Si es una referencia (1) la prioridad es menor ($contador) que si es una instancia o un SinTecho ($contadorReferencias).
                     * */
                    if ($row['InsRef'] == 1){
                        //Los nodos también deben de priorizarse por el orden de encontrados
                        $contadorReferencias--;
                        //añadimos a la cola de prioridad
                        $ColaPrioridad->insert($row, $contadorReferencias);
                    }
                    else{
                        //Los nodos también deben de priorizarse por el orden de encontrados
                        $contador--;
                        $ColaPrioridad->insert($row,$contador);
                    }
                }
                /*
                 * Si el nodo está en visitados, pero es una Instancia o SinTecho, no se añade a visitados porque ya está
                 * en visitados, pero se añade a la cola de prioridad, porque por su naturaleza expanden el árbol mas allá.
                 */
                elseif($row['InsRef'] == 0 || $row['InsRef'] == 2){
                    /*
                     * Se añade el nodo a la cola de prioridad con su correspondiente prioridad
                     */
                    $contador--;
                    $ColaPrioridad->insert($row,$contador);
                }
                /*
                 *Si el nodo está en visitados, y es una referencia, se considera un nodo repetido y no se tiene
                 *en cuenta para la búsqueda, por por su naturaleza. búsqueda en grafos).
                 * */
            }
        }
        
        //Si la cola de prioridad acaba vacía es que se ha terminado el algoritmo sin obtener la solución
    }while(!$ColaPrioridad->isEmpty());
    
    //devuelve 0 como indicativo de que no están correlacionados
    return 0;
    
}

