<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Clase para hacer la llamada al algoritmo de b�squeda correspondiente (ya que los algoritmos necesitan
 * como argumento $inicio el valor de una tupla para un correcto funcionamiento), y las correspondientes excepciones
 */

require_once ("Distribuido.php");
require_once ("Conexion.php");

/**
 * $inicio: primer gen, $fin: segundo gen, $dks: dks donde se quiere hacer la consulta,
 * $algoritmo: tipo de algoritmo de b�squeda a utilizar, $semilla: semilla a utilizar
 * $genes: Numero de genes (nodos) generados por cada base de datos de las 5 que hay (5 DKS)
 */
function llamada($inicio, $fin, $dks, $algoritmo, $genes)
{
    /*
     * Se realiza la conexi�n a la BBDD correspondiente seg�n el DKS y devuelve la consulta correspondiente.
     */
    $consulta = consulta($dks, $genes, $inicio);
    
    // para comprobar si se repiten los nodos
    $visitados = [];
    
    // Hay que resetear la posici�n del grafo por si est� en una posici�n indebida.
    mysqli_data_seek($consulta, 0);
    
    // b�squeda de tuplas en la base de datos
    while ($row = mysqli_fetch_assoc($consulta)) {
        
        /*
         * if else if es mas flexible, pero en este caso se utiliza una estructura switch ya que si el n�mero de
         * condiciones es mayor a 3, switch es un poco mas r�pido porque solo calcula la condici�n una vez y luego
         * verifica la salida.
         */
        switch ($algoritmo) {
            
            case 'Primero_anchura':
                // a�adimos a visitados el primer elemento
                array_push($visitados, $row['ClaveHijo']);
                // creamos Cola FIFO
                $queue = new SplQueue();
                // a�adimos la tupla encontrada a la cola
                $queue->enqueue($row);
                /*
                 * Se llama a la funci�n que selecciona el DKS adecuado al camino que se va siguiendo
                 * teniendo en cuenta el algoritmo seleccionado
                 */
                $resultado = distribucion($fin, $queue, $visitados, $dks, $algoritmo);
                
                if ($resultado == 0) {
                    print "(No estan relacionados)";
                }
                
                /*
                 * Termina de ejecutarse la funcion. Busca en el concepto original, no en las instanciaciones ni referencias
                 * no originales que dependen de otros genes, por eso una vez que encuentra el original, si lo encuenta, para
                 */
                return 0;
                
            case 'Primero_profundidad':
                array_push($visitados, $row['ClaveHijo']);
                // creamos Pila LIFO
                $stack = new SplStack();
                // a�adimos la tupla encontrada a la pila
                $stack->push($row);
                
                $resultado = distribucion($fin, $stack, $visitados, $dks, $algoritmo);
                
                if ($resultado == 0) {
                    print "(No estan relacionados)";
                }
                
                // Termina de ejecutarse la funcion
                return 0;
                
            case 'Coste_uniforme':
                array_push($visitados, $row['ClaveHijo']);
                // Creamos una cola de prioridad
                $ColaPrioridad = new SplPriorityQueue();
                /*
                 * A�adimos la tupla encontrada a la cola de prioridad, se le a�ade prioridad 1 por ser la ra�z
                 */
                $ColaPrioridad->insert($row, 1);
                
                $resultado = distribucion($fin, $ColaPrioridad, $visitados, $dks, $algoritmo);
                
                if ($resultado == 0) {
                    print "(No estan relacionados)";
                }
                
                return 0;
                
            default:
                print "El algoritmo seleccionado no es correcto";
                // Termina de ejecutarse la funcion
                return 0;
        }
    }
    // Si no se ha encontrado $inicio en la BBDD
    print "El primer gen pasado por parametro no pertenecen a la base de datos";
    // Termina de ejecutarse la funcion
    return 0;
}