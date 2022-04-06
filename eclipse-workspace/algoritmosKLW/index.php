<?php

require_once("Primero_profundidad.php");
require_once("Primero_anchura.php");



//ABRIR CONEXIÓN A BASE DE DATOS
//$conBBDD=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dos_dksbasico")or die("Error en la conexion");
$conBBDD=@mysqli_connect("localhost","usrDksDesarrollo","m5nd7Dt0Uf3c","dos_dksdesarrollo")or die("Error en la conexion");
$cadenasConNombreUsuario = mysqli_query($conBBDD,"select IdRel, IdRelPadre, ClaveHijo from conceptos_conceptos");




/*
$Id1 = 2;
$id2 = 4;

//FIFO, Pero por el orden en que se han insertado los datos actúa como profundidad, pensar..
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



//SEMILLAS PARA GENERAR CASOS DE BASES DE DATOS
//generación semilla 1
//generación semilla 2
//generación semilla 4
//...



//HACER BÚSQUEDA DE UN PAR DE NODOS CONCRETO SI TIENEN CORRELACIÓN!!!

//para comprobar si se repiten los nodos
$visitados = [];

//creamos Cola FIFO
/*$queue= new SplQueue();
//numérico dependiendo del IdRelPadre es por el que empieza a buscar, para encontrar su descendiente hasta que lo encuentra, y la inversa
primeroEnAnchura($cadenasConNombreUsuario, 361, 'gen_miki', $queue, $visitados);*/

//creamos Pila LIFO
$stack = new SplStack();
primeroEnProfundidad($cadenasConNombreUsuario, 361, 'gen_casa', $stack, $visitados);


//Cerrar conexión con base de datos
mysqli_close($conBBDD);


?>
