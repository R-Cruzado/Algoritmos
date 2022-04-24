<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes, y cerrar la conexi�n habierta.
 * Tambi�n hace la llamada a la semilla correspondiente
 */


require_once("Semilla1.php");
/*require_once("Semilla2.php");
require_once("Semilla3.php");
require_once("Semilla4.php");
require_once("Semilla5.php");*/


/*
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes
 * $dks: Tipo de dks donde se har�n las consultas, $semilla: nivel de dificultad del dks
 * */
function conexion($dks, $semilla){
    /*
     * Se busca el DKS pasado por par�metro para conectarse a el y hacer la consulta correspondiente.
     * if else if es mas flexible, pero en este caso se utiliza una estructura switch ya que si el n�mero de 
     * condiciones es mayor a 3, switch es un poco mas r�pido porque solo calcula la condici�n una vez y luego
     * verifica la salida.
     */
    switch($dks){
        case 'DksBasico':
            //conexi�n a la BBDD
            $DksBasicoConexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion de DKSbasico");
            //Se rellenan los datos de la BBDD con la semilla correspondiente
            semilla($semilla);
            //consulta a la BBDD
            $DksBasicoConsulta = mysqli_query($DksBasicoConexion,"select * from conceptos_conceptos");
            /*
             * Array para devolver conexi�n y consulta, ya que necesitamos la conexi�n que hemos habierto para despu�s
             * cerrarla, y la consulta para desarrollar el algoritmo.
             */
            $salida = array($DksBasicoConexion, $DksBasicoConsulta);
            return $salida;
        case 'DksDesarrollo':
            //Conexi�n a las base de datos, dos_ es una BBDD de prueba
            $DksDesarrolloConexion=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dos_dksdesarrollo")or die("Error en la conexion de DksDesarrollo");
            semilla($semilla);
            $DksDesarrolloConsulta = mysqli_query($DksDesarrolloConexion,"select * from conceptos_conceptos");
            $salida = array($DksDesarrolloConexion, $DksDesarrolloConsulta);
            return $salida;
        case 'DksGeneric':
            $DksGenericConexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de GenericConexion");
            semilla($semilla);
            $DksGenericConsulta = mysqli_query($DksGenericConexion,"select * from conceptos_conceptos");
            $salida = array($DksGenericConexion, $DksGenericConsulta);
            return $salida;
        case 'DksKLW':
            $DksKlwConexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
            semilla($semilla);
            $DksKlwConsulta = mysqli_query($DksKlwConexion,"select * from conceptos_conceptos");
            $salida = array($DksKlwConexion, $DksKlwConsulta);
            return $salida;
        case 'DksLanguajes':
            $DksLanguajesConexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de LanguajesConexion");
            semilla($semilla);
            $DKSLanguajesConsulta = mysqli_query($DksLanguajesConexion,"select * from conceptos_conceptos");
            $salida = array($DksLanguajesConexion, $DKSLanguajesConsulta);
            return $salida;
        default:
            print "El DKS pasado por par�metro no existe";
            
    }
    
}


//Se rellenan los datos de la BBDD con la semilla correspondiente
function semilla($semilla){
    switch($semilla){
        case 1:
            //semilla1($semilla);
            return 0;
        case 2:
            //semilla2($semilla);
            return 0;
        case 3:
            //semilla3($semilla);
            return 0;
        case 4:
            //semilla4($semilla);
            return 0;
        case 5:
            //semilla5($semilla);
            return 0;
    }
}


// Cerrar la conexi�n ya habierta anteriormente y devuelta en la funci�n anterior
function CierreConexion($conexion){
    
    mysqli_close($conexion);
    return 0;
    
}



