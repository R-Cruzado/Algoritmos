<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Funciones útiles para que los algoritmos funcionen de forma distribuida
 */

require_once("Primero_anchura.php");
require_once("Primero_profundidad.php");
require_once("Coste_uniforme.php");
require_once("Conexion.php");

/*
 * Función para cambiar de DKS y hacer las llamadas correspondientes al tipo de apcoplamiento de los algoritmos de búsqueda
 * En esta función se hace la parte del algoritmo en la que se va iterando mientras haya elementos en la estructura de datos
 */
function distribucion($fin, $estructuraDatos, $visitados, $dks, $algoritmo)
{
    /*
     * Dependiendo del algoritmo, el algoritmo a llamar y la estructura será distinta, el resto (distribucion) es igual
     * Las llamadas a las funciones se hacen cogiendo el nombre de las funciones mediante variables
     */
    if ($algoritmo == 'Primero_anchura'){
        $desacoplar = 'dequeue';
        $buscaHijos = 'primeroEnAnchura';
    }elseif($algoritmo == 'Primero_profundidad'){
        //pila auxiliar
        $aux = new SplStack();
        $desacoplar = 'pop';
        $buscaHijos = 'primeroEnProfundidad';
    }elseif($algoritmo == 'Coste_uniforme'){
        /*
         * A los nodos que no son referencias, hay que ir quitándole prioridad a los posteriormente
         * encontrados para que sigan un orden de encontrados también
         */
        $contador = 0;
        // las referencias cuentan con menos prioridad, y también hay que priorizarlos por el orden de encontrados
        $contadorReferencias = -9999999;
        $desacoplar = 'extract';
        $buscaHijos = 'costeUniforme';
    }
    
    //Variable para establecer las conexiones a la base de datos
    $conexion = 0;
    //Variable para buscar el padre de un concepto instanciado o referenciado
    $padre = 0;
    
    // Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do {
        // Padre actual
        $inicio = $estructuraDatos->$desacoplar();
        
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

            if ($algoritmo == 'Primero_profundidad'){
                //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
                $buscaHijos($padre, $conexion, $estructuraDatos, $visitados, $aux);
                // Búsqueda del resto de genes hijos locales
                genesLocales($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $aux, $algoritmo);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Primero_anchura'){
                
                $buscaHijos($padre, $conexion, $estructuraDatos, $visitados);
                genesLocales2($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $algoritmo);
                
            }elseif ($algoritmo == 'Coste_uniforme'){
                
                $buscaHijos($padre, $conexion, $estructuraDatos, $visitados, $contador, $contadorReferencias);
                genesLocales3($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $algoritmo, $contador, $contadorReferencias);
            
            }
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
            
            if ($algoritmo == 'Primero_profundidad'){
                //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
                $buscaHijos($padre, $conexion, $estructuraDatos, $visitados, $aux);
                // Búsqueda del resto de genes hijos locales
                genesLocales($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $aux, $algoritmo);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Primero_anchura'){
                
                $buscaHijos($padre, $conexion, $estructuraDatos, $visitados);
                genesLocales2($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $algoritmo);
                
            }elseif ($algoritmo == 'Coste_uniforme'){
                
                $buscaHijos($padre, $conexion, $estructuraDatos, $visitados, $contador, $contadorReferencias);
                genesLocales3($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $algoritmo, $contador, $contadorReferencias);
                
            }
            
        }
        //Si estamos en el DKS local, y es un sinTecho o el primer nodo
        elseif (($inicio['InsRef'] == 2 || ($inicio['InsRef'] == 0 && $inicio['IdRelPadre'] == 0)) && $inicio['Localidad'] == 1 ){

            if ($algoritmo == 'Primero_profundidad'){
                // Búsqueda de genes locales
                genesLocales($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $aux, $algoritmo);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Primero_anchura'){
                genesLocales2($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $algoritmo);
            }elseif ($algoritmo == 'Coste_uniforme'){
                genesLocales3($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos, $algoritmo, $contador, $contadorReferencias);
            }
            
        }
        
        // Si la cola acaba vacía es que se ha terminado el algoritmo sin obtener la solución
    } while (! $estructuraDatos->isEmpty());
    
    //Cerramos conexión anterior
    mysqli_close($conexion);
    
    // devuelve 0 como indicativo de que no están correlacionados
    return 0;
}


//Función auxiliar para buscar el concepto instanciado o referenciado
function busquedaConcepto($inicio, $conexion, &$padre){
    
    $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE ClaveHijo = '" . $inicio['ClaveHijo'] . "'");
    
    mysqli_data_seek($hijos, 0);
    
    //Buscar el concepto instanciado o referenciado en este mismo dks
    while ($row = mysqli_fetch_assoc($hijos)) {
        $padre = $row;
        break;
    }
    
}


//Función auxiliar para la búsqueda de genes locales, & es paso por referencia
function genesLocales($inicio, &$conexion, &$queue, &$visitados, $dks, $buscaHijos, &$aux, $algoritmo){

    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexión a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    $buscaHijos($inicio, $conexion, $queue, $visitados, $aux);
    
}

//Función auxiliar para la búsqueda de genes locales, & es paso por referencia
function genesLocales2($inicio, &$conexion, &$queue, &$visitados, $dks, $buscaHijos, $algoritmo){
    
    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexión a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    $buscaHijos($inicio, $conexion, $queue, $visitados);
    
}

//Función auxiliar para la búsqueda de genes locales, & es paso por referencia
function genesLocales3($inicio, &$conexion, &$queue, &$visitados, $dks, $buscaHijos, $algoritmo, &$contador, &$contadorReferencias){
    
    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexión a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    $buscaHijos($inicio, $conexion, $queue, $visitados, $contador, $contadorReferencias);
    
}