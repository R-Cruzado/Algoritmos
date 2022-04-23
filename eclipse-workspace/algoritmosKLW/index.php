<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * index
*/


require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");
require_once("Llamada.php");
require_once("Semilla1.php");



//Conexión a las base de datos, dos_ es una BBDD de prueba
$DksBasicoConexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion de DKSbasico");
$DksDesarrolloConexion=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dos_dksdesarrollo")or die("Error en la conexion de DksDesarrollo");
$DksGenericConexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de GenericConexion");
$DksKlwConexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
$DksLanguajesConexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de LanguajesConexion");

$DksBasico = mysqli_query($DksBasicoConexion,"select * from conceptos_conceptos");
$DksDesarrollo = mysqli_query($DksDesarrolloConexion,"select * from conceptos_conceptos");
$GenericConexion = mysqli_query($DksGenericConexion,"select * from conceptos_conceptos");
$KlwConexion = mysqli_query($DksKlwConexion,"select * from conceptos_conceptos");
$LanguajesConexion = mysqli_query($DksLanguajesConexion,"select * from conceptos_conceptos");


/* Semillas para generar los datos de la base de datos (grafo), el número de semilla es incremental
 * de forma proporcional a la complejidad
 * */
//generación semilla1
semilla1($DksDesarrollo);
//generación semilla2
//generación semilla3
//...


/*
 * parámetros: primer gen (padre), segundo gen (descendiente), grafo de BBDD,
 * ENVIAR POR PARÁMETRO EL DKS Y DESDE LLAMADA CONECTARSE A LA BBDD,
 * tipo de algoritmo (Primero_anchura o Primero_profundidad)  
 * ENVIAR TIPO DE SEMILLA POR PARÁMETRO Y DESDE LLAMADA SELECCIONARLA
 * */
llamada('gen_prueba_001', 'gen_casa', $DksDesarrollo, 'Primero_anchura');


//Cerrar conexión con base de datos DESDE LLAMADA, PARA CERRAR LA DEBIDA
mysqli_close($DksBasicoConexion);
mysqli_close($DksDesarrolloConexion);
mysqli_close($DksGenericConexion);
mysqli_close($DksKlwConexion);
mysqli_close($DksLanguajesConexion);


?>
