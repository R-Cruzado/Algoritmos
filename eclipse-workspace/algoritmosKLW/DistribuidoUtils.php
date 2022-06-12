<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Funciones �tiles para que los algoritmos funcionen de forma distribuida
 */

require_once("Primero_anchura.php");
require_once("Primero_profundidad.php");
require_once("Coste_uniforme.php");

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
    
    //Se realiza la conexi�n a la BBDD del dks local
    conexion($dks, $conexion);
    
    //Se buscan los hijos (ALGORITMO)
    buscaHijos($inicio, $conexion, $queue, $visitados);
    
}