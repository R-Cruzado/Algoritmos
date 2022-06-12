/*
SQLyog Community Edition- MySQL GUI v8.05 

Generacion de BBDD para un sistema DKS, que posteriormente almacenara cualquier tipo de información especifica
	Contiene las tablas basicas vacias, salvo los datos propios de cada DKS, esto es:
		- Usuario administrador local

Este fichero script de SQL para generar la base de datos de un DKS, debe poder generarse mediante de un programa generador
posiblemente en JAVA, a partir del KDL de la descripción del concepto de la base de datos

Esta base de datos la crea Miguel Angel Fdez. Graciani el 2011-03-11, para servir de almacen a los conceptos de KLW en un sistema DKS.

INSTRUCCIONES DE USO
1) Cambiar el nombre de la base de datos donde se vaya a instalar
2) Controlar que las direcciones de los DKS a los que hace referencia esten actualizadas
	Ver la definicion de las variables:
		 @localizacionGenericDKS 
		 @localizacion_DKS_KLW
		@localizacion_DKS_LANGUAJES 

		@locDKSLocal
		@locSelfService
3) Controlar
		SET @ordinalDeAlta_KLW = 0;  /* Indica el usuario por defecto para el alta de los conceptos en el proceso de instalacion es un concepto de generikDKS*
		SET @tiemoDeAlta_KLW = 0;  /* Indica la localizacion por defecto del usuario para el alta de los conceptos en el proceso de instalacion *
	Si en DKS_KLW se han modificado los tipos de datos, deben ponerse los valores correspondiente, vigilando que la naturaleza de los datos en este DKS este adecuada a dichas modificaciones
	Si no se han modificado los valors en DKS_KLW, todo seguira igual
4) Hacer correr el script
5) Gestinoar los usuarios de acceso a la BBDD

Observaciones:
	1) No puede funcionar sobre DKSs anteriores, esta hecha de la forma que deberia ser desde el principio, pero no tiene desarrollado DKS ni KEE (2011-03-11)
	2) ELimino las sentencias "TYPE=MyISAM;" que habia al final de la generacion de cada tabla, porque es esta version es el motor por defecto y la sentencia esta obsoleta

*/

/* Consideraciones de tipos de caracteres, etc... Hay que repasarlas
	// Debe admitir cualquier tipo de caracter de cualquier nación
	Existe una descripcion mas amplia en el documento :  D:\miki\Trabajo\La genesis del Conocimiento\KLW\KLW mecanismos de consenso v03.docx
*/

/*   Pendientes:

-  en
	(225,"gen_st_imagenConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Prefijo.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	Hay que diseñar e incluir -- "imagen_Prefijo.jpg"

-  en
	(231,"gen_st_imagenConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Contenido.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
	Hay que diseñar e incluir -- imagen_Contenido.jpg



*/

/* esto que sigue no se para que sirve */
/*SET NAMES utf8;*/
/*!40101 SET SQL_MODE=''*/;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/* la base de datos tiene que estar dada de alta */
CREATE DATABASE IF NOT EXISTS dksgeneric CHARSET = utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `dksgeneric`;  /* Aqui se identifica la base de datos  */

/*  ******* Definimos algunas variables para utilizarlas a lo largo del script **************************  */

/*  otros DKS a los que se hace referencia  */
SET @localizacion_DKS_KLW = "http://localhost/klw/dks_klw"; /* Para el DKS  de KLW  */
SET @localizacion_DKS_LANGUAJES = "http://localhost/klw/dks_Languajes"; /* Para el DKS de idiomas  */

/* ***********
SET @localizacion_DKS_KLW = "http://www.ideando.net/klw/dks_klw";
SET @localizacion_DKS_LANGUAJES = "http://www.ideando.net/klw/dks_Languajes";
*/

SET @locDKSLocal = "http://localhost/klw/dks_Generic";  /* Para el DKS local (el que se esta instalando). La localizacion @locSelfService  debe ser la url de instalacion del servicio.  */ 
/*	SET @locDKSLocal = "http://www.ideando.net/klw/dks_Generic"; */ 
SET @localizacionGenericDKS = @locDKSLocal; /* Para DKS geberico  */
SET @locSelfService = @locDKSLocal;   /* este no se para que sirve  */

SET @locDKSLocal_ai_es = "http://localhost/klw/dks_Generic/lan_es";  
SET @locDKSLocal_ai_ing = "http://localhost/klw/dks_Generic/lan_ing";

/* Usuarios para el alta inicial  */
SET @claveUsuario = "gen_usr_genesis";  /* Indica el usuario por defecto para el alta de los conceptos en el proceso de instalacion es un concepto de generikDKS*/
SET @localizacionUsuario = @locDKSLocal;  /* Indica la localizacion por defecto del usuario para el alta de los conceptos en el proceso de instalacion */

/* Datos por defecto para el alta de los datos del DKS  lOCAL */
SET @ordinalDeAlta = 0;  /* Indica el ordinal por defecto para el alta inicial de datos de este DKS*/
SET @tiemoDeAlta = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS*/
	/* existen datos cruzados, por lo que es necesario indicar los datos por defecto de alta de otros DKS.
		Estos deben modificarse cuando se den de alta los DKS pertinentes, y modificarse si estos se modifican, modificando la naturaleza de los datos segun corresponda en el DKS BASICO para futuras altas de DKSs */

SET @ordinalDeAlta_KLW = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_KLW*/
SET @tiemoDeAlta_KLW = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_KLW*/

SET @ordinalDeAlta_GENERICO = @ordinalDeAlta;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_GENERICO*/
SET @tiemoDeAlta_GENERICO = @tiemoDeAlta;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_GENERICO*/

SET @ordinalDeAlta_LANGUAJES = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_GENERICO*/
SET @tiemoDeAlta_LANGUAJES = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_GENERICO*/

/*  Permisos de acceso */
SET @accesoPorDefecto = 0;  /* Indica el usuario por defecto para el alta de los conceptos en el proceso de instalacion */

/*    1.
*************************************************
*******	ESTRUCTURA BASICA DE TABLAS  DE CONCEPTO
		que se repeetira varias veces, esta estructura contiene todo lo necesario para almacenar vertices (conceptos)
		En DKS no existen mas estructuras que esta y la de caminos Que se expondrá mas adelante
*************************************************    
*************************************************    
*************************************************    
*************************************************    */

/*   1.1
*************************************************
*******  TABLAS DE VERTICES (CONCEPTO) *******************
*************************************************    */

/*   1.1.1
*************************************************
*******  TABLAS FUNDAMENTALES DE VERTICE (CONCEPTO) *******************
*************************************************    */

/*  
*********************  INICIO Tablas de conceptos  ************************************** */
/* Creamos la tabla principal de conceptos. Almacena  la tabla de declaracion de los conceptos  */
DROP TABLE IF EXISTS `conceptos`;

CREATE TABLE `conceptos` (
  `IdConcepto` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,
  /* El resto son campos de apoyo a la operativa del sistema */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`IdConcepto`),
  KEY `Clave` (`Clave`)
);

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values				/*  Concepto de nombre (reside en generickDKS) ***********  */
			(4,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de descripcion (reside en generickDKS) ***********  */
			(5,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de rotulo (reside en generickDKS) ***********  */
			(6,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto  usuario  (reside en generickDKS)  ***********  */
			(10,"gen_usuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto nombre de usuario  (reside en generickDKS)  ***********  */
			(11,"gen_nombreUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto pasword de usuario  (reside en generickDKS)  ***********  */
			(12,"gen_paswordUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto Identificador (reside en generickDKS)  ***********   Se usa para identificar cualquier entidad de forma independiente a la codificacion KDL,  etc...  *** */
			(32,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto entrada input (reside en generickDKS)  ***********   Se usa para identificar las entradas a un sistema, una funcion de codigo, una linea de produccion,  etc...  *** */
			(33,"gen_input",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto salida output (reside en generickDKS)  ***********   Se usa para identificar las salidas de un sistema, una funcion de codigo, una linea de produccion,  etc...  *** */
			(34,"gen_output",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto cl<se o tipo (reside en generickDKS)  ***********   Se usa para clasificar un concepto, segun los tipos que puede contener, por ejemplo, tipos de error, tipos de solicitud, tipos de respuesta, etc...  *** */
			(35,"gen_clase",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto error (reside en generickDKS)  ***********  */
			(39,"gen_error",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto accionConsecuente (reside en generickDKS)  ***********  */
			(42,"gen_accionConsecuente",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto nivelde gravedad ( (reside en generickDKS)  ***********  */
			(43,"gen_nivelDeGravedad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto localizacion ( (reside en generickDKS)  ***********  */
			(44,"gen_localizacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto agente ((agente es el que hace algo)  ***********  */
			(45,"gen_agente",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto anexos ((informacion relacionada, pero no en la ayuda a interfaz, como codigos, datos de error, u otros)  ***********  */
			(46,"gen_anexos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto icono ((una imagen con tamaño de icono, para ser visualizada y utilizada como tal)  ***********  */
			(47,"gen_icono",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto imagen ***********  */
			(48,"gen_imagen",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto archivo ***********  */
			(49,"gen_archivo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto audio ***********  */
			(50,"gen_audio",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto lista ***********  */
			(51,"gen_lista",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto datacion tiempo concreto asociado a algo ***********  */
			(52,"gen_datacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto identidad ***********  */
			(53,"gen_identidad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de historial medico ***********  */
			(54,"gen_historialMedico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto curriculum ***********  */
			(55,"gen_curriculum",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto persona fisica ***********  */
			(56,"gen_personaFisica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto lista ordenada ***********  */
			(57,"gen_ordinado",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto ordinal ***********  */
			(58,"gen_ordinal",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto numero ***********  */
			(59,"gen_numero",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto prefijo ***********  */
			(60,"gen_prefijo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto contiene ***********  */
			(61,"gen_contiene",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   61, debes utilizar uno posterior para el siguiente registro **********  */			

/*  ******  Me falta definir el usuario administrador  *********  */			

/* Creamos la tabla principal de conceptos_conceptos. Almacena la descripcion del arbol definicion de cada concepto*/
DROP TABLE IF EXISTS `conceptos_conceptos`;

CREATE TABLE `conceptos_conceptos` (
  `IdRel` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de relacion de concepto_concepto */
  `IdRelPadre` bigint(255) unsigned NOT NULL, /* Es el padre en el arbol de descripcion. Si es cero, la entrada es la raiz de una descripcion */
  `ClaveHijo` varchar(255) NOT NULL, /* Clave del hijo. (En caso de que  corresponda a un sinTecho o tabla local, aqui se almacena el Idcst de la tabla correspondiente.*/  
  `LocalizacionHijo` varchar(255) NOT NULL, /* Localizacion del hijo. (En caso de que  corresponda a una tabla local, aqui se almacena el nombre de la tabla. LO SABEMOS PORQUE LA LOCALIZACION NO TENDRA PUNTOS */  
  `OrdinalHijo` int(255) unsigned NOT NULL,
  `TiempoActualizacionHijo` double NOT NULL,
  `Localidad` int(2) NOT NULL default '1', /* Externo = 0, Interno = 1. Indica si el concepto reside en el DKS o en uno externo */
  `Familia` varchar(255), /* Indica la familia de datos a la que corresponde el concepto en el DKS Local. No tiene sentido en conceptos externos.*/  
  `IdEnTabla` bigint(255), /*  Indica el identificador dentro de la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos.*/  
  /*  No se si sera necesario un indicador de instancia-referencia, en principio no lo es */
  `InsRef` int(1) NOT NULL, /*   1 = Referencia ,  0 = Instancia  2=SinTecho*/
  PRIMARY KEY (`IdRel`)
);

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values 	
	/* Relaciones del concepto gen_usuario  ***********  */
			(21,0,"gen_usuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",10,0),
				(22,21,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(23,22,"gen_ai_es_gen_usuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,1),
					(205,22,"gen_ai_ing_gen_usuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",4,1),
				(24,21,"gen_nombreUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",11,1),
				(25,21,"gen_paswordUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",12,1),
	
	/* Relaciones del concepto gen_nombreUsuario  ***********  */
			(26,0,"gen_nombreUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",11,0),
				(27,26,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(28,27,"gen_ai_es_gen_nombreUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,1),
					(206,27,"gen_ai_ing_gen_nombreUsuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",5,1),

	/* Relaciones del concepto gen_paswordUsuario  ***********  */
			(29,0,"gen_paswordUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",12,0),
				(30,29,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(31,30,"gen_ai_es_gen_paswordUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,1),
					(207,30,"gen_ai_ing_gen_paswordUsuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",6,1),

	/* Relaciones del concepto gen_nombre  ***********  */
			(35,0,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
				(36,35,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(37,36,"gen_ai_es_gen_nombre",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,1),
					(208,36,"gen_ai_ing_gen_nombre",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",11,1),

	/* Relaciones del concepto gen_descripcion  ***********  */
			(38,0,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
				(39,38,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(40,39,"gen_ai_es_gen_descripcion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,1),
					(209,39,"gen_ai_ing_gen_descripcion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",12,1),

	/* Relaciones del concepto gen_rotulo  ***********  */
			(41,0,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
				(42,41,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(43,42,"gen_ai_es_gen_rotulo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,1),
					(210,42,"gen_ai_ing_gen_rotulo",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",13,1),

	/* Relaciones del concepto gen_Identificador  ***********  */
			(95,0,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,0),
				(96,95,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(97,96,"gen_ai_es_gen_Identificador",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",31,1),
					(211,96,"gen_ai_ing_gen_Identificador",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",31,1),

	/* Relaciones del concepto gen_input  ***********  */
			(98,0,"gen_input",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",33,0),
				(99,98,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(100,99,"gen_ai_es_gen_input",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",32,1),
					(212,99,"gen_ai_ing_gen_input",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",32,1),

	/* Relaciones del concepto gen_output  ***********  */
			(101,0,"gen_output",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",34,0),
				(102,101,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(103,102,"gen_ai_es_gen_output",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",33,1),
					(213,102,"gen_ai_ing_gen_output",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",33,1),

	/* Relaciones del concepto gen_clase  ***********  */
			(104,0,"gen_clase",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",35,0),
				(105,104,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(106,105,"gen_ai_es_gen_clase",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",34,1),
					(214,105,"gen_ai_ing_gen_clase",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",34,1),

	/* Relaciones del concepto gen_error  ***********  */
			(129,0,"gen_error",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",39,0),
				(130,129,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(131,130,"gen_ai_es_gen_error",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",38,1),
					(215,130,"gen_ai_ing_gen_error",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",38,1),
			(132,129,"gen_clase",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",35,1),
			(133,129,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,1),
			(146,129,"gen_accionConsecuente",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",42,1),
			(147,129,"gen_nivelDeGravedad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",43,1),
			(148,129,"gen_localizacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,1),
			(149,129,"gen_agente",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",45,1),
			(150,129,"gen_anexos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",46,1),

	/* Relaciones del concepto gen_accionConsecuente  ***********  */
			(142,0,"gen_accionConsecuente",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",42,0),
				(143,142,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(144,143,"gen_ai_es_gen_accionConsecuente",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",41,1),
					(216,143,"gen_ai_ing_gen_accionConsecuente",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",41,1),
			(145,142,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,1),

	/* Relaciones del concepto gen_nivelDeGravedad  ***********  */
			(151,0,"gen_nivelDeGravedad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",43,0),
				(152,151,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(153,152,"gen_ai_es_gen_nivelDeGravedad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,1),
					(217,152,"gen_ai_ing_gen_nivelDeGravedad",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",42,1),

	/* Relaciones del concepto gen_localizacion  ***********  */
			(154,0,"gen_localizacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,0),
				(155,154,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(156,155,"gen_ai_es_gen_localizacion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",43,1),
					(218,155,"gen_ai_ing_gen_localizacion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",43,1),

	/* Relaciones del concepto gen_agente  ***********  */
			(157,0,"gen_agente",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",45,0),
				(158,157,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(159,158,"gen_ai_es_gen_agente",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",44,1),
					(219,158,"gen_ai_ing_gen_agente",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",44,1),

	/* Relaciones del concepto gen_anexos  ***********  */
			(160,0,"gen_anexos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",46,0),
				(161,160,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(162,161,"gen_ai_es_gen_anexos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",45,1),
					(220,161,"gen_ai_ing_gen_anexos",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",45,1),

	/* Relaciones del concepto gen_icono  ***********  */
			(163,0,"gen_icono",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",47,0),
				(164,163,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(165,164,"gen_ai_es_gen_icono",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",46,1),
					(221,164,"gen_ai_ing_gen_icono",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",46,1),
			(166,163,"gen_imagen",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",48,1),

	/* Relaciones del concepto gen_imagen  ***********  */
			(167,0,"gen_imagen",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",48,0),
				(168,167,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(169,168,"gen_ai_es_gen_imagen",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",47,1),
					(222,168,"gen_ai_ing_gen_imagen",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",47,1),
			(170,167,"gen_clase",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",35,1),
			(171,167,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,1),
			(172,167,"gen_localizacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,1),

	/* Relaciones del concepto gen_archivo  ***********  */
			(173,0,"gen_archivo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",49,0),
				(174,173,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(175,174,"gen_ai_es_gen_archivo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",48,1),
					(223,174,"gen_ai_ing_gen_archivo",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",48,1),
			(176,173,"gen_clase",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",35,1),
			(177,173,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,1),
			(178,173,"gen_localizacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,1),

	/* Relaciones del concepto gen_imagen  ***********  */
			(179,0,"gen_audio",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",50,0),
				(180,179,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(181,180,"gen_ai_es_gen_audio",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",49,1),
					(224,180,"gen_ai_ing_gen_audio",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",49,1),
				(182,179,"gen_clase",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",35,1),
				(183,179,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,1),
				(184,179,"gen_localizacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,1),
			
	/* Relaciones del concepto gen_lista  ***********  */
			(185,0,"gen_lista",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",51,0),
				(186,185,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(187,186,"gen_ai_es_gen_lista",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",50,1),
					(225,186,"gen_ai_ing_gen_lista",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",50,1),

	/* Relaciones del concepto gen_datacion  ***********  */
			(188,0,"gen_datacion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",52,0),
				(189,188,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(190,189,"gen_ai_es_gen_datacion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",51,1),
					(226,189,"gen_ai_ing_gen_datacion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",51,1),

	/* Relaciones del concepto gen_identidad  ***********  */
			(191,0,"gen_identidad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",53,0),
				(192,191,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(193,192,"gen_ai_es_gen_identidad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",52,1),
					(227,192,"gen_ai_ing_gen_identidad",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",52,1),

	/* Relaciones del concepto gen_historialMedico  ***********  */
			(194,0,"gen_historialMedico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",54,0),
				(195,194,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(196,195,"gen_ai_es_gen_historialMedico",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",53,1),
					(228,195,"gen_ai_ing_gen_historialMedico",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",53,1),

	/* Relaciones del concepto gen_curriculum  ***********  */
			(197,0,"gen_curriculum",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",55,0),
				(198,197,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(199,198,"gen_ai_es_gen_curriculum",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",54,1),
					(229,198,"gen_ai_ing_gen_curriculum",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",54,1),

	/* Relaciones del concepto gen_personaFisica  ***********  */
			(200,0,"gen_personaFisica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",56,0),
				(201,200,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(202,201,"gen_ai_es_gen_personaFisica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,1),
					(230,201,"gen_ai_ing_gen_personaFisica",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",55,1),
				(203,200,"gen_Identificador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",32,1),
				(204,200,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",35,1),

	/* Relaciones del concepto gen_ordinado  ***********  */
			(231,0,"gen_ordinado",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",57,0),
				(232,231,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(233,232,"gen_ai_es_gen_ordinado",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",56,1),
				(234,231,"gen_lista",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",51,0),

	/* Relaciones del concepto gen_ordinal  ***********  */
			(235,0,"gen_ordinal",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",58,0),
				(236,235,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(237,236,"gen_ai_es_gen_ordinal",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",57,1),

	/* Relaciones del concepto gen_numero  ***********  */
			(238,0,"gen_numero",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",59,0),
				(239,238,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(240,239,"gen_ai_es_gen_numero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",58,1),

	/* Relaciones del concepto gen_prefijo  ***********  */
			(241,0,"gen_prefijo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",60,0),
				(242,241,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(243,242,"gen_ai_es_gen_prefijo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",59,1),

	/* Relaciones del concepto gen_contiene  ***********  */
			(244,0,"gen_contiene",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",61,0),
				(245,244,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(246,245,"gen_ai_es_gen_contiene",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",60,1);

/*  ******  Me falta definir el usuario administrador  *********  */			

/*    Ultimo identificador utilizado para esta tabla de arriba   246, debes utilizar uno posterior para el siguiente registro **********  */			

			
/* Creamos la tabla principal de conceptos_sin_techo. Almacena el dato de los conceptos que no tienen descripcion (numeros enteros, nombres, etc...)*/
DROP TABLE IF EXISTS `conceptos_sin_techo`;

CREATE TABLE `conceptos_sin_techo` (
  `Idcst` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de concepto sinTecho */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,  /*  En esta tabla el localizador será la misma tabla y famoila, ya que por narices son locales */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `Contenido` varchar(255), /* Ojo, en principio debe poder meterse cualquier cosa, un dato, la localizacion de un fichero. u otros */  
  /* El tipo de los datos de un sinTecho, puede cualificarse asociandolo a un concepto, en el que encontraremos informacion de como tratarlo, mostrarlo, etc... */
  `ClaveTipo` varchar(255) NOT NULL, /* Clave del Tipo del sinTecho*/  
  `LocalizacionTipo` varchar(255) NOT NULL, /* Localizacion del Tipo del sinTecho*/  
  `OrdinalTipo` int(255) unsigned NOT NULL,
  `TiempoActualizacionTipo` double NOT NULL,
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`Idcst`)
);

/*  Conceptos basicos para este DKS especifico ***********  *
insert  into `conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`) 
	values	(1,"gen_st_concepto0","conceptos_sin_techo",0,0,"Contenido concepto sin techo 0","gen_tipoDeSinTechoTextoPlano",@localizacionGenericDKS,0,0);
************  */
insert  into `conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			/* datos sin techo, vacios para que puedan ser referidos por quien los necesite */
			(0,"gen_st_vacio_para_textoPlano","conceptos_sin_techo",0,0,"","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1,"gen_st_vacio_para_NumeroEntero","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_st_vacio_para_Url","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_Url",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_vacio_para_FicheroGenerico","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroGenerico",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(4,"gen_st_vacio_para_FicheroAudio","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_vacio_para_FicheroImagen","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_vacio_para_FicheroVideo","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroVideo",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
					/* Para ficheros ejecutables que no tienen nada que ver con la interfaz de KEE */
			(7,"gen_st_vacio_para_FicheroEjecutableExterno","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroEjecutableExterno",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
					/* Para ficheros que conoce la interfaz a priori y que pueden ejecutarse como funciones preexistentes en KEE */
						/* Para botones en general sin definicion especifica asociados a funciones conocidas por KEE */
			(8,"gen_st_vacio_para_LlamadaFuncionKEE","conceptos_sin_techo",0,0,"funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","gen_tipoDeSinTecho_LlamadaFuncionKEE",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
						/* Para que funcione como boton de busqueda en busqueda por Key y host "gen_BuscadorKee_por_key_host" en KEE */
			(9,"gen_st_para_LlamadaFuncionKEE_funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","conceptos_sin_techo",0,0,"funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","gen_tipoDeSinTecho_LlamadaFuncionKEE",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

			
/*  *********************  FIN Tablas de conceptos  ************************************** */


/*   1.1.2
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (CONCEPTO_famILIAS_DE_DATOS) *******************
*************************************************    */

/*  *********************  INICIO Tablas de CONCEPTOS_famILIAS  ************************************** */
/* *** Esta familia instancia conceptos "gen_familiaDeDatosKlw" del DKS KLW **** */
/* Creamos la tabla principal de familias. Indica las familias (conjuntos de tablas de concepto especificas) que se separan para obtimizar en eficiencia *
CREATE TABLE `CONCEPTOS_famILIAS` (
/* Conceptos de familias esta tabla contiene los conjuntos de tablas especificas del DKS */
/*insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (1,`conceptosfamilias`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`);

/*  *********************  INICIO Tablas de fam_conceptos  ************************************** */
/* Creamos la tabla principal de fam_conceptos. Almacena  la tabla de declaracion de los conceptos*/
DROP TABLE IF EXISTS `fam_conceptos`;

CREATE TABLE `fam_conceptos` (
  `IdConcepto` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,
  /* El resto son campos de apoyo a la operativa del sistema */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`IdConcepto`),
  KEY `Clave` (`Clave`)
); 

/*  Conceptos de ayuda a interfaz  en español ***********  *
insert  into `fam_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	  ****************  */

/*  Conceptos para DKS BASICO ***********  */
insert  into `fam_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			(1,"gen_Familia_Conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(4,"gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

	/*    Ultimo identificador utilizado para esta tabla de arriba   4, debes utilizar uno posterior para el siguiente registro **********  */			
			
	/* Creamos la tabla principal de fam_conceptos_conceptos. Almacena la descripcion del arbol definicion de cada concepto*/
DROP TABLE IF EXISTS `fam_conceptos_conceptos`;

CREATE TABLE `fam_conceptos_conceptos` (
  `IdRel` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de relacion de concepto_concepto */
  `IdRelPadre` bigint(255) unsigned NOT NULL, /* Es el padre en el arbol de descripcion. Si es cero, la entrada es la raiz de una descripcion */
  `ClaveHijo` varchar(255) NOT NULL, /* Clave del hijo. (En caso de que  corresponda a un sinTecho o tabla local, aqui se almacena el Idcst de la tabla correspondiente.*/  
  `LocalizacionHijo` varchar(255) NOT NULL, /* Localizacion del hijo. (En caso de que  corresponda a una tabla local, aqui se almacena el nombre de la tabla. LO SABEMOS PORQUE LA LOCALIZACION NO TENDRA PUNTOS */  
  `OrdinalHijo` int(255) unsigned NOT NULL,
  `TiempoActualizacionHijo` double NOT NULL,
  `Localidad` int(2) NOT NULL default '1', /* Externo = 0, Interno = 1. Indica si el concepto reside en el DKS o en uno externo */
  `Familia` varchar(255), /* Indica la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos. Si es externo contiene ""*/  
  `IdEnTabla` bigint(255), /*  Indica el identificador dentro de la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos SI es externo contien  0.*/  
  /*  No se si sera necesario un indicador de instancia-referencia, en principio no lo es */
  `InsRef` int(1) NOT NULL, /*   1 = Referencia ,  0 = Instancia  2=SinTecho*/
  PRIMARY KEY (`IdRel`)
); 

/*  Conceptos de ayuda a interfaz  en español ***********  *
insert  into `fam_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values  ****************  */

/*  Conceptos  para DKS BASICO ***********  */
insert  into `fam_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	
	/* Relaciones de ayuda interfaz del concepto gen_Familia_Conceptos  ***********  */
			(1,0,"gen_Familia_Conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",1,0),
				(2,1,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(3,2,"gen_ai_es_gen_Familia_Conceptos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1,1),
				(4,1,"gen_familiaDeDatosKlw_conceptos",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",61,0),
					(5,4,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(6,5,"gen_st_gen_Familia_Conceptos_prefijo","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",1,2),
					(7,4,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(8,7,"gen_concepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",16,1),
				(36,1,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(37,36,"gen_st_gen_Familia_conceptos_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",5,2),

	/* Relaciones de ayuda interfaz del concepto gen_Familia_Familias_fam  ***********  */
			(9,0,"gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",2,0),
				(10,9,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(11,10,"gen_ai_es_gen_Familia_Familias_fam",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,1),
				(12,9,"gen_familiaDeDatosKlw_familias",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",62,0),
					(13,4,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(14,13,"gen_st_gen_Familia_Familias_fam","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",2,2),
					(15,4,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(16,15,"gen_familiaDeDatosKlw",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",60,1),
				(38,9,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(39,38,"gen_st_gen_Familia_Familias_fam_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",7,2),
					
	/* Relaciones de ayuda interfaz del concepto gen_Familia_Usuarios_usr  ***********  */
			(17,0,"gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",3,0),
				(18,17,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(19,18,"gen_ai_es_gen_Familia_Usuarios_usr",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,1),
				(20,17,"gen_familiaDeDatosKlw_usuarios",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",63,0),
					(21,20,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(22,13,"gen_st_gen_Familia_Usuarios_usr","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",3,2),
					(23,20,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(24,15,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,1),
				(40,17,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(41,40,"gen_st_gen_Familia_Usuarios_usr_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",8,2),

	/* Relaciones de ayuda interfaz del concepto gen_Familia_AyudaIntEsp_ai_es  ***********  */
			(25,0,"gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",4,0),
				(26,25,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(27,26,"gen_ai_es_gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,1),
				(28,25,"gen_familiaDeDatosKlw_ai_es",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",64,0),
					(29,28,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(30,29,"gen_st_gen_Familia_AyudaIntEsp_ai_es","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",4,2),
					(31,28,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(32,31,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
							(33,32,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
						(34,31,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",0,0),
							(35,34,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",0,1),
				(42,25,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(43,42,"gen_st_gen_Familia_AyudaIntEsp_ai_es_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",9,2),

	/* Relaciones de ayuda interfaz del concepto gen_Familia_AyudaIntIng_ai_ing  ***********  */
			(44,0,"gen_Familia_AyudaIntIng_ai_ing",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",4,0),
				(45,44,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(46,45,"gen_ai_es_gen_Familia_AyudaIntIng_ai_ing",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,1),
				(47,44,"gen_familiaDeDatosKlw_ai_ing",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",65,0),
					(48,47,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(49,48,"gen_st_gen_Familia_AyudaIntIng_ai_ing","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",6,2),
					(50,47,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(51,50,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
							(52,51,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
						(53,50,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",0,0),
							(54,53,"gen_idioma_ingles",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",0,1),
				(55,44,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(56,55,"gen_st_gen_Familia_AyudaIntIng_ai_ing_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",10,2);

		/*    Ultimo identificador utilizado para esta tabla de arriba   6, debes utilizar uno posterior para el siguiente registro **********  */			
			
	/* Creamos la tabla principal de conceptos_sin_techo. Almacena el dato de los conceptos que no tienen descripcion (numeros enteros, nombres, etc...)*/
DROP TABLE IF EXISTS `fam_conceptos_sin_techo`;

CREATE TABLE `fam_conceptos_sin_techo` (
  `Idcst` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de concepto sinTecho */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,  /*  En esta tabla el localizador será la misma tabla y famoila, ya que por narices son locales */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `Contenido` varchar(255), /* Ojo, en principio debe poder meterse cualquier cosa, un dato, la localizacion de un fichero. u otros */  
  /* El tipo de los datos de un sinTecho, puede cualificarse asociandolo a un concepto, en el que encontraremos informacion de como tratarlo, mostrarlo, etc... */
  `ClaveTipo` varchar(255) NOT NULL, /* Clave del Tipo del sinTecho*/  
  `LocalizacionTipo` varchar(255) NOT NULL, /* Localizacion del Tipo del sinTecho*/  
  `OrdinalTipo` int(255) unsigned NOT NULL,
  `TiempoActualizacionTipo` double NOT NULL,
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`Idcst`)
); 

/*  Conceptos datos (sin techo) de ayuda a interfaz en español ***********  *
insert  into `fam_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	  ********** Datos de  gen_fam_ayudaInterfazEsp */
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `fam_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			/*  datos de los prefijos de familia */
			(1,"gen_st_gen_Familia_Conceptos_prefijo","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_st_gen_Familia_Familias_fam","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"fam_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_gen_Familia_Usuarios_usr","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"usr_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(4,"gen_st_gen_Familia_AyudaIntEsp_ai_es","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ai_es_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_gen_Familia_AyudaIntIng_ai_ing","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ai_ing_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(5,"gen_st_gen_Familia_conceptos_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,0,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(7,"gen_st_gen_Familia_Familias_fam_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,100,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(8,"gen_st_gen_Familia_Usuarios_usr_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,200,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(9,"gen_st_gen_Familia_AyudaIntEsp_ai_es_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,100000,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(10,"gen_st_gen_Familia_AyudaIntIng_ai_ing_ordinal","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,100100,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
	/*    Ultimo identificador utilizado para esta tabla de arriba   6, debes utilizar uno posterior para el siguiente registro **********  */			
	
	/*  *********************  FIN Tablas de CONCEPTOS_famILIAS  ************************************** */


/*   1.1.3
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (usr_conceptos) *******************
*************************************************    */

/*  *********************  INICIO Tablas de usr_conceptos  ************************************** */
/* Conceptos de usuarios del DKS contiene conceptos de usuarios de este DKS */
/* Hay que hacer, en la tabla de familias, el --insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`);

/* Creamos la tabla principal de AI_CONCEPTOS. Almacena  la tabla de declaracion de los conceptos*/
DROP TABLE IF EXISTS `usr_conceptos`;

CREATE TABLE `usr_conceptos` (
  `IdConcepto` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,
  /* El resto son campos de apoyo a la operativa del sistema */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`IdConcepto`),
  KEY `Clave` (`Clave`)
);

	/*  Conceptos usuario administtrador generico, se define en DKS generico, para despues instanciarlo en cada implantacion concreta de la aplicación */
insert  into `usr_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/*  Definimos un tipo de usuario administrador al arracar la BBDD, para que especificarlo despues, generando un administrador que lo instancie en cada implantacion  */
			(1,"gen_usuarioAdministrador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*  Conceptos  para DKS BASICO ***********  */
	/*  Conceptos usuario para la implantacion concreta de la aplicación. Este usuario instancia el concepto de administrador de sistema */
insert  into `usr_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/*  Generamos un usuario administrador al arracar la BBDD, para que aparezca un usuario al dar de alta el sistema  */
			(1000,"gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
			/* Creamos la tabla principal de conceptos_conceptos. Almacena la descripcion del arbol definicion de cada concepto*/
DROP TABLE IF EXISTS `usr_conceptos_conceptos`;

CREATE TABLE `usr_conceptos_conceptos` (
  `IdRel` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de relacion de concepto_concepto */
  `IdRelPadre` bigint(255) unsigned NOT NULL, /* Es el padre en el arbol de descripcion. Si es cero, la entrada es la raiz de una descripcion */
  `ClaveHijo` varchar(255) NOT NULL, /* Clave del hijo. (En caso de que  corresponda a un sinTecho o tabla local, aqui se almacena el Idcst de la tabla correspondiente.*/  
  `LocalizacionHijo` varchar(255) NOT NULL, /* Localizacion del hijo. (En caso de que  corresponda a una tabla local, aqui se almacena el nombre de la tabla. LO SABEMOS PORQUE LA LOCALIZACION NO TENDRA PUNTOS */  
  `OrdinalHijo` int(255) unsigned NOT NULL,
  `TiempoActualizacionHijo` double NOT NULL,
  `Localidad` int(2) NOT NULL default '1', /* Externo = 0, Interno = 1. Indica si el concepto reside en el DKS o en uno externo */
  `Familia` varchar(255), /* Indica la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos.*/  
  `IdEnTabla` bigint(255), /*  Indica el identificador dentro de la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos.*/  
  /*  No se si sera necesario un indicador de instancia-referencia, en principio no lo es */
  `InsRef` int(1) NOT NULL, /*   1 = Referencia ,  0 = Instancia  2=SinTecho*/
  PRIMARY KEY (`IdRel`)
);


/*  Conceptos basicos para DKS Local ***********  */
insert  into `usr_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	/* DEscripcion del usuario Administrador (creado por defecto) */
			(1,0,"gen_usuarioAdministrador",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1,0),
				(2,1,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(3,2,"gen_ai_es_gen_usuarioAdministrador",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,1),
				(4,1,"gen_usuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",0,0);


/*  Introducimos las relaciones de los Conceptos de usuario ***********  */
/*  Conceptos  para DKS BASICO ***********  */
insert  into `usr_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	/* DEscripcion del usuario Administrador (creado por defecto) */
			(1000,0,"gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1000,0),
				(1001,1000,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(1002,1001,"gen_ai_es_gen_usuarioAdministradorLocal1",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"ai_es_",7,1),
				(1004,1000,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(1003,1004,"gen_usuarioAdministrador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"usr_",1,0),
					(1005,1004,"gen_nombreUsuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
						(1006,1005,"gen_st_gen_nombreUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1000,2),
					(1007,1004,"gen_paswordUsuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
						(1008,1007,"gen_st_gen_paswordUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1001,2),
					(1009,1004,"gen_interfazKee",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",47,0),
						(1010,1009,"gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1001,1),

			/* Relaciones del concepto de  interfaz del usuairo  "gen_usuarioAdministradorLocal1  ********  */
			(1011,0,"gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1001,0),
				(1012,1011,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(1013,1012,"gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1001,1),
				(1014,1011,"gen_configuracionDeAcceso",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",43,0),
					(1015,1014,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",59,0),
						(1016,1015,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
							(1017,1016,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
								(1018,1017,"gen_st_gen_ordinal_48","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",1002,2),
							(1019,1016,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",3,1),
						(1020,1015,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
							(1021,1020,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
								(1022,1021,"gen_st_gen_ordinal_52","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",1003,2),
							(1023,1020,"gen_idioma_ingles",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",4,1),
				(1024,1011,"gen_interfazKee",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",47,0),
					(1025,1024,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
						(1026,1025,"gen_listaEntornos",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",48,0),
							(1027,1026,"gen_entornoDeTrabajoKee",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",48,0),
								(1028,1027,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
									(1029,1028,"gen_st_gen_identificadorEntornoUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1004,2),
								(1030,1027,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
									(1031,1030,"gen_listaRequerimientosKEE",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",50,0),
								(1032,1027,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
									(1033,1032,"gen_ListaConceptosPresentes",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",52,0),
					(1034,1024,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,0),
						(1035,1034,"gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1000,1);
						
						
						
	/* Creamos la tabla principal de conceptos_sin_techo. Almacena el dato de los conceptos que no tienen descripcion (numeros enteros, nombres, etc...)*/
DROP TABLE IF EXISTS `usr_conceptos_sin_techo`;

CREATE TABLE `usr_conceptos_sin_techo` (
  `Idcst` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de concepto sinTecho */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,  /*  En esta tabla el localizador será la misma tabla y famoila, ya que por narices son locales */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `Contenido` varchar(255), /* Ojo, en principio debe poder meterse cualquier cosa, un dato, la localizacion de un fichero. u otros */  
  /* El tipo de los datos de un sinTecho, puede cualificarse asociandolo a un concepto, en el que encontraremos informacion de como tratarlo, mostrarlo, etc... */
  `ClaveTipo` varchar(255) NOT NULL, /* Clave del Tipo del sinTecho*/  
  `LocalizacionTipo` varchar(255) NOT NULL, /* Localizacion del Tipo del sinTecho*/  
  `OrdinalTipo` int(255) unsigned NOT NULL,
  `TiempoActualizacionTipo` double NOT NULL,
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`Idcst`)
);

/*  Conceptos datos (sin techo) de la familia de datos de usuarios ***********  */

/*  Conceptos basicos para DKS generico ***********  */

/*  Conceptos para DKS BASICO ***********  */
insert  into `usr_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos sin techo de   gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_gen_nombreUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"administrador","gen_nombreUsuario",@localizacionGenericDKS,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_gen_paswordUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"1admin1","gen_paswordUsuario",@localizacionGenericDKS,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_gen_ordinal_48","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"1","gen_numero",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1003,"gen_st_gen_ordinal_52","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"2","gen_numero",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1004,"gen_st_gen_identificadorEntornoUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Id de ent UsuarioAdministradorLocal1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*  *********************  FIN Tablas de usr_conceptos  ************************************** */

/*   1.1.4
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (RESTRICCIONES_ACCESO) *******************
*************************************************    */

/*  *********************  INICIO Tablas de RESTRICCIONES_ACCESO  ************************************** */
/* Conceptos de familia restriccion de acceso conceptos de privacidad de conceptos */
/*insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`);
/*  *********************  FIN Tablas de RESTRICCIONES_ACCESO  ************************************** */

/*   1.1.5
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (ACTUALIZACIONES) *******************
*************************************************    */

/*  *********************  INICIO Tablas de ACTUALIZACIONES  ************************************** */
/* Conceptos de familia conceptos preteritos contiene las versiones anteriores de los conceptos y los cambios necesarios para regenerar versiones antiguas */
/*insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`);
/*  *********************  FIN Tablas de MODIFICACIONES  ************************************** */

/*   1.1.6
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (CACHE_DE_EXTERNOS) *******************
*************************************************    */

/*  *********************  INICIO Tablas de CACHE_DE_EXTERNOS  ************************************** */
/* Conceptos de familia conceptos cache de externos contiene copia de los conceptos externos */
/*insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`);
	/*
	Los conceptos aqui almacenados no deben ser modificados, ya que son copia del original que se encuentra en la fuente del concepto
	Solo deben ser de uso privado, para DKS privados, Servidor personal , de empresa u otros
	Deben poder ir marcados como copia autorizada y con un identificador que garantiza su derecho de uso y modelo de divulgacion
	*/
/*  *********************  FIN Tablas de CACHE_DE_EXTERNOS  ************************************** */

/*  ************************************************************************************************************************************ */
/*  ************************************************************************************************************************************ */
/*  ************************************************************************************************************************************ */
/*  **************************   INICIO TABLAS DE IDIOMAS PARA AYUDA A INTERFAZ  (una por cada idioma) ********************************* */
/*  ************************************************************************************************************************************ */
/*  ************************************************************************************************************************************ */
/*  ************************************************************************************************************************************ */
	
/*   1.1.100
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (ai_es_conceptos) *******************
*************************************************    */

/*  *********************  INICIO Tablas de ai_es_conceptos  ************************************** */
/* Creamos la tabla principal de ai_es_conceptos. Almacena  la tabla de declaracion de los conceptos*/
DROP TABLE IF EXISTS `ai_es_conceptos`;

CREATE TABLE `ai_es_conceptos` (
  `IdConcepto` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,
  /* El resto son campos de apoyo a la operativa del sistema */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`IdConcepto`),
  KEY `Clave` (`Clave`)
);

/*  Conceptos de ayuda a interfaz  en español ***********  */
insert  into `ai_es_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			(4,"gen_ai_es_gen_usuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_ai_es_gen_nombreUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_ai_es_gen_paswordUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(7,"gen_ai_es_gen_usuarioAdministrador",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_ai_es_gen_nombre",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_ai_es_gen_descripcion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(13,"gen_ai_es_gen_rotulo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(31,"gen_ai_es_gen_Identificador",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_ai_es_gen_input",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_ai_es_gen_output",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(34,"gen_ai_es_gen_clase",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(38,"gen_ai_es_gen_error",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(41,"gen_ai_es_gen_accionConsecuente",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(42,"gen_ai_es_gen_nivelDeGravedad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(43,"gen_ai_es_gen_localizacion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(44,"gen_ai_es_gen_agente",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(45,"gen_ai_es_gen_anexos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(46,"gen_ai_es_gen_icono",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(47,"gen_ai_es_gen_imagen",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(48,"gen_ai_es_gen_archivo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(49,"gen_ai_es_gen_audio",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(50,"gen_ai_es_gen_lista",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(51,"gen_ai_es_gen_datacion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(52,"gen_ai_es_gen_identidad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(53,"gen_ai_es_gen_historialMedico",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(54,"gen_ai_es_gen_curriculum",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(55,"gen_ai_es_gen_personaFisica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(56,"gen_ai_es_gen_ordinado",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(57,"gen_ai_es_gen_ordinal",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(58,"gen_ai_es_gen_numero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(59,"gen_ai_es_gen_prefijo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(60,"gen_ai_es_gen_contiene",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
/*    Ultimo identificador utilizado para esta tabla de arriba   60, debes utilizar uno posterior para el siguiente registro **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			(1000,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
	/* Creamos la tabla principal de ai_es_conceptos_conceptos. Almacena la descripcion del arbol definicion de cada concepto*/
DROP TABLE IF EXISTS `ai_es_conceptos_conceptos`;

CREATE TABLE `ai_es_conceptos_conceptos` (
  `IdRel` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de relacion de concepto_concepto */
  `IdRelPadre` bigint(255) unsigned NOT NULL, /* Es el padre en el arbol de descripcion. Si es cero, la entrada es la raiz de una descripcion */
  `ClaveHijo` varchar(255) NOT NULL, /* Clave del hijo. (En caso de que  corresponda a un sinTecho o tabla local, aqui se almacena el Idcst de la tabla correspondiente.*/  
  `LocalizacionHijo` varchar(255) NOT NULL, /* Localizacion del hijo. (En caso de que  corresponda a una tabla local, aqui se almacena el nombre de la tabla. LO SABEMOS PORQUE LA LOCALIZACION NO TENDRA PUNTOS */  
  `OrdinalHijo` int(255) unsigned NOT NULL,
  `TiempoActualizacionHijo` double NOT NULL,
  `Localidad` int(2) NOT NULL default '1', /* Externo = 0, Interno = 1. Indica si el concepto reside en el DKS o en uno externo */
  `Familia` varchar(255), /* Indica la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos. Si es externo contiene ""*/  
  `IdEnTabla` bigint(255), /*  Indica el identificador dentro de la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos SI es externo contien  0.*/  
  /*  No se si sera necesario un indicador de instancia-referencia, en principio no lo es */
  `InsRef` int(1) NOT NULL, /*   1 = Referencia ,  0 = Instancia  2=SinTecho*/
  PRIMARY KEY (`IdRel`)
);

/*  Conceptos de ayuda a interfaz  en español ***********  *
insert  into `ai_es_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values  ****************  */

/*  Conceptos  para DKS BASICO ***********  */
insert  into `ai_es_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	
		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_usuario  ***********  */
			(29,0,"gen_ai_es_gen_usuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,0),
		/* nombre */
			(30,29,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(31,30,"gen_st_nombreConceptoUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,2),
		/* descripcion */
			(32,29,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(33,32,"gen_st_descripcionConceptoUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,2),
		/* rotulo */
			(34,29,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(35,34,"gen_st_rotuloConceptoUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,2),
			
			(406,29,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(407,406,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_nombreUsuario  ***********  */
			(36,0,"gen_ai_es_gen_nombreUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,0),
		/* nombre */
			(37,36,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(38,37,"gen_st_nombreNombreUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,2),
		/* descripcion */
			(39,36,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(40,39,"gen_st_descripcionNombreUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,2),
		/* rotulo */
			(41,36,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(42,41,"gen_st_rotuloNombreUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,2),
			
			(408,36,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(409,408,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_paswordUsuario  ***********  */
			(43,0,"gen_ai_es_gen_paswordUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,0),
		/* nombre */
			(44,43,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(45,44,"gen_st_nombrepaswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,2),
		/* descripcion */
			(46,43,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(47,46,"gen_st_descripcionpaswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,2),
		/* rotulo */
			(48,43,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(49,48,"gen_st_rotulopaswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(362,43,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(363,362,"gen_st_iconoImagenConcepto_gen_paswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",157,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(364,43,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(365,364,"gen_st_iconoAudioConcepto_gen_paswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",158,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(366,43,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(367,366,"gen_st_imagenConcepto_gen_paswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",159,2),
			
			(410,43,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(411,410,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_usuarioAdministrador  ***********  */
			(50,0,"gen_ai_es_gen_usuarioAdministrador",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,0),
		/* nombre */
			(51,50,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(52,51,"gen_st_nombreUsuarioAdministrador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,2),
		/* descripcion */
			(53,50,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(54,53,"gen_st_descripcionUsuarioAdministrador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,2),
		/* rotulo */
			(55,50,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(56,55,"gen_st_rotuloUsuarioAdministrador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",21,2),
			
			(412,50,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(413,412,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_nombre  ***********  */
			(71,0,"gen_ai_es_gen_nombre",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,0),
		/* nombre */
			(72,71,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(73,72,"gen_st_nombreNombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",31,2),
		/* descripcion */
			(74,71,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(75,74,"gen_st_descripcionNombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",32,2),
		/* rotulo */
			(76,71,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(77,76,"gen_st_rotuloNombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",33,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(344,71,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(345,344,"gen_st_iconoImagenConcepto_gen_nombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",148,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(346,71,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(347,346,"gen_st_iconoAudioConcepto_gen_nombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",149,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(348,71,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(349,348,"gen_st_imagenConcepto_gen_nombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",150,2),
			
			(414,71,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(415,415,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_descripcion  ***********  */
			(78,0,"gen_ai_es_gen_descripcion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,0),
		/* nombre */
			(79,78,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(80,79,"gen_st_nombreDescripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",34,2),
		/* descripcion */
			(81,78,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(82,81,"gen_st_descripcionDescripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",35,2),
		/* rotulo */
			(83,78,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(84,83,"gen_st_rotuloDescripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",36,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(350,78,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(351,350,"gen_st_iconoImagenConcepto_gen_descripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",151,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(352,78,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(353,352,"gen_st_iconoAudioConcepto_gen_descripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",152,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(354,78,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(355,354,"gen_st_imagenConcepto_gen_descripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",153,2),
			
			(416,78,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(417,416,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_rotulo  ***********  */
			(85,0,"gen_ai_es_gen_rotulo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,0),
		/* nombre */
			(86,85,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(87,86,"gen_st_nombreRotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",37,2),
		/* descripcion */
			(88,85,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(89,88,"gen_st_descripcionRotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",38,2),
		/* rotulo */
			(90,85,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(91,90,"gen_st_rotuloRotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",39,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(356,85,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(357,356,"gen_st_iconoImagenConcepto_gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",154,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(358,85,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(359,358,"gen_st_iconoAudioConcepto_gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",155,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(360,85,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(361,360,"gen_st_imagenConcepto_gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",156,2),
			
			(418,85,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(419,418,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Identificador  ***********  */
			(211,0,"gen_ai_es_gen_Identificador",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",31,0),
		/* nombre */
			(212,211,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(213,212,"gen_st_nombreIdentificador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",91,2),
		/* descripcion */
			(214,211,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(215,214,"gen_st_descripcionIdentificador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",92,2),
		/* rotulo */
			(216,211,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(217,216,"gen_st_rotuloIdentificador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",93,2),
			
			(420,211,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(421,420,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_input  ***********  */
			(218,0,"gen_ai_es_gen_input",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",32,0),
		/* nombre */
			(219,218,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(220,219,"gen_st_nombreinput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",94,2),
		/* descripcion */
			(221,218,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(222,221,"gen_st_descripcioninput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",95,2),
		/* rotulo */
			(223,218,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(224,223,"gen_st_rotuloinput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",96,2),
			
			(422,218,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(423,422,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_output  ***********  */
			(225,0,"gen_ai_es_gen_output",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",33,0),
		/* nombre */
			(226,225,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(227,226,"gen_st_nombreoutput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",97,2),
		/* descripcion */
			(228,225,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(229,228,"gen_st_descripcionoutput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",98,2),
		/* rotulo */
			(230,225,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(231,230,"gen_st_rotulooutput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",99,2),
			
			(424,225,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(425,424,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_clase  ***********  */
			(232,0,"gen_ai_es_gen_clase",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",34,0),
		/* nombre */
			(233,232,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(234,233,"gen_st_nombreclase","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",100,2),
		/* descripcion */
			(235,232,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(236,235,"gen_st_descripcionclase","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",101,2),
		/* rotulo */
			(237,232,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(238,237,"gen_st_rotuloclase","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",102,2),
			
			(426,232,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(427,426,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_error  ***********  */
			(260,0,"gen_ai_es_gen_error",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",38,0),
			/* nombre */
				(261,260,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(262,261,"gen_st_nombreerror","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",112,2),
			/* descripcion */
				(263,260,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(264,263,"gen_st_descripcionerror","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",113,2),
			/* rotulo */
				(265,260,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(266,265,"gen_st_rotuloerror","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",114,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(400,260,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(401,400,"gen_st_iconoImagenConcepto_gen_error","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",175,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(402,260,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(403,402,"gen_st_iconoAudioConcepto_gen_error","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",176,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(404,260,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(405,404,"gen_st_imagenConcepto_gen_error","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",177,2),
			
			(428,260,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(429,428,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_accionConsecuente  ***********  */
			(281,0,"gen_ai_es_gen_accionConsecuente",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",41,0),
		/* nombre */
			(282,281,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(283,282,"gen_st_nombreaccionConsecuente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",121,2),
		/* descripcion */
			(284,281,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(285,284,"gen_st_descripcionaccionConsecuente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",122,2),
		/* rotulo */
			(286,281,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(287,286,"gen_st_rotuloaccionConsecuente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",123,2),
			
			(430,281,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(431,430,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_nivelDeGravedad  ***********  */
			(288,0,"gen_ai_es_gen_nivelDeGravedad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,0),
		/* nombre */
			(289,288,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(290,289,"gen_st_nombre_gen_nivelDeGravedad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",124,2),
		/* descripcion */
			(291,288,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(292,291,"gen_st_descripcion_gen_nivelDeGravedad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",125,2),
		/* rotulo */
			(293,288,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(294,293,"gen_st_rotulo_gen_nivelDeGravedad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",126,2),
			
			(432,288,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(433,432,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_localizacion  ***********  */
			(295,0,"gen_ai_es_gen_localizacion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",43,0),
		/* nombre */
			(296,295,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(297,296,"gen_st_nombre_gen_localizacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",127,2),
		/* descripcion */
			(298,295,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(299,298,"gen_st_descripcion_gen_localizacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",128,2),
		/* rotulo */
			(300,295,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(301,300,"gen_st_rotulo_gen_localizacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",129,2),
			
			(434,295,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(435,434,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_agente  ***********  */
			(302,0,"gen_ai_es_gen_agente",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",44,0),
		/* nombre */
			(303,302,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(304,303,"gen_st_nombre_gen_agente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",130,2),
		/* descripcion */
			(305,302,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(306,305,"gen_st_descripcion_gen_agente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",131,2),
		/* rotulo */
			(307,302,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(308,307,"gen_st_rotulo_gen_agente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",132,2),
			
			(436,302,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(437,436,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_anexos  ***********  */
			(309,0,"gen_ai_es_gen_anexos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",45,0),
		/* nombre */
			(310,309,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(311,310,"gen_st_nombre_gen_anexos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",133,2),
		/* descripcion */
			(312,309,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(313,312,"gen_st_descripcion_gen_anexos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",134,2),
		/* rotulo */
			(314,309,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(315,314,"gen_st_rotulo_gen_anexos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",135,2),
			
			(438,309,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(439,438,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_icono  ***********  */
			(316,0,"gen_ai_es_gen_icono",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",46,0),
		/* nombre */
			(317,316,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(318,317,"gen_st_nombre_gen_icono","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",136,2),
		/* descripcion */
			(319,316,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(320,319,"gen_st_descripcion_gen_icono","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",137,2),
		/* rotulo */
			(321,316,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(322,321,"gen_st_rotulo_gen_icono","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",138,2),
			
			(440,316,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(441,440,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_imagen  ***********  */
			(323,0,"gen_ai_es_gen_imagen",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",47,0),
		/* nombre */
			(324,323,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(325,324,"gen_st_nombre_gen_imagen","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",139,2),
		/* descripcion */
			(326,323,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(327,326,"gen_st_descripcion_gen_imagen","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",140,2),
		/* rotulo */
			(328,323,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(329,328,"gen_st_rotulo_gen_imagen","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",141,2),
			
			(442,323,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(443,442,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_archivo  ***********  */
			(330,0,"gen_ai_es_gen_archivo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",48,0),
		/* nombre */
			(331,330,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(332,331,"gen_st_nombre_gen_archivo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",142,2),
		/* descripcion */
			(333,330,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(334,333,"gen_st_descripcion_gen_archivo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",143,2),
		/* rotulo */
			(335,330,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(336,335,"gen_st_rotulo_gen_archivo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",144,2),
			
			(444,330,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(445,444,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_audio  ***********  */
			(337,0,"gen_ai_es_gen_audio",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",49,0),
		/* nombre */
			(338,337,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(339,338,"gen_st_nombre_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",145,2),
		/* descripcion */
			(340,337,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(341,340,"gen_st_descripcion_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",146,2),
		/* rotulo */
			(342,337,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(343,342,"gen_st_rotulo_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",147,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(368,337,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(369,368,"gen_st_iconoImagenConcepto_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",160,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(370,337,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(371,370,"gen_st_iconoAudioConcepto_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",161,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(372,337,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(373,372,"gen_st_imagenConcepto_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",162,2),
			
			(446,337,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(447,446,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_lista  ***********  */
			(374,0,"gen_ai_es_gen_lista",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",50,0),
		/* nombre */
			(375,374,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(376,375,"gen_st_nombre_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",163,2),
		/* descripcion */
			(377,374,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(378,377,"gen_st_descripcion_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",164,2),
		/* rotulo */
			(379,374,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(380,379,"gen_st_rotulo_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",165,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(381,374,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(382,381,"gen_st_iconoImagenConcepto_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",166,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(383,374,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(384,383,"gen_st_iconoAudioConcepto_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",167,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(385,374,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(386,385,"gen_st_imagenConcepto_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",168,2),
			
			(448,374,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(449,448,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_datacion  ***********  */
			(387,0,"gen_ai_es_gen_datacion",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",51,0),
		/* nombre */
			(388,387,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(389,388,"gen_st_nombre_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",169,2),
		/* descripcion */
			(390,387,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(391,390,"gen_st_descripcion_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",170,2),
		/* rotulo */
			(392,387,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(393,392,"gen_st_rotulo_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",171,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(394,387,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(395,394,"gen_st_iconoImagenConcepto_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",172,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(396,387,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(397,396,"gen_st_iconoAudioConcepto_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",173,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(398,387,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(399,398,"gen_st_imagenConcepto_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",174,2),
			
			(450,387,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(451,450,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_identidad  ***********  */
			(452,0,"gen_ai_es_gen_identidad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",52,0),
		/* Ayuda a interfaz */
				(453,452,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(454,453,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(455,452,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(456,455,"gen_st_nombre_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",178,2),
		/* descripcion */
				(457,452,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(458,457,"gen_st_descripcion_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",179,2),
		/* rotulo */
				(459,452,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(460,459,"gen_st_rotulo_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",180,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(461,452,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(462,461,"gen_st_iconoImagenConcepto_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",181,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(463,452,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(464,463,"gen_st_iconoAudioConcepto_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",182,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(465,452,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(466,465,"gen_st_imagenConcepto_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",183,2),
			
	/* Relaciones de ayuda interfaz del concepto gen_historialMedico  ***********  */
			(467,0,"gen_ai_es_gen_historialMedico",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",53,0),
		/* Ayuda a interfaz */
				(468,467,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(469,468,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(470,467,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(471,470,"gen_st_nombre_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",184,2),
		/* descripcion */
				(472,467,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(473,472,"gen_st_descripcion_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",185,2),
		/* rotulo */
				(474,467,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(475,474,"gen_st_rotulo_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",186,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(476,467,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(477,476,"gen_st_iconoImagenConcepto_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",187,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(478,467,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(479,478,"gen_st_iconoAudioConcepto_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",188,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(480,467,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(481,480,"gen_st_imagenConcepto_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",189,2),
			
	/* Relaciones de ayuda interfaz del concepto gen_curriculum  ***********  */
			(482,0,"gen_ai_es_gen_curriculum",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",54,0),
		/* Ayuda a interfaz */
				(483,482,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(484,483,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(485,482,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(486,485,"gen_st_nombre_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",190,2),
		/* descripcion */
				(487,482,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(488,487,"gen_st_descripcion_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",191,2),
		/* rotulo */
				(489,482,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(490,489,"gen_st_rotulo_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",192,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(491,482,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(492,491,"gen_st_iconoImagenConcepto_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",193,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(493,482,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(494,493,"gen_st_iconoAudioConcepto_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",194,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(495,482,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(496,495,"gen_st_imagenConcepto_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",195,2),
			
	/* Relaciones de ayuda interfaz del concepto gen_personaFisica  ***********  */
			(497,0,"gen_ai_es_gen_personaFisica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,0),
		/* Ayuda a interfaz */
				(498,497,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(499,498,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(500,497,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(501,500,"gen_st_nombre_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",196,2),
		/* descripcion */
				(502,497,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(503,502,"gen_st_descripcion_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",197,2),
		/* rotulo */
				(504,497,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(505,504,"gen_st_rotulo_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",198,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(506,497,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(507,506,"gen_st_iconoImagenConcepto_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",199,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(508,497,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(509,508,"gen_st_iconoAudioConcepto_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",200,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(510,497,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(511,510,"gen_st_imagenConcepto_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",201,2),
					
	/* Relaciones de ayuda interfaz del concepto gen_ordinado  ***********  */
			(512,0,"gen_ai_es_gen_ordinado",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",56,0),
		/* Ayuda a interfaz */
				(513,512,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(514,513,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(515,512,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(516,515,"gen_st_nombre_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",202,2),
		/* descripcion */
				(517,512,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(518,517,"gen_st_descripcion_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",203,2),
		/* rotulo */
				(519,512,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(520,519,"gen_st_rotulo_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",204,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(521,512,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(522,521,"gen_st_iconoImagenConcepto_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",205,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(523,512,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(524,523,"gen_st_iconoAudioConcepto_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",206,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(525,512,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(526,525,"gen_st_imagenConcepto_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",207,2),

	/* Relaciones de ayuda interfaz del concepto gen_ordinal  ***********  */
			(527,0,"gen_ai_es_gen_ordinal",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",57,0),
		/* Ayuda a interfaz */
				(528,527,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(529,528,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(530,527,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(531,530,"gen_st_nombre_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",208,2),
		/* descripcion */
				(532,527,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(533,532,"gen_st_descripcion_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",209,2),
		/* rotulo */
				(534,527,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(535,534,"gen_st_rotulo_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",210,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(536,527,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(537,536,"gen_st_iconoImagenConcepto_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",211,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(538,527,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(539,538,"gen_st_iconoAudioConcepto_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",212,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(540,527,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(541,540,"gen_st_imagenConcepto_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",213,2),

	/* Relaciones de ayuda interfaz del concepto gen_numero  ***********  */
			(542,0,"gen_ai_es_gen_numero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",58,0),
		/* Ayuda a interfaz */
				(543,542,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(544,543,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(545,542,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(546,545,"gen_st_nombre_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",214,2),
		/* descripcion */
				(547,542,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(548,547,"gen_st_descripcion_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",215,2),
		/* rotulo */
				(549,542,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(550,549,"gen_st_rotulo_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",216,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(551,542,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(552,551,"gen_st_iconoImagenConcepto_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",217,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(553,542,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(554,553,"gen_st_iconoAudioConcepto_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",218,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(555,542,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(556,555,"gen_st_imagenConcepto_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",219,2),

	/* Relaciones de ayuda interfaz del concepto gen_prefijo  ***********  */
			(557,0,"gen_ai_es_gen_prefijo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",59,0),
		/* Ayuda a interfaz */
				(558,557,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(559,558,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(560,557,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(561,560,"gen_st_nombre_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",220,2),
		/* descripcion */
				(562,557,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(563,562,"gen_st_descripcion_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",221,2),
		/* rotulo */
				(564,557,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(565,564,"gen_st_rotulo_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",222,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(566,557,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(567,566,"gen_st_iconoImagenConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",223,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(568,557,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(570,569,"gen_st_iconoAudioConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",224,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(571,557,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(572,571,"gen_st_imagenConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",225,2),

	/* Relaciones de ayuda interfaz del concepto gen_contiene  ***********  */
			(573,0,"gen_ai_es_gen_contiene",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",60,0),
		/* Ayuda a interfaz */
				(574,573,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(575,574,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
				(576,573,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(577,576,"gen_st_nombre_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",226,2),
		/* descripcion */
				(578,573,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(579,578,"gen_st_descripcion_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",227,2),
		/* rotulo */
				(580,573,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(581,580,"gen_st_rotulo_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",228,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(582,573,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(583,582,"gen_st_iconoImagenConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",229,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(584,573,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(586,585,"gen_st_iconoAudioConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",230,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(587,573,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(588,587,"gen_st_imagenConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",231,2),

/*    Ultimo identificador utilizado para esta tabla de arriba   588, debes utilizar uno posterior para el siguiente registro  ojo, a partir de 1000 el ultimo es 1006 **********  */			

/* Relaciones de ayuda interfaz del concepto gen_usuarioAdministradorLocal1  ***********  */
			(1000,0,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,0),
		/* nombre */
			(1001,1000,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
			(1002,1001,"gen_st_nombreusuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,2),
		/* descripcion */
			(1003,1000,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
			(1004,1003,"gen_st_descripcionusuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1001,2),
		/* rotulo */
			(1005,1000,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
			(1006,1005,"gen_st_rotulousuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1002,2);
			
	/* Creamos la tabla principal de conceptos_sin_techo. Almacena el dato de los conceptos que no tienen descripcion (numeros enteros, nombres, etc...)*/
DROP TABLE IF EXISTS `ai_es_conceptos_sin_techo`;

CREATE TABLE `ai_es_conceptos_sin_techo` (
  `Idcst` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de concepto sinTecho */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,  /*  En esta tabla el localizador será la misma tabla y famoila, ya que por narices son locales */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `Contenido` varchar(255), /* Ojo, en principio debe poder meterse cualquier cosa, un dato, la localizacion de un fichero. u otros */  
  /* El tipo de los datos de un sinTecho, puede cualificarse asociandolo a un concepto, en el que encontraremos informacion de como tratarlo, mostrarlo, etc... */
  `ClaveTipo` varchar(255) NOT NULL, /* Clave del Tipo del sinTecho*/  
  `LocalizacionTipo` varchar(255) NOT NULL, /* Localizacion del Tipo del sinTecho*/  
  `OrdinalTipo` int(255) unsigned NOT NULL,
  `TiempoActualizacionTipo` double NOT NULL,
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`Idcst`)
);

/*  Conceptos datos (sin techo) de ayuda a interfaz en español ***********  */
insert  into `ai_es_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			/* datos de   gen_ai_es_gen_usuario */
			(10,"gen_st_nombreConceptoUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Concepto Usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_st_descripcionConceptoUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el concepto usuario como entidad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_st_rotuloConceptoUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usuario (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_usuario nombre*/
			(13,"gen_st_nombreNombreUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nombre de Usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(14,"gen_st_descripcionNombreUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el nombre que se asigna al usuario como usuario del sistema","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(15,"gen_st_rotuloNombreUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nombre usuario (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_usuario  pasword*/
			(16,"gen_st_nombrepaswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Pasword de Usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_st_descripcionpaswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el pasword del usuario en el sistema","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(18,"gen_st_rotulopaswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Pasword (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(157,"gen_st_iconoImagenConcepto_gen_paswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPassword.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(158,"gen_st_iconoAudioConcepto_gen_paswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPassword.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(159,"gen_st_imagenConcepto_gen_paswordUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_password.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_usuarioAdministrador */
			(19,"gen_st_nombreUsuarioAdministrador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usuario Administrador (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(20,"gen_st_descripcionUsuarioAdministrador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el usuario que se genera en la instalacion, como administrador del sistema","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(21,"gen_st_rotuloUsuarioAdministrador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usuario administrador (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_nombre */
			(31,"gen_st_nombreNombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nombre (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_st_descripcionNombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Almacena el nombre que se le da a este concepto en este idioma","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_st_rotuloNombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nombre (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(148,"gen_st_iconoImagenConcepto_gen_nombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgNombre.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(149,"gen_st_iconoAudioConcepto_gen_nombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioNombre.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(150,"gen_st_imagenConcepto_gen_nombre","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_nombre.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_descripcion */
			(34,"gen_st_nombreDescripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Descripcion (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(35,"gen_st_descripcionDescripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ALmacena la descripcion que se le da a este concepto en este idioma","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(36,"gen_st_rotuloDescripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Descripcion (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(151,"gen_st_iconoImagenConcepto_gen_descripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgDescripcion.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(152,"gen_st_iconoAudioConcepto_gen_descripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioDescripcion.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(153,"gen_st_imagenConcepto_gen_descripcion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_descripcion.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_rotulo */
			(37,"gen_st_nombreRotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Rotulo (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(38,"gen_st_descripcionRotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ALmacena el rotulo que se asocia a este concepto en este idioma","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(39,"gen_st_rotuloRotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Rotulo (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(154,"gen_st_iconoImagenConcepto_gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgRotulo.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(155,"gen_st_iconoAudioConcepto_gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioRotulo.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(156,"gen_st_imagenConcepto_gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_rotulo.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_Identificador*/
			(91,"gen_st_nombreIdentificador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identificador","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(92,"gen_st_descripcionIdentificador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es un elemento que sirve para identificar una entidad. Puede ser un codigo, un sistema de codificacion u otros","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(93,"gen_st_rotuloIdentificador","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identificador","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_Identificador*/
			(94,"gen_st_nombreinput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Entrada","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(95,"gen_st_descripcioninput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es la entrada a un sistema (input)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(96,"gen_st_rotuloinput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Entrada","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_output*/
			(97,"gen_st_nombreoutput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Salida","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(98,"gen_st_descripcionoutput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es la salida de un sistema (output)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(99,"gen_st_rotulooutput","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Salida","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_clase*/
			(100,"gen_st_nombreclase","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Clase o tipo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(101,"gen_st_descripcionclase","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identifica el tipo de entidad para clasificarla","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(102,"gen_st_rotuloclase","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tipo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_error */
			(112,"gen_st_nombreerror","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Concepto Error","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(113,"gen_st_descripcionerror","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identifica cualquier tipo de error","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(114,"gen_st_rotuloerror","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Error","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(175,"gen_st_iconoImagenConcepto_gen_error","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgError.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(176,"gen_st_iconoAudioConcepto_gen_error","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioError.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(177,"gen_st_imagenConcepto_gen_error","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_error.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_accionConsecuente */
			(121,"gen_st_nombreaccionConsecuente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Accion consecuente","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(122,"gen_st_descripcionaccionConsecuente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Define la accion a realizar tras un suceso (error, evento o sinmilar)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(123,"gen_st_rotuloaccionConsecuente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Accion consecuente","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_nivelDeGravedad */
			(124,"gen_st_nombre_gen_nivelDeGravedad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nivel de gravedad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(125,"gen_st_descripcion_gen_nivelDeGravedad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica el nivel de gravedad de una entidad (error, evento o sinmilar)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(126,"gen_st_rotulo_gen_nivelDeGravedad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nivel de gravedad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_localizacion */
			(127,"gen_st_nombre_gen_localizacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Localizacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(128,"gen_st_descripcion_gen_localizacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica la localizacion de una entidad (fisica, logica o de otro tipo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(129,"gen_st_rotulo_gen_localizacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Localizacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_agente */
			(130,"gen_st_nombre_gen_agente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Agente","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(131,"gen_st_descripcion_gen_agente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica quien hace algo o realiza una accion (fisica, logica o de otro tipo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(132,"gen_st_rotulo_gen_agente","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Agente","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_anexos */
			(133,"gen_st_nombre_gen_anexos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Anexos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(134,"gen_st_descripcion_gen_anexos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion asociada a la entidad, pero no propia de la ayuda a interfaaz (codigos, mensages del sistema, informacion relacionada, sin relacion en KLW)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(135,"gen_st_rotulo_gen_anexos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Anexos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_icono */
			(136,"gen_st_nombre_gen_icono","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Icono","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(137,"gen_st_descripcion_gen_icono","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Imagen iconografica (se utilizarà entre otras en interfaces o similares)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(138,"gen_st_rotulo_gen_icono","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Icono","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_imagen */
			(139,"gen_st_nombre_gen_imagen","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Imagen","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(140,"gen_st_descripcion_gen_imagen","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Imagen, cualquier entidad que puede ser visualizada, dinamica o no","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(141,"gen_st_rotulo_gen_imagen","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Imagen","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_archivo */
			(142,"gen_st_nombre_gen_archivo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Archivo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(143,"gen_st_descripcion_gen_archivo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Archivo, es cualquier entidad que almacena informacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(144,"gen_st_rotulo_gen_archivo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Archivo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_audio */
			(145,"gen_st_nombre_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(146,"gen_st_descripcion_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Audio, es cualquier entidad de audio, es decir contiene sonido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(147,"gen_st_rotulo_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(160,"gen_st_iconoImagenConcepto_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgAudio.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(161,"gen_st_iconoAudioConcepto_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioAudio.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(162,"gen_st_imagenConcepto_gen_audio","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_audio.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_lista */
			(163,"gen_st_nombre_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Lista","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(164,"gen_st_descripcion_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Lista : una lista de elementos cualesquiera","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(165,"gen_st_rotulo_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Lista","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(166,"gen_st_iconoImagenConcepto_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgLista.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(167,"gen_st_iconoAudioConcepto_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioLista.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(168,"gen_st_imagenConcepto_gen_lista","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Lista.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_datacion */
			(169,"gen_st_nombre_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Datacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(170,"gen_st_descripcion_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica el momento concreto de un evento o suceso","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(171,"gen_st_rotulo_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Datacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(172,"gen_st_iconoImagenConcepto_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgDatacion.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(173,"gen_st_iconoAudioConcepto_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioDatacion.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(174,"gen_st_imagenConcepto_gen_datacion","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_datacion.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_identidad */
			(178,"gen_st_nombre_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identidad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(179,"gen_st_descripcion_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa una identidad de persona fisica, juridica, alias u otros","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(180,"gen_st_rotulo_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identidad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(181,"gen_st_iconoImagenConcepto_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgIdentidad.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(182,"gen_st_iconoAudioConcepto_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIdentidad.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(183,"gen_st_imagenConcepto_gen_identidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Identidad.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_historialMedico */
			(184,"gen_st_nombre_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Historial Medico","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(185,"gen_st_descripcion_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene la historia medica de una entidad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(186,"gen_st_rotulo_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Historial Medico","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(187,"gen_st_iconoImagenConcepto_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgHistorialMedico.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(188,"gen_st_iconoAudioConcepto_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioHistorialMedico.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(189,"gen_st_imagenConcepto_gen_historialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_HistorialMedico.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_curriculum */
			(190,"gen_st_nombre_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Curriculum","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(191,"gen_st_descripcion_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene el curriculum de una entidad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(192,"gen_st_rotulo_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Curriculum","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(193,"gen_st_iconoImagenConcepto_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgCurriculum.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(194,"gen_st_iconoAudioConcepto_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioCurriculum.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(195,"gen_st_imagenConcepto_gen_curriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Curriculum.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_personaFisica */
			(196,"gen_st_nombre_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Persona","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(197,"gen_st_descripcion_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene la informacion de una persona fisica","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(198,"gen_st_rotulo_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Persona","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(199,"gen_st_iconoImagenConcepto_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPersonaFisica.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(200,"gen_st_iconoAudioConcepto_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPersonaFisica.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(201,"gen_st_imagenConcepto_gen_personaFisica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_PersonaFisica.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_ordinado */
			(202,"gen_st_nombre_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ordinado","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(203,"gen_st_descripcion_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"En un concepto que instancia este concepto, los descendientes deben incluir un mecanismo que permita ordenarlos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(204,"gen_st_rotulo_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ordinado","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(205,"gen_st_iconoImagenConcepto_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgOrdinado.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(206,"gen_st_iconoAudioConcepto_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioOrdinado.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(207,"gen_st_imagenConcepto_gen_ordinado","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Ordinado.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_ordinal */
			(208,"gen_st_nombre_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ordinal","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(209,"gen_st_descripcion_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica el orden o lugar que ocupa un elemento dentro de una lista","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(210,"gen_st_rotulo_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ordinal","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(211,"gen_st_iconoImagenConcepto_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgOrdinal.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(212,"gen_st_iconoAudioConcepto_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioOrdinal.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(213,"gen_st_imagenConcepto_gen_ordinal","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Ordinal.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_numero */
			(214,"gen_st_nombre_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Numero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(215,"gen_st_descripcion_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene un numero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(216,"gen_st_rotulo_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Numero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(217,"gen_st_iconoImagenConcepto_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgNumero.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(218,"gen_st_iconoAudioConcepto_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioNumero.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(219,"gen_st_imagenConcepto_gen_numero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Numero.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de  gen_ai_es_gen_prefijo */
			(220,"gen_st_nombre_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Prefijo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(221,"gen_st_descripcion_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica el prefijo asociado a una expresion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(222,"gen_st_rotulo_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Prefijo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(223,"gen_st_iconoImagenConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPrefijo.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(224,"gen_st_iconoAudioConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPrefijo.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(225,"gen_st_imagenConcepto_gen_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Prefijo.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_contiene */
			(226,"gen_st_nombre_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(227,"gen_st_descripcion_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indica los elementos contenidos en un concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(228,"gen_st_rotulo_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contenido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(229,"gen_st_iconoImagenConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgContenido.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(230,"gen_st_iconoAudioConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioContenido.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(231,"gen_st_imagenConcepto_gen_contiene","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Contenido.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   231, debes utilizar uno posterior para el siguiente registro  **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos de   gen_ai_es_gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_nombreUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_descripcionUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el usuario que genera por defecto al generar la BBDD de una aplicacion DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_rotuloUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   162, debes utilizar uno posterior para el siguiente registro  ojo, a partir de 1000 el ultimo es 1002 **********  */			

/*  *********************  FIN Tablas de ai_es_conceptos  ************************************** */
/*  ******************************************************************************************** */

/*   1.1.101
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (ai_ing_conceptos) *******************
*************************************************    */

/*  *********************  INICIO Tablas de ai_ing_conceptos  ************************************** */
/* Creamos la tabla principal de ai_ing_conceptos. Almacena  la tabla de declaracion de los conceptos*/
DROP TABLE IF EXISTS `ai_ing_conceptos`;

CREATE TABLE `ai_ing_conceptos` (
  `IdConcepto` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,
  /* El resto son campos de apoyo a la operativa del sistema */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`IdConcepto`),
  KEY `Clave` (`Clave`)
);

/*  Conceptos de ayuda a interfaz  en español ***********  */
insert  into `ai_ing_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			(4,"gen_ai_ing_gen_usuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_ai_ing_gen_nombreUsuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_ai_ing_gen_paswordUsuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(7,"gen_ai_ing_gen_usuarioAdministrador",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_ai_ing_gen_nombre",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_ai_ing_gen_descripcion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(13,"gen_ai_ing_gen_rotulo",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(31,"gen_ai_ing_gen_Identificador",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_ai_ing_gen_input",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_ai_ing_gen_output",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(34,"gen_ai_ing_gen_clase",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(38,"gen_ai_ing_gen_error",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(41,"gen_ai_ing_gen_accionConsecuente",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(42,"gen_ai_ing_gen_nivelDeGravedad",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(43,"gen_ai_ing_gen_localizacion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(44,"gen_ai_ing_gen_agente",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(45,"gen_ai_ing_gen_anexos",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(46,"gen_ai_ing_gen_icono",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(47,"gen_ai_ing_gen_imagen",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(48,"gen_ai_ing_gen_archivo",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(49,"gen_ai_ing_gen_audio",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(50,"gen_ai_ing_gen_lista",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(51,"gen_ai_ing_gen_datacion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(52,"gen_ai_ing_gen_identidad",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(53,"gen_ai_ing_gen_historialMedico",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(54,"gen_ai_ing_gen_curriculum",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(55,"gen_ai_ing_gen_personaFisica",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   55, debes utilizar uno posterior para el siguiente registro **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_ing_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			(1000,"gen_ai_ing_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
	/* Creamos la tabla principal de ai_ing_conceptos_conceptos. Almacena la descripcion del arbol definicion de cada concepto*/
DROP TABLE IF EXISTS `ai_ing_conceptos_conceptos`;

CREATE TABLE `ai_ing_conceptos_conceptos` (
  `IdRel` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de relacion de concepto_concepto */
  `IdRelPadre` bigint(255) unsigned NOT NULL, /* Es el padre en el arbol de descripcion. Si es cero, la entrada es la raiz de una descripcion */
  `ClaveHijo` varchar(255) NOT NULL, /* Clave del hijo. (En caso de que  corresponda a un sinTecho o tabla local, aqui se almacena el Idcst de la tabla correspondiente.*/  
  `LocalizacionHijo` varchar(255) NOT NULL, /* Localizacion del hijo. (En caso de que  corresponda a una tabla local, aqui se almacena el nombre de la tabla. LO SABEMOS PORQUE LA LOCALIZACION NO TENDRA PUNTOS */  
  `OrdinalHijo` int(255) unsigned NOT NULL,
  `TiempoActualizacionHijo` double NOT NULL,
  `Localidad` int(2) NOT NULL default '1', /* Externo = 0, Interno = 1. Indica si el concepto reside en el DKS o en uno externo */
  `Familia` varchar(255), /* Indica la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos. Si es externo contiene ""*/  
  `IdEnTabla` bigint(255), /*  Indica el identificador dentro de la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos SI es externo contien  0.*/  
  /*  No se si sera necesario un indicador de instancia-referencia, en principio no lo es */
  `InsRef` int(1) NOT NULL, /*   1 = Referencia ,  0 = Instancia  2=SinTecho*/
  PRIMARY KEY (`IdRel`)
);

/*  Conceptos de ayuda a interfaz  en español ***********  *
insert  into `ai_ing_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values  ****************  */

/*  Conceptos  para DKS BASICO ***********  */
insert  into `ai_ing_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	
		/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_usuario  ***********  */
			(29,0,"gen_ai_ing_gen_usuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",4,0),
		/* nombre */
			(30,29,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(31,30,"gen_st_nombreConceptoUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",10,2),
		/* descripcion */
			(32,29,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(33,32,"gen_st_descripcionConceptoUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",11,2),
		/* rotulo */
			(34,29,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(35,34,"gen_st_rotuloConceptoUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",12,2),
			
			(406,29,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(407,406,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_nombreUsuario  ***********  */
			(36,0,"gen_ai_ing_gen_nombreUsuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",5,0),
		/* nombre */
			(37,36,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(38,37,"gen_st_nombreNombreUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",13,2),
		/* descripcion */
			(39,36,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(40,39,"gen_st_descripcionNombreUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",14,2),
		/* rotulo */
			(41,36,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(42,41,"gen_st_rotuloNombreUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",15,2),
			
			(408,36,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(409,408,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_paswordUsuario  ***********  */
			(43,0,"gen_ai_ing_gen_paswordUsuario",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",6,0),
		/* nombre */
			(44,43,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(45,44,"gen_st_nombrepaswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",16,2),
		/* descripcion */
			(46,43,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(47,46,"gen_st_descripcionpaswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",17,2),
		/* rotulo */
			(48,43,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(49,48,"gen_st_rotulopaswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",18,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(362,43,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(363,362,"gen_st_iconoImagenConcepto_gen_paswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",157,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(364,43,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(365,364,"gen_st_iconoAudioConcepto_gen_paswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",158,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(366,43,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(367,366,"gen_st_imagenConcepto_gen_paswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",159,2),
			
			(410,43,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(411,410,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_usuarioAdministrador  ***********  */
			(50,0,"gen_ai_ing_gen_usuarioAdministrador",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",7,0),
		/* nombre */
			(51,50,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(52,51,"gen_st_nombreUsuarioAdministrador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",19,2),
		/* descripcion */
			(53,50,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(54,53,"gen_st_descripcionUsuarioAdministrador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",20,2),
		/* rotulo */
			(55,50,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(56,55,"gen_st_rotuloUsuarioAdministrador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",21,2),
			
			(412,50,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(413,412,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_nombre  ***********  */
			(71,0,"gen_ai_ing_gen_nombre",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",11,0),
		/* nombre */
			(72,71,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(73,72,"gen_st_nombreNombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",31,2),
		/* descripcion */
			(74,71,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(75,74,"gen_st_descripcionNombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",32,2),
		/* rotulo */
			(76,71,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(77,76,"gen_st_rotuloNombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",33,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(344,71,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(345,344,"gen_st_iconoImagenConcepto_gen_nombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",148,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(346,71,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(347,346,"gen_st_iconoAudioConcepto_gen_nombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",149,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(348,71,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(349,348,"gen_st_imagenConcepto_gen_nombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",150,2),
			
			(414,71,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(415,415,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_descripcion  ***********  */
			(78,0,"gen_ai_ing_gen_descripcion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",12,0),
		/* nombre */
			(79,78,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(80,79,"gen_st_nombreDescripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",34,2),
		/* descripcion */
			(81,78,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(82,81,"gen_st_descripcionDescripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",35,2),
		/* rotulo */
			(83,78,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(84,83,"gen_st_rotuloDescripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",36,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(350,78,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(351,350,"gen_st_iconoImagenConcepto_gen_descripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",151,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(352,78,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(353,352,"gen_st_iconoAudioConcepto_gen_descripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",152,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(354,78,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(355,354,"gen_st_imagenConcepto_gen_descripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",153,2),
			
			(416,78,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(417,416,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_rotulo  ***********  */
			(85,0,"gen_ai_ing_gen_rotulo",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",13,0),
		/* nombre */
			(86,85,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(87,86,"gen_st_nombreRotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",37,2),
		/* descripcion */
			(88,85,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(89,88,"gen_st_descripcionRotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",38,2),
		/* rotulo */
			(90,85,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(91,90,"gen_st_rotuloRotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",39,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(356,85,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(357,356,"gen_st_iconoImagenConcepto_gen_rotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",154,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(358,85,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(359,358,"gen_st_iconoAudioConcepto_gen_rotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",155,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(360,85,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(361,360,"gen_st_imagenConcepto_gen_rotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",156,2),
			
			(418,85,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(419,418,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_Identificador  ***********  */
			(211,0,"gen_ai_ing_gen_Identificador",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",31,0),
		/* nombre */
			(212,211,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(213,212,"gen_st_nombreIdentificador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",91,2),
		/* descripcion */
			(214,211,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(215,214,"gen_st_descripcionIdentificador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",92,2),
		/* rotulo */
			(216,211,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(217,216,"gen_st_rotuloIdentificador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",93,2),
			
			(420,211,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(421,420,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_input  ***********  */
			(218,0,"gen_ai_ing_gen_input",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",32,0),
		/* nombre */
			(219,218,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(220,219,"gen_st_nombreinput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",94,2),
		/* descripcion */
			(221,218,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(222,221,"gen_st_descripcioninput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",95,2),
		/* rotulo */
			(223,218,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(224,223,"gen_st_rotuloinput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",96,2),
			
			(422,218,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(423,422,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_output  ***********  */
			(225,0,"gen_ai_ing_gen_output",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",33,0),
		/* nombre */
			(226,225,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(227,226,"gen_st_nombreoutput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",97,2),
		/* descripcion */
			(228,225,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(229,228,"gen_st_descripcionoutput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",98,2),
		/* rotulo */
			(230,225,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(231,230,"gen_st_rotulooutput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",99,2),
			
			(424,225,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(425,424,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_clase  ***********  */
			(232,0,"gen_ai_ing_gen_clase",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",34,0),
		/* nombre */
			(233,232,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(234,233,"gen_st_nombreclase","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",100,2),
		/* descripcion */
			(235,232,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(236,235,"gen_st_descripcionclase","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",101,2),
		/* rotulo */
			(237,232,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(238,237,"gen_st_rotuloclase","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",102,2),
			
			(426,232,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(427,426,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_error  ***********  */
			(260,0,"gen_ai_ing_gen_error",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",38,0),
			/* nombre */
				(261,260,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(262,261,"gen_st_nombreerror","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",112,2),
			/* descripcion */
				(263,260,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(264,263,"gen_st_descripcionerror","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",113,2),
			/* rotulo */
				(265,260,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(266,265,"gen_st_rotuloerror","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",114,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(400,260,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(401,400,"gen_st_iconoImagenConcepto_gen_error","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",175,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(402,260,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(403,402,"gen_st_iconoAudioConcepto_gen_error","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",176,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(404,260,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(405,404,"gen_st_imagenConcepto_gen_error","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",177,2),
			
			(428,260,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(429,428,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_accionConsecuente  ***********  */
			(281,0,"gen_ai_ing_gen_accionConsecuente",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",41,0),
		/* nombre */
			(282,281,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(283,282,"gen_st_nombreaccionConsecuente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",121,2),
		/* descripcion */
			(284,281,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(285,284,"gen_st_descripcionaccionConsecuente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",122,2),
		/* rotulo */
			(286,281,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(287,286,"gen_st_rotuloaccionConsecuente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",123,2),
			
			(430,281,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(431,430,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_nivelDeGravedad  ***********  */
			(288,0,"gen_ai_ing_gen_nivelDeGravedad",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",42,0),
		/* nombre */
			(289,288,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(290,289,"gen_st_nombre_gen_nivelDeGravedad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",124,2),
		/* descripcion */
			(291,288,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(292,291,"gen_st_descripcion_gen_nivelDeGravedad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",125,2),
		/* rotulo */
			(293,288,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(294,293,"gen_st_rotulo_gen_nivelDeGravedad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",126,2),
			
			(432,288,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(433,432,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_localizacion  ***********  */
			(295,0,"gen_ai_ing_gen_localizacion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",43,0),
		/* nombre */
			(296,295,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(297,296,"gen_st_nombre_gen_localizacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",127,2),
		/* descripcion */
			(298,295,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(299,298,"gen_st_descripcion_gen_localizacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",128,2),
		/* rotulo */
			(300,295,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(301,300,"gen_st_rotulo_gen_localizacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",129,2),
			
			(434,295,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(435,434,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_agente  ***********  */
			(302,0,"gen_ai_ing_gen_agente",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",44,0),
		/* nombre */
			(303,302,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(304,303,"gen_st_nombre_gen_agente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",130,2),
		/* descripcion */
			(305,302,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(306,305,"gen_st_descripcion_gen_agente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",131,2),
		/* rotulo */
			(307,302,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(308,307,"gen_st_rotulo_gen_agente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",132,2),
			
			(436,302,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(437,436,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_anexos  ***********  */
			(309,0,"gen_ai_ing_gen_anexos",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",45,0),
		/* nombre */
			(310,309,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(311,310,"gen_st_nombre_gen_anexos","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",133,2),
		/* descripcion */
			(312,309,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(313,312,"gen_st_descripcion_gen_anexos","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",134,2),
		/* rotulo */
			(314,309,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(315,314,"gen_st_rotulo_gen_anexos","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",135,2),
			
			(438,309,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(439,438,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_icono  ***********  */
			(316,0,"gen_ai_ing_gen_icono",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",46,0),
		/* nombre */
			(317,316,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(318,317,"gen_st_nombre_gen_icono","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",136,2),
		/* descripcion */
			(319,316,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(320,319,"gen_st_descripcion_gen_icono","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",137,2),
		/* rotulo */
			(321,316,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(322,321,"gen_st_rotulo_gen_icono","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",138,2),
			
			(440,316,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(441,440,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_imagen  ***********  */
			(323,0,"gen_ai_ing_gen_imagen",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",47,0),
		/* nombre */
			(324,323,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(325,324,"gen_st_nombre_gen_imagen","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",139,2),
		/* descripcion */
			(326,323,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(327,326,"gen_st_descripcion_gen_imagen","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",140,2),
		/* rotulo */
			(328,323,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(329,328,"gen_st_rotulo_gen_imagen","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",141,2),
			
			(442,323,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(443,442,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_archivo  ***********  */
			(330,0,"gen_ai_ing_gen_archivo",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",48,0),
		/* nombre */
			(331,330,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(332,331,"gen_st_nombre_gen_archivo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",142,2),
		/* descripcion */
			(333,330,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(334,333,"gen_st_descripcion_gen_archivo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",143,2),
		/* rotulo */
			(335,330,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(336,335,"gen_st_rotulo_gen_archivo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",144,2),
			
			(444,330,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(445,444,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_audio  ***********  */
			(337,0,"gen_ai_ing_gen_audio",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",49,0),
		/* nombre */
			(338,337,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(339,338,"gen_st_nombre_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",145,2),
		/* descripcion */
			(340,337,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(341,340,"gen_st_descripcion_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",146,2),
		/* rotulo */
			(342,337,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(343,342,"gen_st_rotulo_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",147,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(368,337,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(369,368,"gen_st_iconoImagenConcepto_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",160,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(370,337,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(371,370,"gen_st_iconoAudioConcepto_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",161,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(372,337,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(373,372,"gen_st_imagenConcepto_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",162,2),
			
			(446,337,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(447,446,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_lista  ***********  */
			(374,0,"gen_ai_ing_gen_lista",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",50,0),
		/* nombre */
			(375,374,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(376,375,"gen_st_nombre_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",163,2),
		/* descripcion */
			(377,374,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(378,377,"gen_st_descripcion_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",164,2),
		/* rotulo */
			(379,374,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(380,379,"gen_st_rotulo_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",165,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(381,374,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(382,381,"gen_st_iconoImagenConcepto_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",166,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(383,374,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(384,383,"gen_st_iconoAudioConcepto_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",167,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(385,374,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(386,385,"gen_st_imagenConcepto_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",168,2),
			
			(448,374,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(449,448,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_ing_gen_datacion  ***********  */
			(387,0,"gen_ai_ing_gen_datacion",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",51,0),
		/* nombre */
			(388,387,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
			(389,388,"gen_st_nombre_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",169,2),
		/* descripcion */
			(390,387,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
			(391,390,"gen_st_descripcion_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",170,2),
		/* rotulo */
			(392,387,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
			(393,392,"gen_st_rotulo_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",171,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(394,387,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(395,394,"gen_st_iconoImagenConcepto_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",172,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(396,387,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(397,396,"gen_st_iconoAudioConcepto_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",173,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(398,387,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(399,398,"gen_st_imagenConcepto_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",174,2),
			
			(450,387,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(451,450,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),

	/* Relaciones de ayuda interfaz del concepto gen_identidad  ***********  */
			(452,0,"gen_ai_ing_gen_identidad",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",52,0),
		/* Ayuda a interfaz */
				(453,452,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(454,453,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
		/* nombre */
				(455,452,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(456,455,"gen_st_nombre_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",178,2),
		/* descripcion */
				(457,452,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(458,457,"gen_st_descripcion_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",179,2),
		/* rotulo */
				(459,452,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(460,459,"gen_st_rotulo_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",180,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(461,452,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(462,461,"gen_st_iconoImagenConcepto_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",181,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(463,452,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(464,463,"gen_st_iconoAudioConcepto_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",182,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(465,452,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(466,465,"gen_st_imagenConcepto_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",183,2),
			
	/* Relaciones de ayuda interfaz del concepto gen_historialMedico  ***********  */
			(467,0,"gen_ai_ing_gen_historialMedico",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",53,0),
		/* Ayuda a interfaz */
				(468,467,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(469,468,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
		/* nombre */
				(470,467,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(471,470,"gen_st_nombre_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",184,2),
		/* descripcion */
				(472,467,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(473,472,"gen_st_descripcion_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",185,2),
		/* rotulo */
				(474,467,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(475,474,"gen_st_rotulo_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",186,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(476,467,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(477,476,"gen_st_iconoImagenConcepto_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",187,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(478,467,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(479,478,"gen_st_iconoAudioConcepto_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",188,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(480,467,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(481,480,"gen_st_imagenConcepto_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",189,2),
			
	/* Relaciones de ayuda interfaz del concepto gen_curriculum  ***********  */
			(482,0,"gen_ai_ing_gen_curriculum",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",54,0),
		/* Ayuda a interfaz */
				(483,482,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(484,483,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
		/* nombre */
				(485,482,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(486,485,"gen_st_nombre_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",190,2),
		/* descripcion */
				(487,482,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(488,487,"gen_st_descripcion_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",191,2),
		/* rotulo */
				(489,482,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(490,489,"gen_st_rotulo_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",192,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(491,482,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(492,491,"gen_st_iconoImagenConcepto_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",193,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(493,482,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(494,493,"gen_st_iconoAudioConcepto_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",194,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(495,482,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(496,495,"gen_st_imagenConcepto_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",195,2),
			
	/* Relaciones de ayuda interfaz del concepto gen_personaFisica  ***********  */
			(497,0,"gen_ai_ing_gen_personaFisica",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",55,0),
		/* Ayuda a interfaz */
				(498,497,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(499,498,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
		/* nombre */
				(500,497,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(501,500,"gen_st_nombre_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",196,2),
		/* descripcion */
				(502,497,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(503,502,"gen_st_descripcion_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",197,2),
		/* rotulo */
				(504,497,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(505,504,"gen_st_rotulo_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",198,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(506,497,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(507,506,"gen_st_iconoImagenConcepto_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",199,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(508,497,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(509,508,"gen_st_iconoAudioConcepto_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",200,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(510,497,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(511,510,"gen_st_imagenConcepto_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",201,2),
			
/* Relaciones de ayuda interfaz del concepto gen_usuarioAdministradorLocal1  ***********  */
			(1000,0,"gen_ai_ing_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",1000,0),
		/* nombre */
			(1001,1000,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
			(1002,1001,"gen_st_nombreusuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",1000,2),
		/* descripcion */
			(1003,1000,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
			(1004,1003,"gen_st_descripcionusuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",1001,2),
		/* rotulo */
			(1005,1000,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
			(1006,1005,"gen_st_rotulousuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",1002,2);

/*    Ultimo identificador utilizado para esta tabla de arriba   511, debes utilizar uno posterior para el siguiente registro  ojo, a partir de 1000 el ultimo es 1006 **********  */			

			
	/* Creamos la tabla principal de conceptos_sin_techo. Almacena el dato de los conceptos que no tienen descripcion (numeros enteros, nombres, etc...)*/
DROP TABLE IF EXISTS `ai_ing_conceptos_sin_techo`;

CREATE TABLE `ai_ing_conceptos_sin_techo` (
  `Idcst` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de concepto sinTecho */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,  /*  En esta tabla el localizador será la misma tabla y famoila, ya que por narices son locales */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `Contenido` varchar(255), /* Ojo, en principio debe poder meterse cualquier cosa, un dato, la localizacion de un fichero. u otros */  
  /* El tipo de los datos de un sinTecho, puede cualificarse asociandolo a un concepto, en el que encontraremos informacion de como tratarlo, mostrarlo, etc... */
  `ClaveTipo` varchar(255) NOT NULL, /* Clave del Tipo del sinTecho*/  
  `LocalizacionTipo` varchar(255) NOT NULL, /* Localizacion del Tipo del sinTecho*/  
  `OrdinalTipo` int(255) unsigned NOT NULL,
  `TiempoActualizacionTipo` double NOT NULL,
  `ClaveUsuario` varchar(255) NOT NULL,  /* Clave de la persona o entidad que realiza la modificacion */
  `LocalizacionUsuario` varchar(255) NOT NULL, /* Localizacion de la persona o entidad que realiza la modificacion */
  `Acceso` int(10) NOT NULL default '10000', /* Libre = 10000, Limitado = 20000, De pago = 30000, NO accesibel = 50000 (Solo gestion DKS)  */
  PRIMARY KEY  (`Idcst`)
);

/*  Conceptos datos (sin techo) de ayuda a interfaz en español ***********  */
insert  into `ai_ing_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			/* datos de   gen_ai_ing_gen_usuario */
			(10,"gen_st_nombreConceptoUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User concept","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_st_descripcionConceptoUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User concept like entity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_st_rotuloConceptoUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_ing_gen_usuario nombre*/
			(13,"gen_st_nombreNombreUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User name","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(14,"gen_st_descripcionNombreUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"It is the name given to the user as a system user","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(15,"gen_st_rotuloNombreUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User name","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_ing_gen_usuario  pasword*/
			(16,"gen_st_nombrepaswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_st_descripcionpaswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"It is the user's password in the system","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(18,"gen_st_rotulopaswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Password","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(157,"gen_st_iconoImagenConcepto_gen_paswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPassword.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(158,"gen_st_iconoAudioConcepto_gen_paswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngPassword.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(159,"gen_st_imagenConcepto_gen_paswordUsuario","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_password.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_ing_gen_usuarioAdministrador */
			(19,"gen_st_nombreUsuarioAdministrador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User Manager","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(20,"gen_st_descripcionUsuarioAdministrador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"It is the user that is generated at the software installation, as a system administrator","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(21,"gen_st_rotuloUsuarioAdministrador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"User Manager","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_nombre */
			(31,"gen_st_nombreNombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Name","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_st_descripcionNombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains the name associated with a concept","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_st_rotuloNombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Name","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(148,"gen_st_iconoImagenConcepto_gen_nombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgNombre.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(149,"gen_st_iconoAudioConcepto_gen_nombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngName.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(150,"gen_st_imagenConcepto_gen_nombre","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_nombre.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_descripcion */
			(34,"gen_st_nombreDescripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Description","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(35,"gen_st_descripcionDescripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains the description associated with a concept","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(36,"gen_st_rotuloDescripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Description","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(151,"gen_st_iconoImagenConcepto_gen_descripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgDescripcion.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(152,"gen_st_iconoAudioConcepto_gen_descripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngDescription.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(153,"gen_st_imagenConcepto_gen_descripcion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_descripcion.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_rotulo */
			(37,"gen_st_nombreRotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Label","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(38,"gen_st_descripcionRotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains the label associated with a concept","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(39,"gen_st_rotuloRotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Label","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(154,"gen_st_iconoImagenConcepto_gen_rotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgRotulo.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(155,"gen_st_iconoAudioConcepto_gen_rotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngLabel.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(156,"gen_st_imagenConcepto_gen_rotulo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_rotulo.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_Identificador*/
			(91,"gen_st_nombreIdentificador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"identifier","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(92,"gen_st_descripcionIdentificador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"This element is used to identify an entity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(93,"gen_st_rotuloIdentificador","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"identifier","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_Identificador*/
			(94,"gen_st_nombreinput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Input","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(95,"gen_st_descripcioninput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Represents a system input","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(96,"gen_st_rotuloinput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Input","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_output*/
			(97,"gen_st_nombreoutput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Output","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(98,"gen_st_descripcionoutput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Represents a system output","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(99,"gen_st_rotulooutput","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Salida","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_clase*/
			(100,"gen_st_nombreclase","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Class","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(101,"gen_st_descripcionclase","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"identifies the class which is associated to one entity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(102,"gen_st_rotuloclase","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Class","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_error */
			(112,"gen_st_nombreerror","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Error","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(113,"gen_st_descripcionerror","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identifies any errors","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(114,"gen_st_rotuloerror","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Error","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(175,"gen_st_iconoImagenConcepto_gen_error","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgError.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(176,"gen_st_iconoAudioConcepto_gen_error","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngError.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(177,"gen_st_imagenConcepto_gen_error","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_error.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_accionConsecuente */
			(121,"gen_st_nombreaccionConsecuente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Consequent action","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(122,"gen_st_descripcionaccionConsecuente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Defines the action to take after an event (error, event or sinmilar)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(123,"gen_st_rotuloaccionConsecuente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Consequent action","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_nivelDeGravedad */
			(124,"gen_st_nombre_gen_nivelDeGravedad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Severity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(125,"gen_st_descripcion_gen_nivelDeGravedad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indicates the severity level of an entity (error, event or sinmilar)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(126,"gen_st_rotulo_gen_nivelDeGravedad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Severity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_localizacion */
			(127,"gen_st_nombre_gen_localizacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Location","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(128,"gen_st_descripcion_gen_localizacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identifying the location of an entity (physical, logical or otherwise)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(129,"gen_st_rotulo_gen_localizacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Location","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_agente */
			(130,"gen_st_nombre_gen_agente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Agent","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(131,"gen_st_descripcion_gen_agente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indicates who does something or perform an action (physical, logical or otherwise)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(132,"gen_st_rotulo_gen_agente","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Agent","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_anexos */
			(133,"gen_st_nombre_gen_anexos","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Annexes","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(134,"gen_st_descripcion_gen_anexos","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains information associated with the entity, but not proper to help interfaaz (codes, messages from the system, information related, unrelated in KLW)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(135,"gen_st_rotulo_gen_anexos","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Annexes","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_icono */
			(136,"gen_st_nombre_gen_icono","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Icon","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(137,"gen_st_descripcion_gen_icono","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Iconographic image (used among others in interfaces or similar)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(138,"gen_st_rotulo_gen_icono","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Icon","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_imagen */
			(139,"gen_st_nombre_gen_imagen","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Image","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(140,"gen_st_descripcion_gen_imagen","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Image, any entity that can be viewed, dynamic or not","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(141,"gen_st_rotulo_gen_imagen","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Image","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_archivo */
			(142,"gen_st_nombre_gen_archivo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Archive","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(143,"gen_st_descripcion_gen_archivo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Is any entity that stores information","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(144,"gen_st_rotulo_gen_archivo","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Archive","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_audio */
			(145,"gen_st_nombre_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(146,"gen_st_descripcion_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Is any entity that can be heard","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(147,"gen_st_rotulo_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(160,"gen_st_iconoImagenConcepto_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgAudio.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(161,"gen_st_iconoAudioConcepto_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngAudio.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(162,"gen_st_imagenConcepto_gen_audio","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_audio.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_lista */
			(163,"gen_st_nombre_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"List","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(164,"gen_st_descripcion_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"A list of any items","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(165,"gen_st_rotulo_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"List","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(166,"gen_st_iconoImagenConcepto_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgLista.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(167,"gen_st_iconoAudioConcepto_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngList.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(168,"gen_st_imagenConcepto_gen_lista","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Lista.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_datacion */
			(169,"gen_st_nombre_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Dating","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(170,"gen_st_descripcion_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Indicates the exact time of an event or occurrence","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(171,"gen_st_rotulo_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Dating","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(172,"gen_st_iconoImagenConcepto_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgDatacion.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(173,"gen_st_iconoAudioConcepto_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngDating.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(174,"gen_st_imagenConcepto_gen_datacion","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_datacion.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_identidad */
			(178,"gen_st_nombre_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(179,"gen_st_descripcion_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identity represents a natural person, company, or other alias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(180,"gen_st_rotulo_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(181,"gen_st_iconoImagenConcepto_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgIdentidad.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(182,"gen_st_iconoAudioConcepto_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngIdentity.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(183,"gen_st_imagenConcepto_gen_identidad","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Identidad.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_historialMedico */
			(184,"gen_st_nombre_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Medical history","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(185,"gen_st_descripcion_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains medical history of an entity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(186,"gen_st_rotulo_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Medical history","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(187,"gen_st_iconoImagenConcepto_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgHistorialMedico.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(188,"gen_st_iconoAudioConcepto_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngMedicalHistory.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(189,"gen_st_imagenConcepto_gen_historialMedico","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_HistorialMedico.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_curriculum */
			(190,"gen_st_nombre_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Curriculum","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(191,"gen_st_descripcion_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains the curriculum of an entity","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(192,"gen_st_rotulo_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Curriculum","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(193,"gen_st_iconoImagenConcepto_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgCurriculum.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(194,"gen_st_iconoAudioConcepto_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngCurriculum.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(195,"gen_st_imagenConcepto_gen_curriculum","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Curriculum.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_ing_gen_personaFisica */
			(196,"gen_st_nombre_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Person","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(197,"gen_st_descripcion_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contains information about a natural person","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(198,"gen_st_rotulo_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Person","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(199,"gen_st_iconoImagenConcepto_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPersonaFisica.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(200,"gen_st_iconoAudioConcepto_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioIngPersonaFisica.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(201,"gen_st_imagenConcepto_gen_personaFisica","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_PersonaFisica.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   201, debes utilizar uno posterior para el siguiente registro  **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_ing_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos de   gen_ai_ing_gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_nombreUsuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"local administrator user1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_descripcionUsuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"It is the user that is generated by default when you build an application DB DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_rotuloUsuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"local administrator user1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   162, debes utilizar uno posterior para el siguiente registro  ojo, a partir de 1000 el ultimo es 1002 **********  */			

/*  *********************  FIN Tablas de ai_ing_conceptos  ************************************** */
/*  ****************************************************************************************************************************** */
/*  ****************************************************************************************************************************** */


/*   1.2
*************************************************
*******  TABLAS DE CAMINO  *******************
*************************************************    */


/*  ************************************************   FIN TABLAS DE CAMINO  ***************************************************** */



/*   1.3
*************************************************
**********  TABLAS DE CACHE  ********************
*************************************************    */

/* ****************************************************
OBSERVACIONES: (2014-02-25)
	- Las tablas de cache, son tablas que no respectan la estructura del DKS (conceptos, conceptos-conceptos, sinTecho).
	- Sus datos deben estar en las tablas del DKS correspondiente en el formato DKS, pero se pasan aqui a estas tablas, para agilizar las 
	consultas, ya que estas son muy frecuentes
	- Estas tablas, normalmente deben estar asociadas a un PROCESO que las actualiza, tomando los datos  de las tablas de DKS y anotandolos
	en estas tablas de cache para que sea mas agil su acceso.  Este proceso debe ejecutarse segun corresponda a la naturaleza de los datos de la
	tabla de cache. Por ejemplo, la tabla de idiomas de ayuda a interfaz, debe actualizarse cada vez que se incluya o elimine una tabla de 
	familia de ayada  a interfaz en un idioma
	- Todas estas tablas comienzan por KCH_   (de cache)

****************************************************** */


/* *********************  INICIO Tablas de CACHE  ************************************** */

/* Creamos la tabla principal de kch_idiomas_ayuda_interfaz. Almacena  la los datos de los idiomas que tienen tabla de ayuda a interfaz en este DKS  */
/* ESTA TABLA DEBE ACTUALIZARSE cada vez que se incluya o elimine un nuevo grupo de tablas de familia de ayuda a interfaz en un idioma  */
DROP TABLE IF EXISTS `kch_idiomas_ayuda_interfaz`;

CREATE TABLE `kch_idiomas_ayuda_interfaz` (
  `IdDeIdiomaAI` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave_Idioma` varchar(255) NOT NULL,  /* contiene el Key del idioma de la tabla de ayuda a interfaz correspondiente */
  `Localizacion_Idioma` varchar(255) NOT NULL,  /* contiene el Key del idioma de la tabla de ayuda a interfaz correspondiente */
  `TiempoActualizacion` double NOT NULL, /* Es una marca de tiempo que indica la hora internacional de la version */
  `Prefijo_familia` varchar(15) NOT NULL,  /* contiene el Key del idioma de la tabla de ayuda a interfaz correspondiente */
  `Ordinal` int(255) unsigned NOT NULL,  /* Indica el orden de la version del concepto en sus modificaciones sucesivas */
  PRIMARY KEY  (`IdDeIdiomaAI`)
); 

/*  Registors de los idiomas que tienen tabla de familia de ayuda a interfaz en este DKS ***********  */
insert  into `kch_idiomas_ayuda_interfaz`(`IdDeIdiomaAI`,`Clave_Idioma`,`Localizacion_Idioma`,`TiempoActualizacion`,`Prefijo_familia`,`Ordinal`) 
	values	
		/*  datos de los prefijos de familia */
		(1,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@tiemoDeAlta_LANGUAJES,"ai_es_",100000),
		(2,"gen_idioma_ingles",@localizacion_DKS_LANGUAJES,@tiemoDeAlta_LANGUAJES,"ai_ing_",100100);
			
/*    Ultimo identificador utilizado para esta tabla de arriba   1, debes utilizar uno posterior para el siguiente registro **********  */			

/* ************************  FIN  Tablas de CACHE  ************************************** */
