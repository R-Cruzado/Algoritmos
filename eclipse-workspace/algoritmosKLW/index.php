<?php
$conBBDD=@mysqli_connect(localhost,root,nokiace6,dos_dksbasico)or die("Error en la conexion");
$cadenasConNombreUsuario = mysqli_query($conBBDD,"SELECT Clave FROM conceptos");
echo("hola");