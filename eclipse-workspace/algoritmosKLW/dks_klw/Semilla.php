<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Semilla 1
 */


//Función para insertar los datos en la conexión de la base de datos actual
function semilla($conexion, $genes){
    //borramos los datos que pueda haber en la BBDD de otras semillas
    mysqli_query($conexion,"delete from conceptos_conceptos");
    
    //Necesitamos caracteres para crear la columna ClaveHijo
    $caracteres = 'abcdefghijklmnopqrstuvwxyz';
    
    //Se asignan los datos a la BBDD. Se pueden hacer varios similares de distinto tamaño y cada uno sería un concepto
    //Ejemplo: si generea 1000 genes (nodos) por base de datos, hay 5 bases de datos luego buscaría en 5000 nodos
    for ($IdRel = 1; $IdRel <= $genes; $IdRel++) {
        //Nodo raiz
        if ($IdRel == 1){
            $IdRelPadre = 0;
        }else{
            //Padre anterior
            $IdRel2 = $IdRel-1;
            //Posible ancestro
            $IdRelPadre = rand(1,$IdRel2);
        }
        
        //Es un nombre de ejemplo de la 'a' a la 'z'
        $ClaveHijo = substr(str_shuffle($caracteres), 0, 1);
        
        $OrdinalHijo = rand(0,1);
        
        $TiempoActualizacionHijo = 0;
        
        //Indica si el concepto reside en el DKS o en uno externo. Externo = 0, Interno = 1.
        $Localidad = rand(0,1);
        
        //Si está en otro DKS
        if ($Localidad == 0){
            $LocalizacionHijoArray = array("http://localhost/klw/dks_Generic", "http://localhost/klw/dks_klw", "http://localhost/klw/dks_Languajes");
        }
        //Si está en el mismo DKS
        else{
            $LocalizacionHijoArray = array("http://localhost/klw/dks_klw", "http://localhost/klw/dks_klw/lan_es", "http://localhost/klw/dks_klw/lan_es");
        }
        // array_rand elige un elemento aleatorio de un array
        // Localización del hijo
        $LocalizacionHijo = $LocalizacionHijoArray[array_rand($LocalizacionHijoArray)];
        
        $FamiliaArray = array("", "ai_es_", "ai_ing_");
        $Familia = $FamiliaArray[array_rand($FamiliaArray)];
        
        $IdEnTabla = rand(0,50);
        
        //referencia, instancia o sinTecho
        $InsRef = rand(0,2);
        
        //mostrar datos insertados
        //print $IdRel."*".$IdRelPadre."*".$ClaveHijo."*".$InsRef." ";
        
        //Se insertan los datos
        mysqli_query($conexion, "INSERT INTO conceptos_conceptos VALUES
            ('".$IdRel."','".$IdRelPadre."','".$ClaveHijo."','".$LocalizacionHijo."','".$OrdinalHijo."','".$TiempoActualizacionHijo."','".$Localidad."','".$Familia."','".$IdEnTabla."','".$InsRef."')");
    }
    
    mysqli_close($conexion);
}
