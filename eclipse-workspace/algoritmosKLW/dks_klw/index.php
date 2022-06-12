<html>
<title>DKS KLW</title>
<body>
<h1>DKS KLW</h1>

<?php

/*
 * @author : Roberto Cruzado Mart�nez
 * @a�o: 2022
 * P�gina principal
 */

require_once("Llamada.php");

//Comienzo de contador de tiempo de ejecuci�n
$iniciaTiempo = microtime(true);

//Mensaje a fichero Log com�n para todos los DKS donde se registra que se ha accedido a este DKS
$logFile = fopen("../log.txt", 'a') or die("Error al generar el archivo");
fwrite($logFile, "\n".date("d/m/Y H:i:s")." Acceso al DKS KLW") 
    or die("Error al escribir en el archivo");
fclose($logFile);

/*
 * Par�metros para funci�n llamada():
 * primer gen (padre)
 * segundo gen (descendiente)
 * Tipo de algoritmo (Primero_anchura o Primero_profundidad, Coste_uniforme)
 * Numero de genes (nodos) generados por cada base de datos de las 5 que hay (5 DKS)
 * Num�rico, profundidad de conexiones a distintos DKS a los que queremos limitar la b�squeda
 * */
//Si es una llamada desde Curl
if ($_POST){
    llamada($_POST[gen1], $_POST[gen2], $_POST[algoritmo], $_POST[genes], $_POST[profundidadActual]);
}//Si es una llamada desde el cliente
else{
    llamada('gen_prueba_001', 'gen_amigos', 'Primero_anchura', 100, 50);
}

//Fin de tiempo de ejecuci�n y mostrarlo por pantalla
$finalizaTiempo = microtime(true);
$tiempo = $finalizaTiempo - $iniciaTiempo;
$horas = (int)($tiempo/60/60);
$minutos = (int)($tiempo/60)-$horas*60;
$segundos = (int)$tiempo-$horas*60*60-$minutos*60;
echo " (Tiempo de ejecucion: " . $horas.':'.$minutos.':'.$segundos.")";

?>

</body>
</html>
