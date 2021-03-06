<?php

/*
 * @author : Roberto Cruzado Mart?nez
 * @a?o: 2022
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes, y cerrar la conexi?n abierta.
 * Tambi?n hace la llamada a la semilla correspondiente
 */

require_once ("Semilla.php");


/*
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes
 * $dks: Tipo de dks donde se har?n las consultas, $semilla: nivel de dificultad del dks,
 * $genes: Numero de genes (nodos) generados por cada base de datos de las 5 que hay (5 DKS),
 * $inicio: nombre del primer gen a buscar
 * */
function consulta($dks, $genes, $inicio){
    
    $conexion = 0;
    //Se rellenan de datos de las BBDD de los distintos DKS seg?n el n?mero de nodos pasado por par?metro
    //generador($genes);
    //Se realiza la conexi?n a la BBDD del dks actual
    conexion($dks, $conexion);
    //consulta a la BBDD sobre el primer gen pasado por par?metro
    $consulta = mysqli_query($conexion,"SELECT * FROM conceptos_conceptos WHERE ClaveHijo = '".$inicio."'");
    //devolvemos la consulta
    return $consulta;
}

// Conexion a DKS local
function conexion($dks, &$conexion){
    switch($dks){
        case 'DksBasico':
            //conexi?n a la BBDD
            $conexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dksbasico")or die("Error en la conexion de DKSbasico");
            break;
        case 'DksDesarrollo':
            //Conexi?n a las base de datos, dos_ es una BBDD de prueba
            $conexion=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dksdesarrollo")or die("Error en la conexion de DksDesarrollo");
            break;
        case 'DksGeneric':
            $conexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de GenericConexion");
            break;
        case 'DksKLW':
            $conexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
            break;
        case 'DksLanguajes':
            $conexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de LanguajesConexion");
            break;
        default:
            print "El DKS pasado por parametro no existe ";
            return 0;
    }
}

//Conexi?n a otro DKS
function conexionOtroDKS($inicio, &$conexion){
    if ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic") {
        $conexion = @mysqli_connect("localhost", "usrDksGeneric", "lo93b5jd84h5", "dksgeneric") or die("Error en la conexion de GenericConexion");
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw") {
        $conexion = @mysqli_connect("localhost", "usrDksKlw", "cd4ji96hu9bd", "dksklw") or die("Error en la conexion de DKSbasico");
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes") {
        $conexion = @mysqli_connect("localhost", "usrDksLanguajes", "kdhr7m4j6f2b", "dkslanguajes") or die("Error en la conexion de DKSbasico");
    }
}


//Se rellenan los datos de todas las BBDD con el n?mero de genes pasado por par?metro por cada BBDD
function generador($genes){
    
    // Conexion e insercci?n de datos en la base de datos de DKS_b?sico
    $conexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dksbasico")or die("Error en la conexion de DKSbasico");
    $dks = "dks_basico";
    //llamada a funci?n a trav?s de variable concatenada
    semilla($conexion, $dks, $genes);
    
    // Conexion e insercci?n de datos en la base de datos de DKS_desarrollo
    $conexion=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dksdesarrollo")or die("Error en la conexion de DksDesarrollo");
    $dks = "dks_desarrollo";
    semilla($conexion, $dks, $genes);
    
    // Conexion e insercci?n de datos en la base de datos de DKS_generic
    $conexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de GenericConexion");
    $dks = "dks_Generic";
    semilla($conexion, $dks, $genes);
    
    // Conexion e insercci?n de datos en la base de datos de DKS_KLW
    $conexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
    $dks = "dks_klw";
    semilla($conexion, $dks, $genes);
    
    // Conexion e insercci?n de datos en la base de datos de DKS_languajes
    $conexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de LanguajesConexion");
    $dks = "dks_Languajes";
    semilla($conexion, $dks, $genes);
    
}


