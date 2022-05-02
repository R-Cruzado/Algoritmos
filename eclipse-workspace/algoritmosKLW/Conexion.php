<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes, y cerrar la conexión habierta.
 * También hace la llamada a la semilla correspondiente
 */


require_once("Semilla1.php");
require_once("Semilla2.php");
require_once("Semilla3.php");


/*
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes
 * $dks: Tipo de dks donde se harán las consultas, $semilla: nivel de dificultad del dks
 * */
function conexion($dks, $semilla){
    
    switch($dks){
        case 'DksBasico':
            //conexión a la BBDD
            $DksBasicoConexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dksbasico")or die("Error en la conexion de DKSbasico");
            //Se rellenan los datos de la BBDD con la semilla correspondiente
            /*$semilla = semilla($semilla, $DksBasicoConexion);
            //Si semilla incorrecta
            if ($semilla == 0)
                return 0;*/
            //consulta a la BBDD
            $DksBasicoConsulta = mysqli_query($DksBasicoConexion,"select * from conceptos_conceptos");
            /*
             * Array para devolver conexión y consulta, ya que necesitamos la conexión que hemos habierto para después
             * cerrarla, y la consulta para desarrollar el algoritmo.
             */
            $salida = array($DksBasicoConexion, $DksBasicoConsulta);
            return $salida;
        case 'DksDesarrollo':
            //Conexión a las base de datos, dos_ es una BBDD de prueba
            $DksDesarrolloConexion=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dksdesarrollo")or die("Error en la conexion de DksDesarrollo");
            /*$semilla = semilla($semilla, $DksDesarrolloConexion);
            if ($semilla == 0)
                return 0;*/
            $DksDesarrolloConsulta = mysqli_query($DksDesarrolloConexion,"select * from conceptos_conceptos");
            $salida = array($DksDesarrolloConexion, $DksDesarrolloConsulta);
            return $salida;
        case 'DksGeneric':
            $DksGenericConexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de GenericConexion");
            /*$semilla = semilla($semilla, $DksGenericConexion);
            if ($semilla == 0)
                return 0;*/
            $DksGenericConsulta = mysqli_query($DksGenericConexion,"select * from conceptos_conceptos");
            $salida = array($DksGenericConexion, $DksGenericConsulta);
            return $salida;
        case 'DksKLW':
            $DksKlwConexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
            /*$semilla = semilla($semilla, $DksKlwConexion);
            if ($semilla == 0)
                return 0;*/
            $DksKlwConsulta = mysqli_query($DksKlwConexion,"select * from conceptos_conceptos");
            $salida = array($DksKlwConexion, $DksKlwConsulta);
            return $salida;
        case 'DksLanguajes':
            $DksLanguajesConexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de LanguajesConexion");
            /*$semilla = semilla($semilla, $DksLanguajesConexion);
            if ($semilla == 0)
                return 0;*/
            $DKSLanguajesConsulta = mysqli_query($DksLanguajesConexion,"select * from conceptos_conceptos");
            $salida = array($DksLanguajesConexion, $DKSLanguajesConsulta);
            return $salida;
        default:
            print "El DKS pasado por parámetro no existe";
            
    }
    
}


//Se rellenan los datos de la BBDD con la semilla correspondiente
function semilla($semilla, $conBBDD){
    switch($semilla){
        case 1:
            return semilla1($conBBDD);
        case 2:
            return semilla2($conBBDD);
        case 3:
            return semilla3($conBBDD);
        default:
            print "La semilla introducida es incorrecta ";
            return 0;
    }
}


// Cerrar la conexión ya habierta anteriormente y devuelta en la función anterior
function CierreConexion($conexion){
    
    mysqli_close($conexion);
    return 0;
    
}



