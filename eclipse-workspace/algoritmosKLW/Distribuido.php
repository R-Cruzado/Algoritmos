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


//Funci�n para cambiar de DKS y hacer las llamadas correspondientes a los algoritmos de b�squeda
function distribucion($fin, $estructuraDatos, $visitados, $dks, $algoritmo)
{
    //Dependiendo del algoritmo, el algoritmo a llamar y la estructura ser� distinta, el resto (distribucion) es igual
    if ($algoritmo == 'Primero_anchura'){
        $desacoplar = 'dequeue';
        $buscaHijos = 'primeroEnAnchura';
    }elseif($algoritmo == 'Primero_anchura'){
        $desacoplar = 'pop';
        $buscaHijos = 'primeroEnProfundidad';
    }elseif($algoritmo == 'Primero_anchura'){
        $desacoplar = 'extract';
        $buscaHijos = 'costeUniforme';
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
            $buscaHijos($padre, $conexion, $estructuraDatos, $visitados);
            
            // B�squeda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos);
            
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
            $buscaHijos($padre, $conexion, $estructuraDatos, $visitados);
            
            // B�squeda del resto de genes hijos locales
            genesLocales($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos);
            
        }
        //Si estamos en el DKS local, y es un sinTecho o el primer nodo
        elseif (($inicio['InsRef'] == 2 || ($inicio['InsRef'] == 0 && $inicio['IdRelPadre'] == 0)) && $inicio['Localidad'] == 1 ){
            
            // B�squeda de genes locales
            genesLocales($inicio, $conexion, $estructuraDatos, $visitados, $dks, $buscaHijos);
            
        }
        
        // Si la cola acaba vac�a es que se ha terminado el algoritmo sin obtener la soluci�n
    } while (! $estructuraDatos->isEmpty());
    
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
function genesLocales($inicio, &$conexion, &$queue, &$visitados, $dks, $buscaHijos){
    
    //cerramos la conexion anterior
    mysqli_close($conexion);
    
    //Se realiza la conexi�n a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    $buscaHijos($inicio, $conexion, $queue, $visitados);
    
}