<?php


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




function primeroEnProfundidad($grafo, $inicio, $visitado)
{
    //añadimos el nodo actual a la lista de visitados
    array_push($visitado, $inicio);
    
    //print $inicio. " ";
    
    //$id = mysqli_fetch_assoc($grafo)['IdRel'];
    
    //hay que resetear a 0 la búsqueda del grafo
    mysqli_data_seek($grafo,0);
    
    //Al buscarse el padre, hay que ir al revés, desde el hijo mas remoto buscando el padre y luego hacer un reverse
    //esto no busca nada, si cambias de orden los balores se va por perteneras, y no tiene que seguir un orden secuencial
    /*while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRel'] == $inicio){
            $padre = $row['IdRelPadre'];
            //igual no es necesario comprobar si mete repetidos, porque al generar la base de datos no permite generar id repetidos
            if (in_array($padre, $visitado)){
                print "hijoDe".$row['IdRelPadre']." ";
                //print "Ya_Visitado ";
                primeroEnProfundidad($grafo, $inicio +1, $visitado);
            }
            else{
                primeroEnProfundidad($grafo, $inicio +1, $visitado);
            }
        }
    }*/
    
    
    //primero en anchura
    while ($row = mysqli_fetch_assoc($grafo)){
        if ($row['IdRelPadre'] == $inicio){
            print $row['IdRel'] . " ";
        }
    }
    primeroEnProfundidad($grafo, $inicio +1, $visitado);
    
        
    return 0;
}

$visitado = [];
//el 0 no es ningún nodo, por lo tanto no se comprueba, tan solo es un indicador de que estamos en el nodo raíz
$visitado[0] = 0;

//inicializamos a 1 ya que es el primer nodo REVISAR PORQUE PUEDE EMPEZAR POR OTRO Y TERMINAR POR OTRO!!!
primeroEnProfundidad($cadenasConNombreUsuario, 0, $visitado);


    
mysqli_close($conBBDD);


?>
