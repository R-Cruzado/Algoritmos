<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Clase para hacer la llamada al algoritmo de b�squeda correspondiente (ya que los algoritmos necesitan
 * como argumento $inicio el valor de una tupla para un correcto funcionamiento), y las correspondientes excepciones
 */

require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");

/**
 * $primero: primer gen, $segundo: segundo gen, $grafo: tuplas de la BBDD, 
 * $algoritmo: tipo de algoritmo de b�squeda a utilizar
 */
function llamada($inicio, $fin, $grafo, $algoritmo)
{
    //Hay que resetear la posici�n del grafo por si est� en una posici�n indebida
    mysqli_data_seek($grafo,0);
    
    //b�squeda de tuplas en la base de datos
    while ($row = mysqli_fetch_assoc($grafo)){
        
        //comprobamos si existe $inicio en la base de datos
        if ($row['ClaveHijo'] == $inicio){
            
            if($algoritmo == 'Primero_anchura'){
                //para comprobar si se repiten los nodos
                $visitados = [];
                //a�adimos a visitados el primer elemento
                array_push($visitados, $row['ClaveHijo']);
                //creamos Cola FIFO
                $queue= new SplQueue();
                //a�adimos la tupla encontrada a la cola
                $queue->enqueue($row);
                /*
                 * $inicio ser� el $row que se ha a�adido a la cola para hacer una b�squeda dependiendo del 
                 * IdRelPadre que es por el que empieza a buscar, para encontrar su descendiente hasta encontrar 
                 * a $fin.
                 * Llamada a primero en anchura
                 */
                $algoritmo = primeroEnAnchura($grafo, $fin, $queue, $visitados);
                
                if ($algoritmo == 0){
                    print "No estan relacionados";
                }
                
                return 0;
            }
            elseif ($algoritmo == 'Primero_profundidad'){
                //para comprobar si se repiten los nodos
                $visitados = [];
                //a�adimos a visitados el primer elemento
                array_push($visitados, $row['ClaveHijo']);
                //creamos Pila LIFO
                $stack = new SplStack();
                //a�adimos la tupla encontrada a la pila
                $stack->push($row);
                //Llamada a primero en profundidad, de la misma forma que se llama a primero en anchura.
                $algoritmo = primeroEnProfundidad($grafo, $fin, $stack, $visitados);
                
                if ($algoritmo == 0){
                    print "No estan relacionados";
                }
                
                return 0;
            }
            else{
                print "El algoritmo seleccionado no es correcto";
                return 0;
            }
        }
    }
    //Si no se ha encontrado $inicio en la BBDD
    print "El primer argumento pasado por parametro no pertenecen a la base de datos";
    return 0;
}

/*
function llamada($inicio, $fin, $grafo, $algoritmo)
{
    //Hay que resetear la posici�n del grafo por si est� en una posici�n indebida
    mysqli_data_seek($grafo,0);
    
    //b�squeda de tuplas en la base de datos
    while ($row = mysqli_fetch_assoc($grafo)){
        
        //comprobamos si existe $inicio en la base de datos
        if ($row['ClaveHijo'] == $inicio){
*/
/*
//comprobamos si existe $inicio en la base de datos
if ($row['ClaveHijo'] == $fin){
    
    if($algoritmo == 'Primero_anchura'){
        //para comprobar si se repiten los nodos
        $visitados = [];
        //a�adimos a visitados el primer elemento
        array_push($visitados, $row['ClaveHijo']);
        //creamos Cola FIFO
        $queue= new SplQueue();
        
        //a�adimos la tupla encontrada a la cola
        $queue->enqueue($row);*/
        /*
         * $fin es el elemento que hay en la cola para hacer una b�squeda dependiendo del IdRel que es
         * por el que empieza a buscar, para encontrar su antecesor hasta encontrar a $inicio.
         * Llamada a primero en anchura
         */
        /*$algoritmo = primeroEnAnchura($grafo, $inicio, $queue->dequeue(), $queue, $visitados);
        
        if($algoritmo == 1){
            return 0;
        }
        
    }*/






