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
 * Función para cambiar de DKS y hacer las llamadas correspondientes al tipo de acoplamiento de los algoritmos de búsqueda
 * En esta función se hace la parte del algoritmo en la que se va iterando mientras haya elementos en la estructura 
 * de datos o se encuentre la solución
 */
function distribucion($fin, $estructuraDatos, $visitados, $dks, $algoritmo, $profundidad)
{
    /*
     * Dependiendo del algoritmo, el algoritmo a llamar y la estructura será distinta, el resto (distribucion) es igual
     * Las llamadas a las funciones de la estructura de datos se hacen cogiendo el nombre de las funciones mediante variables
     */
    if ($algoritmo == 'Primero_anchura'){
        $desacoplar = 'dequeue';
    }elseif($algoritmo == 'Primero_profundidad'){
        //pila auxiliar
        $aux = new SplStack();
        $desacoplar = 'pop';
    }elseif($algoritmo == 'Coste_uniforme'){
        /*
         * A los nodos que no son referencias, hay que ir quitándole prioridad a los posteriormente
         * encontrados para que sigan un orden de encontrados también
         */
        $contador = 0;
        // las referencias cuentan con menos prioridad, y también hay que priorizarlos por el orden de encontrados
        $contadorReferencias = -9999999;
        $desacoplar = 'extract';
    }
    
    //Variable para establecer las conexiones a la base de datos
    $conexion = 0;
    //Variable para buscar el padre de un concepto instanciado o referenciado
    $padre = 0;
    //El nombre del dks cambia dependiendo del dks desde el que estemos buscando
    $dks_actual = $dks;
    //Contador de profundidad de conexiones a DKS
    $cuentaConexiones = 0;
    //Coletilla para saber si seguimos en la misma conexión
    $cambioConexion = 1;
    
    // Bucle while o do while es mas eficiente que la recursividad en programación imperativa, como lo es PHP
    do {
        // Padre actual
        $inicio = $estructuraDatos->$desacoplar();
        
        // Para mostrar camino
        //print $inicio['IdRel'] . $inicio['ClaveHijo'] .$inicio['IdRelPadre']." ";
        print $inicio['IdRel']." ";
        
        // (Stop) Para el algoritmo si encuentra el parentesco, muestra por pantalla que están relacionados, si no, no lo están.
        if ($inicio['ClaveHijo'] == $fin) {
            print "(Estan relacionados) "."Ha habido una profundidad de ". $cuentaConexiones. " conexiones a distintos DKS";
            //cerramos conexión anterior
            mysqli_close($conexion);
            // Si están relacionados devuelve 1 como indicativo de que lo están
            return 1;
        }
        
        //si está en otro dks
        if ($inicio['Localidad'] == 0) {
            
            print "(<-- Nueva conexion) ";
            
            //Aumenta el contador de conexiones a otros DKS
            $cuentaConexiones ++;
            
            //Si se supera el máximo de profundidad pasado por parámetro sin encontrar la solución termina la búsqueda
            if ($cuentaConexiones > $profundidad){
                print "(Se ha superado la profundidad maxima de ". $profundidad. " conexiones a distintos DKS) ";
                return 0;
            }
            
            //Cerramos conexion anterior
            mysqli_close($conexion);
            
            //conexión a otro DKS
            conexionOtroDKS($inicio, $conexion);
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);
            
            //se cambia al dks local
            $cambioConexion = 1;
            
            //búsqueda de hijos
            if ($algoritmo == 'Primero_anchura'){
                //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS con $padre de busquedaConcepto (ALGORITMO)
                primeroEnAnchura($padre, $conexion, $estructuraDatos, $visitados);
                // Búsqueda del resto de genes hijos locales con $inicio
                genesLocalesAnchura($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $cambioConexion);

            }elseif ($algoritmo == 'Primero_profundidad'){
                
                primeroEnProfundidad($padre, $conexion, $estructuraDatos, $visitados, $aux);
                genesLocalesProfundidad($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $aux, $cambioConexion);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Coste_uniforme'){
                costeUniforme($padre, $conexion, $estructuraDatos, $visitados, $contador, $contadorReferencias);
                genesLocalesCoste($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $contador, $contadorReferencias, $cambioConexion);
            }
        }
        /*
         * Si se instancia o referencia a un concepto local y si no es el primer nodo, ya que
         * si es el primer nodo no hace referencia o instancia a otro concepto
         */
        elseif (($inicio['InsRef'] == 1 || $inicio['InsRef'] == 0) && $inicio['Localidad'] == 1 && $inicio['IdRelPadre'] != 0){
            
            if ($cambioConexion == 1){
                //hay que hacer las conexiones en el dks en el que nos encontramos
                DKSactual($inicio, $dks_actual);
                //Volver al DKS local
                volverDKSLocal($cambioConexion, $dks_actual, $conexion);
            }
            
            //Se busca el concepto instanciado o referenciado
            busquedaConcepto($inicio, $conexion, $padre);
            
            if ($algoritmo == 'Primero_anchura'){
                primeroEnAnchura($padre, $conexion, $estructuraDatos, $visitados);
                genesLocalesAnchura($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $cambioConexion);
            }elseif ($algoritmo == 'Primero_profundidad'){
                //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
                primeroEnProfundidad($padre, $conexion, $estructuraDatos, $visitados, $aux);
                // Búsqueda del resto de genes hijos locales
                genesLocalesProfundidad($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $aux, $cambioConexion);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Coste_uniforme'){
                costeUniforme($padre, $conexion, $estructuraDatos, $visitados, $contador, $contadorReferencias);
                genesLocalesCoste($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $algoritmo, $contador, $contadorReferencias, $cambioConexion);
            }
        }
        //Si estamos en el DKS local, y es un sinTecho o el primer nodo
        elseif (($inicio['InsRef'] == 2 || ($inicio['InsRef'] == 0 && $inicio['IdRelPadre'] == 0)) && $inicio['Localidad'] == 1 ){
            
            if ($cambioConexion == 1){
                //hay que hacer las conexiones en el dks en el que nos encontramos
                DKSactual($inicio, $dks_actual);
                //Volver al DKS local
                volverDKSLocal($cambioConexion, $dks_actual, $conexion);
            }
            
            //Búsqueda de hijos
            if ($algoritmo == 'Primero_anchura'){
                genesLocalesAnchura($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $cambioConexion);
            }elseif ($algoritmo == 'Primero_profundidad'){
                // Búsqueda de genes locales
                genesLocalesProfundidad($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $aux, $cambioConexion);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Coste_uniforme'){
                genesLocalesCoste($inicio, $conexion, $estructuraDatos, $visitados, $dks_actual, $contador, $contadorReferencias, $cambioConexion);
            }
            
        }
        
        // Si la cola acaba vacía es que se ha terminado el algoritmo sin obtener la solución
    } while (! $estructuraDatos->isEmpty());
    
    //Cerramos conexión anterior
    mysqli_close($conexion);
    
    // (Stop) devuelve 0 como indicativo de que no están correlacionados
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


//Función auxiliar para la búsqueda de genes locales de búsqueda en anchura, & es paso por referencia
function genesLocalesAnchura($inicio, &$conexion, &$queue, &$visitados, $dks_actual, &$cambioConexion){
    
    //Conectarse al DKS Local en caso de que haya cambiado la conexión
    if ($cambioConexion == 1){
        volverDKSLocal($cambioConexion, $dks_actual, $conexion);
    }
    
    //Se buscan los hijos (ALGORITMO)
    primeroEnAnchura($inicio, $conexion, $queue, $visitados);
    
}

//Función auxiliar para la búsqueda de genes locales de búsqueda en profundidad, & es paso por referencia
function genesLocalesProfundidad($inicio, &$conexion, &$queue, &$visitados, $dks_actual, &$aux, &$cambioConexion){
    
    if ($cambioConexion == 1){
        //Conectarse al DKS local
        volverDKSLocal($cambioConexion, $dks_actual, $conexion);
    }
    
    //Se buscan los hijos (ALGORITMO)
    primeroEnProfundidad($inicio, $conexion, $queue, $visitados, $aux);
    
}

//Función auxiliar para la búsqueda de genes locales de búsqueda por coste, & es paso por referencia
function genesLocalesCoste($inicio, &$conexion, &$queue, &$visitados, $dks_actual, &$contador, &$contadorReferencias, &$cambioConexion){
    
    if ($cambioConexion == 1){
        //Conectarse al DKS local
        volverDKSLocal($cambioConexion, $dks_actual, $conexion);
    }
    
    //Se buscan los hijos (ALGORITMO)
    costeUniforme($inicio, $conexion, $queue, $visitados, $contador, $contadorReferencias);
    
}

//Hay que cambiar al DKS en el que estamos
function DKSactual($inicio, &$dks_actual){
    if ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic/lan_es" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic/lan_ing") {
        $dks_actual = "DksGeneric";
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw/lan_es" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw/lan_ing") {
        $dks_actual= "DksKLW";
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes/lan_es" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes/lan_ing") {
        $dks_actual = "DksLanguajes";
    } elseif($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_basico" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_basico/lan_es" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_basico/lan_ing"){
        $dks_actual = "DksBasico";
    } elseif($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_desarrollo" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_desarrollo/lan_es" || $inicio['LocalizacionHijo'] == "http://localhost/klw/dks_desarrollo/lan_ing"){
        $dks_actual = "DksDesarrollo";
    }
}

/*
 * Conectarse al DKS actual, solo si se cambia de dks respecto al nodo anterior para no repetir conexiones (1 o 0)
 * Si $cambioConexion == 1 es porque se ha cambiado de DKS y hay que establecer otra conexión
 */ 
function volverDKSLocal(&$cambioConexion, &$dks_actual, &$conexion){
    //cerramos la conexión anterior
    mysqli_close($conexion);
    //Se realiza la conexión a la BBDD del dks local
    conexion($dks_actual, $conexion);
    //se vuelve a poner a 0
    $cambioConexion = 0;
}
