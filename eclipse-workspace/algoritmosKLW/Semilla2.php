<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Semilla 2
 */


function semilla2($conBBDD){
    
    //borramos los datos que pueda haber en la BBDD de otras semillas
    mysqli_query($conBBDD,"delete from conceptos_conceptos");
    
    //Necesitamos caracteres para crear la columna ClaveHijo
    $caracteres = 'abcdefghijklmnopqrstuvwxyz';
    
    //Se asignan los datos a la BBDD. Se pueden hacer varios similares de distinto tamaño y cada uno sería un concepto
    for ($IdRel = 1; $IdRel <= 5000; $IdRel++) {
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
        
        //referencia, instancia o sinTecho
        $InsRef = rand(0,2);
        
        //INSREF!!!!!!!!!!!!!!!!!!!!!!!!!!!! MOSTRAR TIEMPO DE EJECUCIÓN
        
        //print $IdRel."*".$IdRelPadre."*".$ClaveHijo."*".$InsRef." ";

        mysqli_query($conBBDD, "INSERT INTO conceptos_conceptos VALUES
            ('".$IdRel."','".$IdRelPadre."','".$ClaveHijo."','a',1,'',1,'".$InsRef."')");
    }
    

    
}



