<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Funciones �tiles para que los algoritmos funcionen de forma distribuida
 */

require_once("Primero_anchura.php");
require_once("Primero_profundidad.php");
require_once("Coste_uniforme.php");
require_once("Conexion.php");

/*
 * Funci�n para cambiar de DKS y hacer las llamadas correspondientes al tipo de apcoplamiento de los algoritmos de b�squeda
 * En esta funci�n se hace la parte del algoritmo en la que se va iterando mientras haya elementos en la estructura de datos
 */
function distribucion($fin, $estructuraDatos, $visitados, $dks, $algoritmo)
{
    /*
     * Dependiendo del algoritmo, el algoritmo a llamar y la estructura ser� distinta, el resto (distribucion) es igual
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
         * A los nodos que no son referencias, hay que ir quit�ndole prioridad a los posteriormente
         * encontrados para que sigan un orden de encontrados tambi�n
         */
        $contador = 0;
        // las referencias cuentan con menos prioridad, y tambi�n hay que priorizarlos por el orden de encontrados
        $contadorReferencias = -9999999;
        $desacoplar = 'extract';
    }
    
    //Variable para establecer las conexiones a la base de datos
    $conexion = 0;
    //Variable para buscar el padre de un concepto instanciado o referenciado
    $padre = 0;
    
    // Bucle while o do while es mas eficiente que la recursividad en programaci�n imperativa, como lo es PHP
    do {
        // Padre actual
        $inicio = $estructuraDatos->$desacoplar();
        
        // Para mostrar camino
        //print $inicio['IdRel'] . $inicio['ClaveHijo'] .$inicio['IdRelPadre']." ";
        print $inicio['IdRel']." ";
        
        // (Stop) Para el algoritmo si encuentra el parentesco, muestra por pantalla que est�n relacionados, si no, no lo est�n.
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
            
            //b�squeda de hijos
            if ($algoritmo == 'Primero_anchura'){
                
                //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
                primeroEnAnchura($padre, $conexion, $estructuraDatos, $visitados);
                // B�squeda del resto de genes hijos locales
                genesLocalesAnchura($inicio, $conexion, $estructuraDatos, $visitados, $dks);
                
            }elseif ($algoritmo == 'Primero_profundidad'){
                
                primeroEnProfundidad($padre, $conexion, $estructuraDatos, $visitados, $aux);
                
                genesLocalesProfundidad($inicio, $conexion, $estructuraDatos, $visitados, $dks, $aux);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Coste_uniforme'){
                
                costeUniforme($padre, $conexion, $estructuraDatos, $visitados, $contador, $contadorReferencias);
                genesLocalesCoste($inicio, $conexion, $estructuraDatos, $visitados, $dks, $contador, $contadorReferencias);
            
            }
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
            
            if ($algoritmo == 'Primero_anchura'){
                
                primeroEnAnchura($padre, $conexion, $estructuraDatos, $visitados);
                genesLocalesAnchura($inicio, $conexion, $estructuraDatos, $visitados, $dks);
                
            }elseif ($algoritmo == 'Primero_profundidad'){
                //Se buscan los hijos del concepto instanciado o referenciado en este mismo DKS (ALGORITMO)
                primeroEnProfundidad($padre, $conexion, $estructuraDatos, $visitados, $aux);
                // B�squeda del resto de genes hijos locales
                genesLocalesProfundidad($inicio, $conexion, $estructuraDatos, $visitados, $dks, $aux);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Coste_uniforme'){
                
                costeUniforme($padre, $conexion, $estructuraDatos, $visitados, $contador, $contadorReferencias);
                genesLocalesCoste($inicio, $conexion, $estructuraDatos, $visitados, $dks, $algoritmo, $contador, $contadorReferencias);
                
            }
            
        }
        //Si estamos en el DKS local, y es un sinTecho o el primer nodo
        elseif (($inicio['InsRef'] == 2 || ($inicio['InsRef'] == 0 && $inicio['IdRelPadre'] == 0)) && $inicio['Localidad'] == 1 ){

            //B�squeda de hijos
            if ($algoritmo == 'Primero_anchura'){
                genesLocalesAnchura($inicio, $conexion, $estructuraDatos, $visitados, $dks, $algoritmo);
            }elseif ($algoritmo == 'Primero_profundidad'){
                // B�squeda de genes locales
                genesLocalesProfundidad($inicio, $conexion, $estructuraDatos, $visitados, $dks, $aux, $algoritmo);
                
                if (! $aux->isEmpty()) {
                    foreach ($aux as $value) {
                        $estructuraDatos->push($value);
                    }
                }
                
                $aux = new SplStack();
            }elseif ($algoritmo == 'Coste_uniforme'){
                genesLocalesCoste($inicio, $conexion, $estructuraDatos, $visitados, $dks, $contador, $contadorReferencias);
            }
            
        }
        
        // Si la cola acaba vac�a es que se ha terminado el algoritmo sin obtener la soluci�n
    } while (! $estructuraDatos->isEmpty());
    
    //Cerramos conexi�n anterior
    mysqli_close($conexion);
    
    // (Stop) devuelve 0 como indicativo de que no est�n correlacionados
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


//Funci�n auxiliar para la b�squeda de genes locales de b�squeda en anchura, & es paso por referencia
function genesLocalesAnchura($inicio, &$conexion, &$queue, &$visitados, $dks){
    
    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexi�n a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    primeroEnAnchura($inicio, $conexion, $queue, $visitados);
    
}

//Funci�n auxiliar para la b�squeda de genes locales de b�squeda en profundidad, & es paso por referencia
function genesLocalesProfundidad($inicio, &$conexion, &$queue, &$visitados, $dks, &$aux){

    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexi�n a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    primeroEnProfundidad($inicio, $conexion, $queue, $visitados, $aux);
    
}

//Funci�n auxiliar para la b�squeda de genes locales de b�squeda por coste, & es paso por referencia
function genesLocalesCoste($inicio, &$conexion, &$queue, &$visitados, $dks, &$contador, &$contadorReferencias){
    
    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexi�n a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    costeUniforme($inicio, $conexion, $queue, $visitados, $contador, $contadorReferencias);
    
}