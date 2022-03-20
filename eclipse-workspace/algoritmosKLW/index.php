<?php


$conBBDD=@mysqli_connect("localhost","root","nokiace6","dos_dksbasico")or die("Error en la conexion");

$cadenasConNombreUsuario = mysqli_query($conBBDD,"select Clave from conceptos");
    
while ($row = mysqli_fetch_assoc($cadenasConNombreUsuario))
    print $row['Clave'];

mysqli_close($conBBDD);


?>
