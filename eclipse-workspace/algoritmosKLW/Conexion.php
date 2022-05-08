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
function consulta($dks, $semilla, $inicio){
    
    $conexion = 0;
    //Se realiza la conexión a la BBDD del dks actual
    conexion($dks, $conexion);
    //consulta a la BBDD sobre el primer gen pasado por parámetro
    $consulta = mysqli_query($conexion,"SELECT * FROM conceptos_conceptos WHERE ClaveHijo = '".$inicio."'");
    //devolvemos la consulta
    return $consulta;
    
}


function conexion($dks, &$conexion){
    switch($dks){
        case 'DksBasico':
            //conexión a la BBDD
            $conexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dksbasico")or die("Error en la conexion de DKSbasico");
            //Se rellenan los datos de la BBDD con la semilla correspondiente
            //Comentado porque las semillas se utilizan para realizar las pruebas de eficiencia, cuando se utilizan las semillas se descomenta
            /*$semilla = semilla($semilla, $conexion);
             //Si semilla incorrecta
             if ($semilla == 0)
             return 0;*/
             break;
        case 'DksDesarrollo':
            //Conexión a las base de datos, dos_ es una BBDD de prueba
            $conexion=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dksdesarrollo")or die("Error en la conexion de DksDesarrollo");
            /*$semilla = semilla($semilla, $DksDesarrolloConexion);
             if ($semilla == 0)
             return 0;*/
             break;
        case 'DksGeneric':
            $conexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de GenericConexion");
            /*$semilla = semilla($semilla, $DksGenericConexion);
             if ($semilla == 0)
             return 0;*/
             break;
        case 'DksKLW':
            $conexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
            /*$semilla = semilla($semilla, $DksKlwConexion);
             if ($semilla == 0)
             return 0;*/
             break;
        case 'DksLanguajes':
            $conexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de LanguajesConexion");
            /*$semilla = semilla($semilla, $DksLanguajesConexion);
             if ($semilla == 0)
             return 0;*/
             
        default:
            print "El DKS pasado por parametro no existe ";
            return 0;
    }
}

//Conexión a otro DKS
function conexionOtroDKS($inicio, &$conexion){
    
    if ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic") {
        $conexion = @mysqli_connect("localhost", "usrDksGeneric", "lo93b5jd84h5", "dksgeneric") or die("Error en la conexion de GenericConexion");
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw") {
        $conexion = @mysqli_connect("localhost", "usrDksKlw", "cd4ji96hu9bd", "dksklw") or die("Error en la conexion de DKSbasico");
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes") {
        $conexion = @mysqli_connect("localhost", "usrDksLanguajes", "kdhr7m4j6f2b", "dkslanguajes") or die("Error en la conexion de DKSbasico");
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



