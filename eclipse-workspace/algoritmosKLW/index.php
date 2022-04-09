<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * index
*/


require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");
require_once("Llamada.php");



//Inicio de conexión a base de datos
//$conBBDD=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion");
$conBBDD=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dksdesarrollo")or die("Error en la conexion");
$cadenasConNombreUsuario = mysqli_query($conBBDD,"select IdRel, IdRelPadre, ClaveHijo, InsRef from conceptos_conceptos");



//SEMILLAS PARA GENERAR CASOS DE BASES DE DATOS
//generación semilla 1
//generación semilla 2
//generación semilla 4
//...


/*
 * parámetros: primer parámetro (padre), segundo parámetro (descendiente), grafo de BBDD, y 
 * tipo de algoritmo (Primero_anchura o Primero_profundidad)  
 * //compuestode/componea
 * */
llamada('gen_miCasa', 'gen_ai_es_gen_ventana', $cadenasConNombreUsuario, 'Primero_anchura');


//Cerrar conexión con base de datos
mysqli_close($conBBDD);


?>
