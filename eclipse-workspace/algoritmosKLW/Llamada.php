<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Clase para hacer la llamada al algoritmo de búsqueda correspondiente (ya que los algoritmos necesitan
 * como argumento $inicio el valor de una tupla para un correcto funcionamiento), y las correspondientes excepciones
 */


require_once("Coste_uniforme.php");
require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");
require_once("Conexion.php");

/**
 * $inicio: primer gen, $fin: segundo gen, $dks: dks donde se quiere hacer la consulta,
 * $algoritmo: tipo de algoritmo de búsqueda a utilizar, $semilla: semilla a utilizar
 */
function llamada($inicio, $fin, $dks, $algoritmo, $semilla)
{
    /*
     * Se realiza la conexión a la BBDD correspondiente según el DKS. Es un array donde [0] es la conexión
     * y [1] es la consulta.
     */
    $grafo = conexion($dks, $semilla);
    
    //Hay que resetear la posición del grafo por si está en una posición indebida.
    mysqli_data_seek($grafo[1], 0);
    
    //búsqueda de tuplas en la base de datos
    while ($row = mysqli_fetch_assoc($grafo[1])){
        
        /* if else if es mas flexible, pero en este caso se utiliza una estructura switch ya que si el número de
         * condiciones es mayor a 3, switch es un poco mas rápido porque solo calcula la condición una vez y luego
         * verifica la salida.
         */
        //comprobamos si existe $inicio en la base de datos
        if ($row['ClaveHijo'] == $inicio){
            
            switch($algoritmo){
                
                case 'Primero_anchura':
                    //para comprobar si se repiten los nodos
                    $visitados = [];
                    //añadimos a visitados el primer elemento
                    array_push($visitados, $row['ClaveHijo']);
                    //creamos Cola FIFO
                    $queue= new SplQueue();
                    //añadimos la tupla encontrada a la cola
                    $queue->enqueue($row);
                    /*
                     * $inicio será el $row que se ha añadido a la cola para hacer una búsqueda dependiendo del
                     * IdRelPadre que es por el que empieza a buscar, para encontrar su descendiente hasta encontrar
                     * a $fin.
                     * Llamada a primero en anchura
                     */
                    $algoritmo = primeroEnAnchura($grafo[1], $fin, $queue, $visitados);
                    
                    if ($algoritmo == 0){
                        print "(No estan relacionados)";
                    }
                    
                    //cerramos la conexión de la BBDD. $grafo es un array donde [0] es la conexión a la BBDD que hay habierta
                    CierreConexion($grafo[0]);
                    
                    //Termina de ejecutarse la funcion
                    return 0;
                    
                case 'Primero_profundidad':
                    $visitados = [];
                    array_push($visitados, $row['ClaveHijo']);
                    //creamos Pila LIFO
                    $stack = new SplStack();
                    //añadimos la tupla encontrada a la pila
                    $stack->push($row);
                    //Llamada a primero en profundidad, de la misma forma que se llama a primero en anchura.
                    $algoritmo = primeroEnProfundidad($grafo[1], $fin, $stack, $visitados);
                    
                    if ($algoritmo == 0){
                        print "(No estan relacionados)";
                    }
                    
                    //cerramos la conexión de la BBDD
                    CierreConexion($grafo[0]);
                    
                    //Termina de ejecutarse la funcion
                    return 0;
                    
                case 'Coste_uniforme':
                    $visitados = [];
                    array_push($visitados, $row['ClaveHijo']);
                    //Creamos una cola de prioridad
                    $ColaPrioridad = new SplPriorityQueue();
                    /*
                     * Añadimos la tupla encontrada a la cola de prioridad, se le añade prioridad 1 por ser la raíz
                     */
                    $ColaPrioridad->insert($row, 1);
                    //Llamada a coste uniforme, de la misma forma que se llama a primero en anchura y primero en profundidad.
                    $algoritmo = costeUniforme($grafo[1], $fin, $ColaPrioridad, $visitados);
                    if ($algoritmo == 0){
                        print "(No estan relacionados)";
                    }
                    CierreConexion($grafo[0]);
                    return 0;
                    
                default:
                    print "El algoritmo seleccionado no es correcto";
                    //Termina de ejecutarse la funcion
                    return 0;
            }
        }
    }
    //Si no se ha encontrado $inicio en la BBDD
    print "El primer gen pasado por parametro no pertenecen a la base de datos";
    //Termina de ejecutarse la funcion
    return 0;
}

