<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * index
*/


require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");
require_once("Llamada.php");



//Inicio de conexi�n a base de datos, dos_ es una BBDD de prueba
//$conBBDD=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion");
$conBBDD=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dos_dksdesarrollo")or die("Error en la conexion");
$cadenasConNombreUsuario = mysqli_query($conBBDD,"select IdRel, IdRelPadre, ClaveHijo, InsRef from conceptos_conceptos");



//SEMILLAS PARA GENERAR CASOS DE BASES DE DATOS
//generaci�n semilla 1
//generaci�n semilla 2
//generaci�n semilla 4
//...


/*
 * par�metros: primer gen (padre), segundo gen (descendiente), grafo de BBDD, y 
 * tipo de algoritmo (Primero_anchura o Primero_profundidad)  
 * tipo de b�squeda (descendiente o ascendiente)
 * */
llamada('gen_casa', 'gen_miCasa', $cadenasConNombreUsuario, 'Primero_profundidad', 'ascendiente');


//Cerrar conexi�n con base de datos
mysqli_close($conBBDD);


?>
