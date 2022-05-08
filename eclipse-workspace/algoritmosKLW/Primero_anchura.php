<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo de primero en anchura
 */
require_once ("Llamada.php");

// Algoritmo de primero en anchura
function primeroEnAnchura($fin, $queue, $visitados, $dks)
{
    // !!!!!!CUIDADO CON LA CONEXI�N QUE CIERRA AL FINAL
    // !!!!!!UTILIZAR FUNCIONES Y OBTIMIZAR C�DIGO
    
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
            if ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic") {
                $conexion = @mysqli_connect("localhost", "usrDksGeneric", "lo93b5jd84h5", "dksgeneric") or die("Error en la conexion de GenericConexion");
            } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw") {
                $conexion = @mysqli_connect("localhost", "usrDksKlw", "cd4ji96hu9bd", "dksklw") or die("Error en la conexion de DKSbasico");
            } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes") {
                $conexion = @mysqli_connect("localhost", "usrDksLanguajes", "kdhr7m4j6f2b", "dkslanguajes") or die("Error en la conexion de DKSbasico");
            }
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);

            //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS
            buscaHijos($padre, $conexion, $queue, $visitados);
            
            // // B�squeda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }
        
        /*
         * Si se instancia o referencia a un concepto local y si no es el prmier nodo, ya que  
         * si es el primer nodo no hace referencia o instancia a otro concepto
         */
        elseif (($inicio['InsRef'] == 1 || $inicio['InsRef'] == 0) && $inicio['Localidad'] == 1 && $inicio['IdRelPadre'] != 0){
            
            //cerramos la conexi�n anterior
            mysqli_close($conexion);
            //nos conectamos al dks local
            switch ($dks) {
                case 'DksBasico':
                    $conexion = @mysqli_connect("localhost", "usrDksBasico", "mifg6ef3pj33", "dksbasico") or die("Error en la conexion de DKSbasico");
                    break;
                case 'DksDesarrollo':
                    $conexion = @mysqli_connect("localhost", "usrDksDesarrollo", "m5nd7Dt0Uf3c", "dksdesarrollo") or die("Error en la conexion de DksDesarrollo");
                    break;
                case 'DksGeneric':
                    $conexion = @mysqli_connect("localhost", "usrDksGeneric", "lo93b5jd84h5", "dksgeneric") or die("Error en la conexion de GenericConexion");
                    break;
                case 'DksKLW':
                    $conexion = @mysqli_connect("localhost", "usrDksKlw", "cd4ji96hu9bd", "dksklw") or die("Error en la conexion de KlwConexion");
                    break;
                case 'DksLanguajes':
                    $conexion = @mysqli_connect("localhost", "usrDksLanguajes", "kdhr7m4j6f2b", "dkslanguajes") or die("Error en la conexion de LanguajesConexion");
                    break;
            }
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);
            
            //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS
            buscaHijos($padre, $conexion, $queue, $visitados);
            
            // B�squeda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $queue, $visitados, $dks);
            
        }
        /*
         * Si estamos en el DKS local, y es un sinTecho o el primer nodo
         */
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





//Funci�n auxiliar para buscar el concepto instanciado o referenciado
function busquedaConcepto($inicio, $conexion, &$padre){
    
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE ClaveHijo = '" . $inicio['ClaveHijo'] . "'");
    
    mysqli_data_seek($hijos, 0);
    
    //Buscar el concepto instanciado o referenciado en este mismo dks
    while ($row = mysqli_fetch_assoc($hijos)) {
        $padre = $row;
        break;
    }
    
}


//Funci�n auxiliar para la b�squeda de genes locales, & es paso por referencia
function genesLocales($inicio, &$conexion, &$queue, &$visitados, $dks){
    
    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //nos conectamos al dks local
    switch ($dks) {
        case 'DksBasico':
            $conexion = @mysqli_connect("localhost", "usrDksBasico", "mifg6ef3pj33", "dksbasico") or die("Error en la conexion de DKSbasico");
            break;
        case 'DksDesarrollo':
            $conexion = @mysqli_connect("localhost", "usrDksDesarrollo", "m5nd7Dt0Uf3c", "dksdesarrollo") or die("Error en la conexion de DksDesarrollo");
            break;
        case 'DksGeneric':
            $conexion = @mysqli_connect("localhost", "usrDksGeneric", "lo93b5jd84h5", "dksgeneric") or die("Error en la conexion de GenericConexion");
            break;
        case 'DksKLW':
            $conexion = @mysqli_connect("localhost", "usrDksKlw", "cd4ji96hu9bd", "dksklw") or die("Error en la conexion de KlwConexion");
            break;
        case 'DksLanguajes':
            $conexion = @mysqli_connect("localhost", "usrDksLanguajes", "kdhr7m4j6f2b", "dkslanguajes") or die("Error en la conexion de LanguajesConexion");
            break;
    }
    
    //Se buscan los hijos
    buscaHijos($inicio, $conexion, $queue, $visitados);
    
}


//Funcion auxiliar para buscar hijos de un nodo
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







