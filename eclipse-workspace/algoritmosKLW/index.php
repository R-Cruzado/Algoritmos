<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * index
*/


require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");
require_once("Llamada.php");



//Inicio de conexi�n a base de datos
//$conBBDD=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion");
$conBBDD=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dksdesarrollo")or die("Error en la conexion");
$cadenasConNombreUsuario = mysqli_query($conBBDD,"select IdRel, IdRelPadre, ClaveHijo, InsRef from conceptos_conceptos");



//SEMILLAS PARA GENERAR CASOS DE BASES DE DATOS
//generaci�n semilla 1
//generaci�n semilla 2
//generaci�n semilla 4
//...


/*
 * par�metros: primer par�metro (padre), segundo par�metro (descendiente), grafo de BBDD, y 
 * tipo de algoritmo (Primero_anchura o Primero_profundidad)  
 * //compuestode/componea
 * */
llamada('gen_miCasa', 'gen_ai_es_gen_ventana', $cadenasConNombreUsuario, 'Primero_anchura');


//Cerrar conexi�n con base de datos
mysqli_close($conBBDD);


?>
