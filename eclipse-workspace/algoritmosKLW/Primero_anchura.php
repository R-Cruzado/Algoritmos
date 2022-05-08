<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
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
    
    // Bucle while o do while es mas eficiente que la recursividad en programaci�n imperativa, como lo es PHP
    do {
        
        // Padre actual
        $inicio = $queue->dequeue();

        // Para mostrar camino
        //print $inicio['IdRel'] . $inicio['ClaveHijo'] .$inicio['IdRelPadre']." ";
        print $inicio['IdRel']." ";

        // Para el algoritmo si encuentra el parentesco, muestra por pantalla que est�n relacionados, si no, no lo est�n.
        if ($inicio['ClaveHijo'] == $fin) {
            print "(Estan relacionados)";
            //cerramos conexi�n anterior
            mysqli_close($conexion);
            // Si est�n relacionados devuelve 1 como indicativo de que lo est�n
            return 1;
        }

        //si est� en otro dks
        if ($inicio['Localidad'] == 0) {
            
            //Cerramos conexion anterior
            mysqli_close($conexion);
            
            //conexi�n a otro DKS
            conexionOtroDKS($inicio, $conexion);
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);

            //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
            buscaHijos($padre, $conexion, $queue, $visitados);
            
            // B�squeda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }
        
        /*
         * Si se instancia o referencia a un concepto local y si no es el prmier nodo, ya que  
         * si es el primer nodo no hace referencia o instancia a otro concepto
         */
        elseif (($inicio['InsRef'] == 1 || $inicio['InsRef'] == 0) && $inicio['Localidad'] == 1 && $inicio['IdRelPadre'] != 0){
            
            //cerramos la conexi�n anterior
            mysqli_close($conexion);
            
            //Se realiza la conexi�n a la BBDD del dks local
            conexion($dks, $conexion);
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);
            
            //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
            buscaHijos($padre, $conexion, $queue, $visitados);
            
            // B�squeda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }
        //Si estamos en el DKS local, y es un sinTecho o el primer nodo
        elseif (($inicio['InsRef'] == 2 || ($inicio['InsRef'] == 0 && $inicio['IdRelPadre'] == 0)) && $inicio['Localidad'] == 1 ){
            
            // B�squeda de genes locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }

        // Si la cola acaba vac�a es que se ha terminado el algoritmo sin obtener la soluci�n
    } while (! $queue->isEmpty());

    //Cerramos conexi�n anterior
    mysqli_close($conexion);
    
    // devuelve 0 como indicativo de que no est�n correlacionados
    return 0;
}


//Funcion auxiliar para buscar hijos de un nodo (ALGORITMO)
function buscaHijos($inicio, $conexion, &$queue, &$visitados){
    //Se selecciona el resto de hijos
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
    
    // Hay que resetear la posici�n de la selecci�n
    mysqli_data_seek($hijos, 0);
    
    // Se busca el resto de hijos
    // Cola FIFO. Los elementos se a�aden al final, y se van sacando por el primero
    // Los busca en los seleccionados en orden de forma iterativa hasta encontrar las coincidencias
    while ($row = mysqli_fetch_assoc($hijos)) {
        // Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola
        if (! in_array($row['ClaveHijo'], $visitados)) {
            array_push($visitados, $row['ClaveHijo']);
            $queue->enqueue($row);
        } /*
        * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
        * en visitados, pero se a�ade a la cola, porque por su naturaleza expanden el �rbol mas all�.
        */
        elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
            $queue->enqueue($row);
        }
        /*
         * Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
         * en cuenta para la b�squeda, por por su naturaleza. b�squeda en grafos).
         */
        // }
    }
}







