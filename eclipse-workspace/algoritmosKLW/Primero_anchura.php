<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * Algoritmo de primero en anchura
 */

// Algoritmo de primero en anchura
function primeroEnAnchura($conexion, $fin, $queue, $visitados, $dks)
{
    // Bucle while o do while es mas eficiente que la recursividad en programaci�n imperativa, como lo es PHP
    do {
        
        //cerramos la conexion
        //mysqli_close($conexion);

        // Padre actual
        $inicio = $queue->dequeue();

        // Para mostrar camino
        print $inicio['IdRel'] . " ";

        // Para el algoritmo si encuentra el parentesco, muestra por pantalla que est�n relacionados, si no, no lo est�n.
        if ($inicio['ClaveHijo'] == $fin) {
            print "(Estan relacionados)";
            // Si est�n relacionados devuelve 1 como indicativo de que lo est�n
            return 1;
        }
        
        //Nos conectamos DKS actual si localidad es 1
        /*if ($inicio['Localidad']==1){
            switch($dks){
                case 'DksBasico':
                    $conexion=@mysqli_connect("localhost","usrDksBasico","mifg6ef3pj33","dksbasico")or die("Error en la conexion de DKSbasico");
                    break;
                case 'DksDesarrollo':
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
            }
            //Cogemos mediante una consulta a todos los hijos del padre actual
            $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
        }
        //Si no, hay que cambiar de DKS
        else{
            if($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic"){
                $conexion=@mysqli_connect("localhost","usrDksGeneric","lo93b5jd84h5","dksgeneric")or die("Error en la conexion de DKSbasico");
            }
            elseif($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw"){
                $conexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de DKSbasico");
            }
            elseif($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes"){
                $conexion=@mysqli_connect("localhost","usrDksLanguajes","kdhr7m4j6f2b","dkslanguajes")or die("Error en la conexion de DKSbasico");
            }
            $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
        }*/
        //SE HAN CERRADO LAS CONEXIONES AL FINAL DEL BUCLE Y EN EL IF DEL FINAL, 
        //HACERLO MEDIANTE OTRAS FUNCIONES EN CONEXION
        
        $hijos = mysqli_query($conexion, "SELECT * FROM conceptos_conceptos WHERE IdRelPadre = '" . $inicio['IdRel'] . "'");
        
        // Hay que resetear la posici�n de la selecci�n
        mysqli_data_seek($hijos, 0);

        // Cola FIFO. Los elementos se a�aden al final, y se van sacando por el primero
        // Los busca en los seleccionados en orden de forma iterativa hasta encontrar las coincidencias
        while ($row = mysqli_fetch_assoc($hijos)) {
            // Si el nodo no est� en visitados, se a�ade a visitados y se a�ade a la cola
            if (! in_array($row['ClaveHijo'], $visitados)) {
                array_push($visitados, $row['ClaveHijo']);
                $queue->enqueue($row);
            } /*
             * Si el nodo est� en visitados, pero es una Instancia o SinTecho, no se a�ade a visitados porque ya est�
             * en visitados, pero se a�ade a la cola, porque por su naturaleza expanden el �rbol mas all�.
             */
            elseif ($row['InsRef'] == 0 || $row['InsRef'] == 2) {
                $queue->enqueue($row);
            }
            /*
             * Si el nodo est� en visitados, y es una referencia, se considera un nodo repetido y no se tiene
             * en cuenta para la b�squeda, por por su naturaleza. b�squeda en grafos).
             */
            // }
        }

        // Si la cola acaba vac�a es que se ha terminado el algoritmo sin obtener la soluci�n
    } while (! $queue->isEmpty());
    
    //cerramos la conexi�n
    //mysqli_close($conexion);

    // devuelve 0 como indicativo de que no est�n correlacionados
    return 0;
}







