<?php

require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");



//ABRIR CONEXI�N A BASE DE DATOS
//$conBBDD=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion");
$conBBDD=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dos_dksdesarrollo")or die("Error en la conexion");
$cadenasConNombreUsuario = mysqli_query($conBBDD,"select IdRel, IdRelPadre, ClaveHijo from conceptos_conceptos");




/*
$Id1 = 2;
$id2 = 4;

//FIFO, Pero por el orden en que se han insertado los datos act�a como profundidad, pensar..
//Mostrar por pantalla $cadenasConNombreUsuario
while ($row = mysqli_fetch_assoc($cadenasConNombreUsuario))
{
    print $row['IdRel'];
    print $row['IdRelPadre'];
    print $row['ClaveHijo'];
    print "";
    if ($row['IdRelPadre'] == $Id1 && $row['IdRel'] == $id2){
        print "Estan ralacionados";
    }
}
*/


$visitado = [];
//el 0 no es ning�n nodo, tan solo es un indicador de que estamos en el nodo ra�z
$visitado[0] = 0;

//REVISAR PORQUE PUEDE EMPEZAR POR OTRO Y TERMINAR POR OTRO!!!
//primeroEnAnchura($cadenasConNombreUsuario, 0, $visitado);
primeroEnProfundidad($cadenasConNombreUsuario, 0, $visitado);


//CERRAR CONEXI�N CON BASE DE DATOS
mysqli_close($conBBDD);


?>
