<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Algoritmo de primero en anchura
 */

require_once("Llamada.php");
require_once("Conexion.php");
require_once("DistribuidoUtils.php");

// Algoritmo de primero en anchura
function primeroEnAnchura($fin, $queue, $visitados, $dks)
{
    
    //Variable para establecer las conexiones a la base de datos
    $conexion = 0;
    //Variable para buscar el padre de un concepto instanciado o referenciado
    $padre = 0;
    
    // Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do {
        
        // Padre actual
        $inicio = $queue->dequeue();

        // Para mostrar camino
        //print $inicio['IdRel'] . $inicio['ClaveHijo'] .$inicio['IdRelPadre']." ";
        print $inicio['IdRel']." ";

        // Para el algoritmo si encuentra el parentesco, muestra por pantalla que están relacionados, si no, no lo están.
        if ($inicio['ClaveHijo'] == $fin) {
            print "(Estan relacionados)";
            //cerramos conexión anterior
            mysqli_close($conexion);
            // Si están relacionados devuelve 1 como indicativo de que lo están
            return 1;
        }

        //si está en otro dks
        if ($inicio['Localidad'] == 0) {
            
            //Cerramos conexion anterior
            mysqli_close($conexion);
            
            //conexión a otro DKS
            conexionOtroDKS($inicio, $conexion);
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);

            //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
            buscaHijos($padre, $conexion, $queue, $visitados);
            
            // Búsqueda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }
        
        /*
         * Si se instancia o referencia a un concepto local y si no es el prmier nodo, ya que  
         * si es el primer nodo no hace referencia o instancia a otro concepto
         */
        elseif (($inicio['InsRef'] == 1 || $inicio['InsRef'] == 0) && $inicio['Localidad'] == 1 && $inicio['IdRelPadre'] != 0){
            
            //cerramos la conexión anterior
            mysqli_close($conexion);
            
            //Se realiza la conexión a la BBDD del dks local
            conexion($dks, $conexion);
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);
            
            //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
            buscaHijos($padre, $conexion, $queue, $visitados);
            
            // Búsqueda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }
        //Si estamos en el DKS local, y es un sinTecho o el primer nodo
        elseif (($inicio['InsRef'] == 2 || ($inicio['InsRef'] == 0 && $inicio['IdRelPadre'] == 0)) && $inicio['Localidad'] == 1 ){
            
            // Búsqueda de genes locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }

        // Si la cola acaba vacía es que se ha terminado el algoritmo sin obtener la solución
    } while (! $queue->isEmpty());

    //Cerramos conexión anterior
    mysqli_close($conexion);
    
    // devuelve 0 como indicativo de que no están correlacionados
    return 0;
}


//Funcion auxiliar para buscar hijos de un nodo (ALGORITMO)
function buscaHijos($inicio, $conexion, &$queue, &$visitados){
    //Se selecciona el resto de hijos
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
    
    // Hay que resetear la posición de la selección
    mysqli_data_seek($hijos, 0);
    
    // Se busca el resto de hijos
    // Cola FIFO. Los elementos se añaden al final, y se van sacando por el primero
    // Los busca en los seleccionados en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($hijos)) {
        // Si el nodo no está en visitados, se añade a visitados y se añade a la cola
        if (! in_array($row['ClaveHijo'], $visitados)) {
            array_push($visitados, $row['ClaveHijo']);
            $queue->enqueue($row);
        } /*
        * Si el nodo está en visitados, pero es una Instancia o SinTecho, no se añade a visitados porque ya está
        * en visitados, pero se añade a la cola, porque por su naturaleza expanden el árbol mas allá.
        */
        elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
            $queue->enqueue($row);
        }
        /*
         * Si el nodo está en visitados, y es una referencia, se considera un nodo repetido y no se tiene
         * en cuenta para la búsqueda, por por su naturaleza. búsqueda en grafos).
         */
        // }
    }
}







