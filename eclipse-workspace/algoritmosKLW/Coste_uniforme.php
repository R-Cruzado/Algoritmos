<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo de Coste uniforme
 */


//Algoritmo de Coste Uniforme
function costeUniforme($grafo, $fin, $ColaPrioridad, $visitados){
    
    /*
     * A los nodos que no son referencias, hay que ir quit�ndole prioridad a los posteriormente
     * encontrados para que sigan un orden de encontrados tambi�n
     */
    $contador = 0;
    //las referencias cuentan con menos prioridad, y tambi�n hay que priorizarlos por el orden de encontrados
    $contadorReferencias = -9999999;
    
    //Bucle while o do while es mas eficiente que la recursividad en programaci�n imperativa, como lo es PHP
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
        
        //Hay que resetear la posici�n del grafo
        mysqli_data_seek($grafo,0);
        
        //Cola de prioridad. Los elementos se van sacando por orden de mayor prioridad
        //Los busca en la base de datos en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($grafo)){
            //Par�metro de entrada por iteraci�n mediante diccionario (posici�n de cola de prioridad)
            if ($row['IdRelPadre'] == $inicio['IdRel']){
                //Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola de prioridad
                if (! in_array($row['ClaveHijo'], $visitados)){
                    array_push($visitados, $row['ClaveHijo']);
                    
                    /*
                     * Se a�ade el nodo a la cola de prioridad
                     * Si es una referencia (1) la prioridad es menor ($contador) que si es una instancia o un SinTecho ($contadorReferencias).
                     * */
                    if ($row['InsRef'] == 1){
                        //Los nodos tambi�n deben de priorizarse por el orden de encontrados
                        $contadorReferencias--;
                        //a�adimos a la cola de prioridad
                        $ColaPrioridad->insert($row, $contadorReferencias);
                    }
                    else{
                        //Los nodos tambi�n deben de priorizarse por el orden de encontrados
                        $contador--;
                        $ColaPrioridad->insert($row,$contador);
                    }
                }
                /*
                 * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
                 * en visitados, pero se a�ade a la cola de prioridad, porque por su naturaleza expanden el �rbol mas all�.
                 */
                elseif($row['InsRef'] == 0 || $row['InsRef'] == 2){
                    /*
                     * Se a�ade el nodo a la cola de prioridad con su correspondiente prioridad
                     */
                    $contador--;
                    $ColaPrioridad->insert($row,$contador);
                }
                /*
                 *Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
                 *en cuenta para la b�squeda, por por su naturaleza. b�squeda en grafos).
                 * */
            }
        }
        
        //Si la cola de prioridad acaba vac�a es que se ha terminado el algoritmo sin obtener la soluci�n
    }while(!$ColaPrioridad->isEmpty());
    
    //devuelve 0 como indicativo de que no est�n correlacionados
    return 0;
    
}

