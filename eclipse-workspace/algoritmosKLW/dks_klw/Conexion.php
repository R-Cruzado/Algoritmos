<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Conectar con la BBDD o DKS correspondiente, y hacer las consultas correspondientes
 * También hace la llamada a la semilla correspondiente
 */

require_once ("Semilla.php");


/*
 * Conectar con la BBDD correspondiente, y hacer las consultas correspondientes
 * $genes: Numero de genes (nodos) generados por cada base de datos de las 5 que hay (5 DKS),
 * $inicio: nombre del primer gen a buscar
 * $conexion: mandar de vuelta la conexión actual
 * */
function consulta($genes, $inicio, &$conexion){
    //Se realiza la conexión a la BBDD del dks actual
    $conexion=@mysqli_connect("localhost","usrDksKlw","cd4ji96hu9bd","dksklw")or die("Error en la conexion de KlwConexion");
    //Generamos la semila. Se rellenan de datos de las BBDD de los distintos DKS según el número de nodos pasado por parámetro
    //semilla($conexion,$genes);
    //consulta a la BBDD sobre el primer gen pasado por parámetro
    $consulta = mysqli_query($conexion,"SELECT * FROM conceptos_conceptos WHERE ClaveHijo = '".$inicio."'");
    //devolvemos la consulta
    return $consulta;
}

//Llamada a otro DKS
function conexionOtroDKS($inicio, $fin, $algoritmo, $genes, $profundidadActual){
    
    // Array Post que se enviará para la inicialización de la búsqueda del siguiente DKS teniendo en cuenta lo ya buscado
    $post_data = array(
        'gen1' => $inicio['ClaveHijo'],
        'gen2' => $fin,
        'algoritmo' => $algoritmo,
        'profundidadActual' => $genes,
        'genes' => $profundidadActual,
    );
    
    if ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Generic") {
        $Url = 'http://localhost/eclipse-workspace/algoritmosKLW/dks_Generic/';
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_klw") {
        $Url = 'http://localhost/eclipse-workspace/algoritmosKLW/dks_klw/';
    } elseif ($inicio['LocalizacionHijo'] == "http://localhost/klw/dks_Languajes") {
        $Url = 'http://localhost/eclipse-workspace/algoritmosKLW/dks_Languajes/';
    }
    
    print curl_download($Url, $post_data);
}


//Llamada curl a otro DKS
function curl_download($Url, $post_data){
    
    // Inicialización
    $ch = curl_init($Url);
    // Coge URL
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    // solicitud POST
    curl_setopt($ch, CURLOPT_POST, true);
    // Se envía el array post a solicitar
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
    $output = curl_exec($ch);
    
    // excepción
    if($output == FALSE){
        echo "cURL Error: ". curl_error($ch);
    }
    
    //cerrar y liberar curl resuelta
    curl_close($ch);
    
    // devolver salida de la web pasada por parámetro
    return $output;
}
