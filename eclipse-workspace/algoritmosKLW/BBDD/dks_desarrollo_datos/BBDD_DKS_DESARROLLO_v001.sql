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

/* esto que sigue no se para que sirve */
/*SET NAMES utf8;*/
/*!40101 SET SQL_MODE=''*/;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/* la base de datos tiene que estar dada de alta */
CREATE DATABASE IF NOT EXISTS dksdesarrollo CHARSET = utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `dksdesarrollo`;  /* Aqui se identifica la base de datos  */

/*  ******* Definimos algunas variables para utilizarlas a lo largo del script **************************  */

/*  otros DKS a los que se hace referencia  */
SET @localizacionGenericDKS = "http://localhost/klw/dks_Generic"; /* Para DKS geberico  */
SET @localizacion_DKS_KLW = "http://localhost/klw/dks_klw"; /* Para el DKS  de KLW  */
SET @localizacion_DKS_LANGUAJES = "http://localhost/klw/dks_Languajes"; /* Para el DKS de idiomas  */

/* **
SET @localizacionGenericDKS = "http://www.ideando.net/klw/dks_Generic";
SET @localizacion_DKS_KLW = "http://www.ideando.net/klw/dks_klw";
SET @localizacion_DKS_LANGUAJES = "http://www.ideando.net/klw/dks_Languajes";
 */

SET @locDKSLocal = "http://localhost/klw/dks_desarrollo";  /* Para el DKS local (el que se esta instalando). La localizacion @locSelfService  debe ser la url de instalacion del servicio.  */ 
/*	SET @locDKSLocal = "http://www.ideando.net/klw/dks_desarrollo"; */ 
SET @locSelfService = @locDKSLocal;  /* este no se para que sirve  */

SET @locDKSLocal_ai_es = "http://localhost/klw/dks_desarrollo/lan_es";  
SET @locDKSLocal_ai_ing = "http://localhost/klw/dks_desarrollo/lan_ing";


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

SET @ordinalDeAlta_GENERICO = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_GENERICO*/
SET @tiemoDeAlta_GENERICO = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_GENERICO*/

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
	values
			/*  Concepto ventana de prueba ***********  */
			(1,"gen_ventana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto puerta de prueba ***********  */
			(2,"gen_puerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* Concepto casa de prueba ***********  */
			(3,"gen_casa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto mi ventana de prueba  ***********  */
			(4,"gen_miVentana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi puerta de prueba  ***********  */
			(5,"gen_miPuerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(6,"gen_miCasa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(7,"gen_musica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(8,"gen_amigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(9,"gen_datosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(10,"gen_mikiPrivacidadDeDatos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(11,"gen_mikiIdentidad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(12,"gen_mikiCurriculum",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(13,"gen_mikiHistorialMedico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(14,"gen_mikiMusica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(15,"gen_mikiAmigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(16,"gen_mikiDatosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*   Concepto mi casa de prueba  ***********  */
			(17,"gen_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),


			
			/* *****************  CONCEPTOS PARA TEST y pruebas  ******************
			/*   Concepto prueba_001 de prueba  ***********  */
			(18,"gen_prueba_001",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

			
			
			
			
			
/*    Ultimo identificador utilizado para esta tabla de arriba   17.  debes utilizar uno posterior para el siguiente registro (hemos saltado del 7 , por si quiero poner aqui el concepto de interfaz de usuario ) **********  */			
			
			
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
	/* Relaciones del concepto gen_casa  ***********  */
			(1,0,"gen_casa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",3,0),
				(2,1,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(3,2,"gen_ai_es_gen_casa",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1,1),
				(4,1,"gen_ventana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",1,1),
				(5,1,"gen_puerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,1),
	
	/* Relaciones del concepto gen_miPuerta  ***********  */
			(6,0,"gen_miPuerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
				(7,6,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(8,7,"gen_ai_es_gen_miPuerta",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,1),
				(9,6,"gen_puerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
	
	/* Relaciones del concepto gen_miVentana  ***********  */
			(10,0,"gen_miVentana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
				(11,10,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(12,11,"gen_ai_es_gen_miVentana",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,1),
				(13,10,"gen_ventana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",1,0),
	
	/* Relaciones del concepto gen_casa  ***********  */
			(14,0,"gen_miCasa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
				(15,14,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(16,15,"gen_ai_es_gen_miCasa",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,1),
				(17,14,"gen_casa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",3,0),
					(18,17,"gen_puerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
						(19,18,"gen_miPuerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,1),
					(20,17,"gen_ventana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",1,0),
						(21,20,"gen_miVentana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,1),

	/* Relaciones del concepto gen_ventana  ***********  */
			(22,0,"gen_ventana",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",1,0),
				(23,22,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(24,23,"gen_ai_es_gen_ventana",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,1),

	/* Relaciones del concepto gen_puerta  ***********  */
			(25,0,"gen_puerta",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(26,25,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(27,26,"gen_ai_es_gen_puerta",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,1),

	/*   OJOOOO el siguiente el 300  *** */
	/*    Ultimo identificador utilizado para esta tabla de arriba   300.  debes utilizar uno posterior para el siguiente registro (hemos saltado del 27 al 300 , por si quiero poner aqui el concepto de interfaz de usuario ) **********  */			
			
	/* Relaciones del concepto gen_musica  ***********  */
			(300,0,"gen_musica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",7,0),
				(301,300,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(302,301,"gen_ai_es_gen_musica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",9,1),

	/* Relaciones del concepto gen_amigos  ***********  */
			(303,0,"gen_amigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				(304,303,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(305,304,"gen_ai_es_gen_amigos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,1),

	/* Relaciones del concepto gen_datosLudicos  ***********  */
			(306,0,"gen_datosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",9,0),
				(307,306,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(308,307,"gen_ai_es_gen_datosLudicos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,1),

	/* Relaciones del concepto gen_mikiPrivacidadDeDatos  ***********  */
			(309,0,"gen_mikiPrivacidadDeDatos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",10,0),
				(310,309,"gen_PrivacidadDeDatos",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",56,0),
				(311,309,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(312,311,"gen_ai_es_gen_mikiPrivacidadDeDatos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,1),

	/* Relaciones del concepto gen_mikiIdentidad  ***********  */
			(313,0,"gen_mikiIdentidad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",11,0),
				(314,313,"gen_identidad",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",53,0),
				(315,313,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(316,315,"gen_ai_es_gen_mikiIdentidad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,1),

	/* Relaciones del concepto gen_mikiCurriculum  ***********  */
			(317,0,"gen_mikiCurriculum",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",12,0),
				(318,317,"gen_curriculum",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",55,0),
				(319,317,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(320,319,"gen_ai_es_gen_mikiCurriculum",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,1),

	/* Relaciones del concepto gen_mikiHistorialMedico  ***********  */
			(321,0,"gen_mikiHistorialMedico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",13,0),
				(322,321,"gen_historialMedico",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",54,0),
				(323,321,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(324,323,"gen_ai_es_gen_mikiHistorialMedico",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,1),

	/* Relaciones del concepto gen_mikiMusica  ***********  */
			(325,0,"gen_mikiMusica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",14,0),
				(326,325,"gen_musica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",7,0),
				(327,325,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(328,327,"gen_ai_es_gen_mikiMusica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,1),
					
	/* Relaciones del concepto gen_mikiAmigos  ***********  */
			(329,0,"gen_mikiAmigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",15,0),
				(330,329,"gen_amigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				(331,329,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(332,331,"gen_ai_es_gen_mikiAmigos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,1),
					
	/* Relaciones del concepto gen_mikiDatosLudicos  ***********  */
			(333,0,"gen_mikiDatosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,0),
				(334,333,"gen_datosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",9,0),
					(335,334,"gen_musica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",7,0),
						(336,335,"gen_mikiMusica",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",14,1),
					(337,334,"gen_amigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
						(338,337,"gen_mikiAmigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",15,1),
				(339,333,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(340,339,"gen_ai_es_gen_mikiDatosLudicos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,1),

	/* Relaciones del concepto gen_miki  ***********  */
			(341,0,"gen_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",17,0),
				(342,341,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(343,342,"gen_ai_es_gen_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,1),
				(344,341,"gen_identidad",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",55,0),
					(345,344,"gen_mikiIdentidad",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",11,0),
				(346,341,"gen_curriculum",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",55,0),
					(347,346,"gen_mikiCurriculum",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",12,0),
				(348,341,"gen_datosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",9,0),
					(349,348,"gen_mikiDatosLudicos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,0),
				(350,341,"gen_historialMedico",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",55,0),
					(351,350,"gen_mikiHistorialMedico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",12,0),
				(352,341,"gen_casa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",3,0),
					(353,352,"gen_miCasa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
				(354,341,"gen_PrivacidadDeDatos",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",56,0),
					(355,354,"gen_mikiPrivacidadDeDatos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",10,0),


			/* *****************  CONCEPTOS PARA TEST y pruebas  ******************
			/*   Concepto prueba_001 de prueba  ***********  */

	/* Relaciones del concepto gen_prueba_001  ***********  */
			(356,0,"gen_prueba_001",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",18,0),
				(357,356,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(358,357,"gen_ai_es_gen_prueba_001",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,1),
					
				(359,356,"gen_miki",@locDKSLocal,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,1,"",17,1),
				(360,356,"gen_miCasa",@locDKSLocal,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,1,"",6,1),

				(361,356,"gen_curriculum",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",55,0),
					(362,361,"gen_mikiCurriculum",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",12,1),
					(363,361,"gen_miCasa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,1),
					
					(364,361,"gen_amigos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
						(365,364,"gen_miki",@locDKSLocal,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,1,"",17,1),
						(366,364,"gen_miki",@locDKSLocal,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,1,"",17,1),
						(367,364,"gen_miki",@locDKSLocal,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,1,"",17,1),

						(368,364,"gen_casa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",3,0),
							(369,368,"gen_miCasa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,1),
							
					(370,361,"gen_st_ejemplo01_01",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",1,2),
							
					(371,361,"gen_st_ejemplo01_02",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,2),
							

				(372,356,"gen_st_ejemplo01_03",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",3,2),

				(373,356,"gen_st_ejemplo01_04",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,2);
				
/*    Ultimo identificador utilizado para esta tabla de arriba   355.  debes utilizar uno posterior para el siguiente registro  **********  */			
					
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

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
		(1,"gen_st_ejemplo01_01","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contenido concepto sin techo ejemplo_01_01","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(2,"gen_st_ejemplo01_02","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,22,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(3,"gen_st_ejemplo01_03","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contenido concepto sin techo ejemplo_01_03","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(4,"gen_st_ejemplo01_04","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,4444,"gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

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

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `usr_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			/*  Concepto de principio o genesis (reside en generickDKS)  ***********  */
			(1,"gen_usuario_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(7,"gen_interfazKee_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   300.  debes utilizar uno posterior para el siguiente registro (hemos saltado del 7 al 300 , por si quiero poner aqui el concepto de interfaz de usuario ) **********  */			

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

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `usr_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values 	
			/*  **  Descripcion del usuario gen_usuario_miki (miki)   ** */
			(1,0,"gen_usuario_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1,0),
				(2,1,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(3,2,"gen_ai_es_gen_usuario_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,1),
				(5,1,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(4,5,"gen_usuarioAdministrador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"usr_",1,0),
					(6,5,"gen_nombreUsuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
							(7,6,"gen_st_gen_nombreUsuario_miki","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"usr_",2,2),
					(8,5,"gen_paswordUsuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
						(9,8,"gen_st_gen_paswordUsuario_miki","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"usr_",3,2),
					(10,5,"gen_interfazKee",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",47,0),
						(11,10,"gen_interfazKee_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",7,1),
				/*  **  Debe incluirse una referencia a la persona mediante la instancia correspondiente para indicar quien es el responsable del usuario *** */

			/*  ****  OJO, empezamos por el 28 y tenemos reservado hasta el 300, por si lo pasamos a la tabla de conceptos normal ** */
			/* Relaciones del concepto de ayuda a interfaz generico sin idioma asociado  *** el concepto de ayuda a interfaz tiene tambien su ayuda a interfaz, como debe ser ********  */
			(28,0,"gen_interfazKee_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",7,0),
				(29,28,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(30,29,"gen_ai_es_gen_interfazKee_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,1),
				(42,28,"gen_configuracionDeAcceso",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",43,0),
				
					(45,42,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",59,0),
						(46,45,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
							(47,46,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
								(48,47,"gen_st_gen_ordinal_48","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",4,2),
							(49,46,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",3,1),
						(50,45,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
							(51,50,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
								(52,51,"gen_st_gen_ordinal_52","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",5,2),
							(53,50,"gen_idioma_ingles",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",4,1),
				
				(31,28,"gen_interfazKee",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",47,0),
					(32,31,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
						(33,32,"gen_listaEntornos",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",48,0),
							(34,33,"gen_entornoDeTrabajoKee",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",48,0),
								(35,34,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
									(36,35,"gen_st_gen_identificadorEntornoMiki001","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1,2),
								(37,34,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
									(38,37,"gen_listaRequerimientosKEE",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",50,0),
								(39,34,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
									(40,39,"gen_ListaConceptosPresentes",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",52,0),
										(41,40,"gen_miCasa",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,1),
					(43,31,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,0),
						(44,43,"gen_usuario_miki",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1,1);

/*    Ultimo identificador utilizado para esta tabla de arriba   44 debes utilizar uno posterior para el siguiente registro OJOO  a partir del 1000 tambien estan ocupados **********  */			
						
/*  Introducimos las relaciones de los Conceptos de usuario ***********  */
/*  Conceptos  para DKS BASICO ***********  */
insert  into `usr_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	/* Descripcion del usuario Administrador (creado por defecto) */
			(1000,0,"gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1000,0),
				(1001,1000,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(1002,1001,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,1),
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

/*  Conceptos datos (sin techo) de la familia de datos de usuarios  para este DKS especifico ***********  */
insert  into `usr_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos sin techo de   gen_st_gen_identificadorEntornoMiki001*/
			(1,"gen_st_gen_identificadorEntornoMiki001","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identificador de entorno de usuario 001 de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_st_gen_nombreUsuario_miki","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"miki","gen_nombreUsuario",@localizacionGenericDKS,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_gen_paswordUsuario_miki","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta, CONCAT('*', UPPER(SHA1(UNHEX(SHA1('1miki1'))))),"gen_paswordUsuario",@localizacionGenericDKS,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(4,"gen_st_gen_ordinal_48","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"1","gen_numero",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_gen_ordinal_52","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"2","gen_numero",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
/*  Conceptos basicos para DKS generico ***********  */

/*  Conceptos para DKS BASICO ***********  */
insert  into `usr_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos sin techo de   gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_gen_nombreUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"administrador","gen_nombreUsuario",@localizacionGenericDKS,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_gen_paswordUsuarioAdministradorLocal1","usr_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta, CONCAT('*', UPPER(SHA1(UNHEX(SHA1('1admin1'))))),"gen_paswordUsuario",@localizacionGenericDKS,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
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
/*insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`); */
/*  *********************  FIN Tablas de RESTRICCIONES_ACCESO  ************************************** */

/*   1.1.5
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (ACTUALIZACIONES) *******************
*************************************************    */

/*  *********************  INICIO Tablas de ACTUALIZACIONES  ************************************** */
/* Conceptos de familia conceptos preteritos contiene las versiones anteriores de los conceptos y los cambios necesarios para regenerar versiones antiguas */
/*insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`); */
/*  *********************  FIN Tablas de MODIFICACIONES  ************************************** */

/*   1.1.6
*************************************************
*******  TABLAS ESPECIFICAS DE VERTICE (CACHE_DE_EXTERNOS) *******************
*************************************************    */

/*  *********************  INICIO Tablas de CACHE_DE_EXTERNOS  ************************************** */
/* Conceptos de familia conceptos cache de externos contiene copia de los conceptos externos */
/* insert  into `CONCEPTOS_famILIAS`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) values (2,`ayudaInterfaz`,`Localizacion`,1,`0`,`ClaveUsuario`,`LocalizacionUsuario`,`NA`); */
	/*
	Los conceptos aqui almacenados no deben ser modificados, ya que son copia del original que se encuentra en la fuente del concepto
	Solo deben ser de uso privado, para DKS privados, Servidor personal , de empresa u otros
	Deben poder ir marcados como copia autorizada y con un identificador que garantiza su derecho de uso y modelo de divulgacion
	*/
/*  *********************  FIN Tablas de CACHE_DE_EXTERNOS  ************************************** */

/*  ********************************   INICIO TABLAS DE IDIOMAS PARA AYUDA A INTERFAZ  (una por cada idioma) ********************************* */
	
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
			(1,"gen_ai_es_gen_casa",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_ai_es_gen_miPuerta",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_ai_es_gen_miVentana",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(4,"gen_ai_es_gen_miCasa",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_ai_es_gen_ventana",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_ai_es_gen_puerta",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(7,"gen_ai_es_gen_interfazKee_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(8,"gen_ai_es_gen_usuario_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(9,"gen_ai_es_gen_musica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(10,"gen_ai_es_gen_amigos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_ai_es_gen_datosLudicos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_ai_es_gen_mikiPrivacidadDeDatos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(13,"gen_ai_es_gen_mikiIdentidad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(14,"gen_ai_es_gen_mikiCurriculum",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(15,"gen_ai_es_gen_mikiHistorialMedico",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(16,"gen_ai_es_gen_mikiMusica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_ai_es_gen_mikiAmigos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(18,"gen_ai_es_gen_mikiDatosLudicos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(19,"gen_ai_es_gen_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(20,"gen_ai_es_gen_prueba_001",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

			
/*    Ultimo identificador utilizado para esta tabla de arriba   20.  debes utilizar uno posterior para el siguiente registro **********  */			

			/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
			(1000,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			/*  todos los registros asociados a gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1 estan puestos en este DKS, sin probarlos 
			Pero por ahora no los he puesto en los otros DKS  */

			
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

/*  Conceptos de ayuda a interfaz  en español ***********  */
insert  into `ai_es_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values
		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_casa  ***********  */
			(1,0,"gen_ai_es_gen_casa",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1,0),
				/* nombre */
			(2,1,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(3,2,"gen_st_nombreConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1,2),
				/* descripcion */
			(4,1,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(5,4,"gen_st_descripcionConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,2),
				/* rotulo */
			(6,1,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(7,6,"gen_st_rotuloConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(43,1,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(44,43,"gen_st_iconoImagenConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(45,1,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(46,45,"gen_st_iconoAudioConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(47,1,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(48,47,"gen_st_imagenConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",21,2),
			
			(107,1,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(108,107,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

				/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_miPuerta  ***********  */
			(8,0,"gen_ai_es_gen_miPuerta",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,0),
				/* nombre */
			(9,8,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(10,9,"gen_st_nombreConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,2),
				/* descripcion */
			(11,8,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(12,11,"gen_st_descripcionConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,2),
				/* rotulo */
			(13,8,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(14,13,"gen_st_rotuloConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(49,8,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(50,49,"gen_st_iconoImagenConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",22,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(51,8,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(52,51,"gen_st_iconoAudioConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",23,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(53,8,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(54,53,"gen_st_imagenConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",24,2),
			
			(109,8,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(110,109,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_miVentana  ***********  */
			(15,0,"gen_ai_es_gen_miVentana",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,0),
				/* nombre */
			(16,15,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(17,16,"gen_st_nombreConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,2),
				/* descripcion */
			(18,15,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(19,18,"gen_st_descripcionConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",8,2),
				/* rotulo */
			(20,15,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(21,20,"gen_st_rotuloConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",9,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(55,15,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(56,55,"gen_st_iconoImagenConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",25,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(57,15,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(58,57,"gen_st_iconoAudioConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",26,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(59,15,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(60,59,"gen_st_imagenConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",27,2),
			
			(111,15,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(112,111,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_miCasa  ***********  */
			(22,0,"gen_ai_es_gen_miCasa",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,0),
				/* nombre */
			(23,22,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(24,23,"gen_st_nombreConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,2),
				/* descripcion */
			(25,22,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(26,25,"gen_st_descripcionConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,2),
				/* rotulo */
			(27,22,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(28,27,"gen_st_rotuloConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(61,22,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(62,61,"gen_st_iconoImagenConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",28,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(63,22,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(64,63,"gen_st_iconoAudioConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",29,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(65,22,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(66,65,"gen_st_imagenConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",30,2),

			(105,22,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(106,105,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
				
		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_ventana  ***********  */
			(29,0,"gen_ai_es_gen_ventana",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,0),
				/* nombre */
			(30,29,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(31,30,"gen_st_nombreConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,2),
				/* descripcion */
			(32,29,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(33,32,"gen_st_descripcionConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,2),
				/* rotulo */
			(34,29,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(35,34,"gen_st_rotuloConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(67,29,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(68,67,"gen_st_iconoImagenConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",31,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(69,29,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(70,69,"gen_st_iconoAudioConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",32,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(71,29,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(72,71,"gen_st_imagenConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",33,2),
			
			(113,29,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(114,113,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_puerta  ***********  */
			(36,0,"gen_ai_es_gen_puerta",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,0),
				/* nombre */
			(37,36,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(38,37,"gen_st_nombreConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,2),
				/* descripcion */
			(39,36,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(40,39,"gen_st_descripcionConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,2),
				/* rotulo */
			(41,36,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(42,41,"gen_st_rotuloConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(73,36,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
			(74,73,"gen_st_iconoImagenConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",34,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(75,36,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
			(76,75,"gen_st_iconoAudioConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",35,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(77,36,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
			(78,77,"gen_st_imagenConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",36,2),
			
			(115,36,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(116,115,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_interfazKee_miki  ***********  */
			(79,0,"gen_ai_es_gen_interfazKee_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,0),
					/* nombre */
				(80,79,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(81,80,"gen_st_nombreConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",37,2),
					/* descripcion */
				(82,79,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(83,82,"gen_st_descripcionConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",38,2),
					/* rotulo */
				(84,79,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(85,84,"gen_st_rotuloConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",39,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(86,79,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(87,86,"gen_st_iconoImagenConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",40,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(88,79,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(89,88,"gen_st_iconoAudioConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",41,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(90,79,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(91,90,"gen_st_imagenConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,2),

				(117,79,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(118,117,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_usuario_miki  ***********  */
			(92,0,"gen_ai_es_gen_usuario_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",8,0),
					/* nombre */
				(93,92,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(94,93,"gen_st_nombreConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",43,2),
					/* descripcion */
				(95,92,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(96,95,"gen_st_descripcionConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",44,2),
					/* rotulo */
				(97,92,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(98,97,"gen_st_rotuloConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",45,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(99,92,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(100,99,"gen_st_iconoImagenConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",46,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(101,92,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(102,101,"gen_st_iconoAudioConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",47,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(103,92,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(104,103,"gen_st_imagenConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",48,2),

				(119,92,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(120,119,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_musica  ***********  */
			(121,0,"gen_ai_es_gen_musica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",9,0),
					/* Ayuda a interfaz */
				(122,121,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(123,122,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(124,121,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(125,124,"gen_st_nombreConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",49,2),
					/* descripcion */
				(126,121,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(127,126,"gen_st_descripcionConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",50,2),
					/* rotulo */
				(128,121,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(129,128,"gen_st_rotuloConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",51,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(130,121,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(131,130,"gen_st_iconoImagenConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",52,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(132,121,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(133,132,"gen_st_iconoAudioConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",53,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(134,121,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(135,134,"gen_st_imagenConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",54,2),
					
		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_amigos  ***********  */
			(136,0,"gen_ai_es_gen_amigos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,0),
					/* Ayuda a interfaz */
				(137,136,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(138,137,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(139,136,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(140,139,"gen_st_nombreConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,2),
					/* descripcion */
				(141,136,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(142,141,"gen_st_descripcionConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",56,2),
					/* rotulo */
				(143,136,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(144,143,"gen_st_rotuloConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",57,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(145,136,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(146,145,"gen_st_iconoImagenConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",58,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(147,136,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(148,147,"gen_st_iconoAudioConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",59,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(149,136,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(150,149,"gen_st_imagenConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",60,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_datosLudicos  ***********  */
			(151,0,"gen_ai_es_gen_datosLudicos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,0),
					/* Ayuda a interfaz */
				(152,151,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(153,152,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(154,151,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(155,154,"gen_st_nombreConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",61,2),
					/* descripcion */
				(156,151,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(157,156,"gen_st_descripcionConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",62,2),
					/* rotulo */
				(158,151,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(159,158,"gen_st_rotuloConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",63,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(160,151,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(161,160,"gen_st_iconoImagenConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",64,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(162,151,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(163,162,"gen_st_iconoAudioConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",65,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(164,151,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(165,164,"gen_st_imagenConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",66,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiPrivacidadDeDatos  ***********  */
			(166,0,"gen_ai_es_gen_mikiPrivacidadDeDatos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,0),
					/* Ayuda a interfaz */
				(167,166,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(168,167,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(169,166,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(170,169,"gen_st_nombreConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",67,2),
					/* descripcion */
				(171,166,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(172,171,"gen_st_descripcionConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",68,2),
					/* rotulo */
				(173,166,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(174,173,"gen_st_rotuloConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",69,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(175,166,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(176,175,"gen_st_iconoImagenConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",70,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(177,166,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(178,177,"gen_st_iconoAudioConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",71,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(179,166,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(180,179,"gen_st_imagenConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",72,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiIdentidad  ***********  */
			(181,0,"gen_ai_es_gen_mikiIdentidad",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,0),
					/* Ayuda a interfaz */
				(182,181,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(183,182,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(184,181,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(185,184,"gen_st_nombreConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",73,2),
					/* descripcion */
				(186,181,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(187,186,"gen_st_descripcionConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",74,2),
					/* rotulo */
				(188,181,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(189,188,"gen_st_rotuloConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",75,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(190,181,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(191,190,"gen_st_iconoImagenConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",76,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(192,181,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(193,192,"gen_st_iconoAudioConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",77,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(194,181,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(195,194,"gen_st_imagenConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",78,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiCurriculum  ***********  */
			(196,0,"gen_ai_es_gen_mikiCurriculum",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,0),
					/* Ayuda a interfaz */
				(197,196,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(198,197,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(199,196,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(200,199,"gen_st_nombreConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",79,2),
					/* descripcion */
				(201,196,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(202,201,"gen_st_descripcionConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",80,2),
					/* rotulo */
				(203,196,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(204,203,"gen_st_rotuloConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",81,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(205,196,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(206,205,"gen_st_iconoImagenConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",82,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(207,196,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(208,207,"gen_st_iconoAudioConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",83,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(209,196,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(210,209,"gen_st_imagenConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",84,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiHistorialMedico  ***********  */
			(211,0,"gen_ai_es_gen_mikiHistorialMedico",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,0),
					/* Ayuda a interfaz */
				(212,211,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(213,212,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(214,211,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(215,214,"gen_st_nombreConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",85,2),
					/* descripcion */
				(216,211,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(217,216,"gen_st_descripcionConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",86,2),
					/* rotulo */
				(218,211,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(219,218,"gen_st_rotuloConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",87,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(220,211,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(221,220,"gen_st_iconoImagenConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",88,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(222,211,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(223,222,"gen_st_iconoAudioConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",89,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(224,211,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(225,224,"gen_st_imagenConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",90,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiMusica  ***********  */
			(226,0,"gen_ai_es_gen_mikiMusica",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,0),
					/* Ayuda a interfaz */
				(227,226,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(228,227,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(229,226,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(230,229,"gen_st_nombreConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",91,2),
					/* descripcion */
				(231,226,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(232,231,"gen_st_descripcionConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",92,2),
					/* rotulo */
				(233,226,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(234,233,"gen_st_rotuloConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",93,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(235,226,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(236,235,"gen_st_iconoImagenConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",94,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(237,226,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(238,237,"gen_st_iconoAudioConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",95,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(239,226,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(240,239,"gen_st_imagenConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",96,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiAmigos  ***********  */
			(241,0,"gen_ai_es_gen_mikiAmigos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,0),
					/* Ayuda a interfaz */
				(242,241,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(243,242,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(244,241,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(245,244,"gen_st_nombreConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",97,2),
					/* descripcion */
				(246,241,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(247,246,"gen_st_descripcionConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",98,2),
					/* rotulo */
				(248,241,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(249,248,"gen_st_rotuloConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",99,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(250,241,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(251,250,"gen_st_iconoImagenConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",100,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(252,241,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(253,252,"gen_st_iconoAudioConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",101,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(254,241,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(255,254,"gen_st_imagenConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",102,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_mikiDatosLudicos  ***********  */
			(256,0,"gen_ai_es_gen_mikiDatosLudicos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,0),
					/* Ayuda a interfaz */
				(257,256,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(258,257,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(259,256,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(260,259,"gen_st_nombreConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",103,2),
					/* descripcion */
				(261,256,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(262,261,"gen_st_descripcionConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",104,2),
					/* rotulo */
				(263,256,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(264,263,"gen_st_rotuloConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",105,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(265,256,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(266,265,"gen_st_iconoImagenConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",106,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(267,256,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(268,267,"gen_st_iconoAudioConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",107,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(269,256,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(270,269,"gen_st_imagenConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",108,2),

		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_miki  ***********  */
			(271,0,"gen_ai_es_gen_miki",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,0),
					/* Ayuda a interfaz */
				(272,271,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(273,272,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(274,271,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(275,274,"gen_st_nombreConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",109,2),
					/* descripcion */
				(276,271,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(277,276,"gen_st_descripcionConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",110,2),
					/* rotulo */
				(278,271,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(279,278,"gen_st_rotuloConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",111,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(280,271,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(281,280,"gen_st_iconoImagenConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",112,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(282,271,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(283,282,"gen_st_iconoAudioConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",113,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(284,271,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(285,284,"gen_st_imagenConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",114,2),
					



		/*  ***********************  Para conceptos de prueba  ******************************** /*
		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_miki  ***********  */
			(286,0,"gen_ai_es_gen_prueba_001",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,0),
					/* Ayuda a interfaz */
				(287,286,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(288,287,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
				(289,286,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(290,289,"gen_st_nombreConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",109,2),
					/* descripcion */
				(291,286,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(292,291,"gen_st_descripcionConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",110,2),
					/* rotulo */
				(293,286,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(294,293,"gen_st_rotuloConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",111,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(295,286,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(296,295,"gen_st_iconoImagenConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",112,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(297,286,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(298,297,"gen_st_iconoAudioConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",113,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(299,286,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(300,299,"gen_st_imagenConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",114,2);
					
					
/*    Ultimo identificador utilizado para esta tabla de arriba   300, debes utilizar uno posterior para el siguiente registro. OJOO a partir del 1000, tambien esta ocupado  **********  */			
	
/*  Conceptos  para DKS BASICO ***********  */
insert  into `ai_es_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	
	/* Relaciones de ayuda interfaz del concepto gen_usuarioAdministradorLocal1  ***********  */
			(1000,0,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,0),
		/* nombre */
			(1001,1000,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
			(1002,1001,"gen_st_nombreUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,2),
		/* descripcion */
			(1003,1000,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
			(1004,1003,"gen_st_descripcionUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1001,2),
		/* rotulo */
			(1005,1000,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
			(1006,1005,"gen_st_rotuloUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1002,2),
			
			(1007,1000,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(1008,1007,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
				
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1  ***********  */
		(1009,0,"gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,0),
				/* nombre */
			(1010,1009,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
				(1011,1010,"gen_st_nombreConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",115,2),
				/* descripcion */
			(1012,1009,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
				(1013,1012,"gen_st_descripcionConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",116,2),
				/* rotulo */
			(1014,1009,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
				(1015,1014,"gen_st_rotuloConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",117,2),
				/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1016,1009,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(1017,1016,"gen_st_iconoImagenConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",118,2),
				/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1018,1009,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(1019,1018,"gen_st_iconoAudioConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",119,2),
				/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1020,1009,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(1021,1020,"gen_st_imagenConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",120,2),

			(1022,1009,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
				(1023,1022,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1);

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
			/* datos de   gen_ai_es_gen_casa */
			(1,"gen_st_nombreConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Casa -nombre-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_st_descripcionConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Casa generica. Casa -descripcion-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_rotuloConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Casa -rotulo-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(19,"gen_st_iconoImagenConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgCasa.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(20,"gen_st_iconoAudioConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioCasa.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(21,"gen_st_imagenConcepto_gen_casa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenCasa.gif","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   gen_ai_es_gen_miPuerta*/
			(4,"gen_st_nombreConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi puerta -nombre-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_descripcionConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi puerta -descripcion-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_rotuloConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi puerta -rotulo-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(22,"gen_st_iconoImagenConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMiPuerta.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(23,"gen_st_iconoAudioConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMiPuerta.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(24,"gen_st_imagenConcepto_gen_miPuerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MiPuerta.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   gen_ai_es_gen_miVentana*/
			(7,"gen_st_nombreConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi ventana -nombre-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(8,"gen_st_descripcionConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi ventana -descripcion-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(9,"gen_st_rotuloConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi ventana -rotulo-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(25,"gen_st_iconoImagenConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMiVentana.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(26,"gen_st_iconoAudioConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMiVentana.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(27,"gen_st_imagenConcepto_gen_miVentana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MiVentana.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   gen_ai_es_gen_ai_es_gen_miCasa*/
			(10,"gen_st_nombreConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi Casa -nombre-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_st_descripcionConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi Casa -descripcion-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_st_rotuloConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Mi Casa -rotulo-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(28,"gen_st_iconoImagenConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgMiCasa.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(29,"gen_st_iconoAudioConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMiCasa.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(30,"gen_st_imagenConcepto_gen_miCasa","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MiCasa.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   gen_ai_es_gen_ventana*/
			(13,"gen_st_nombreConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ventana -nombre-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(14,"gen_st_descripcionConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ventana -descripcion-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(15,"gen_st_rotuloConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Ventana -rotulo-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(31,"gen_st_iconoImagenConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgVentana.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_st_iconoAudioConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioVentana.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_st_imagenConcepto_gen_ventana","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Ventana.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   gen_ai_es_gen_puerta*/
			(16,"gen_st_nombreConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Puerta -nombre-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_st_descripcionConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Puerta -descripcion-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(18,"gen_st_rotuloConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Puerta -rotulo-","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(34,"gen_st_iconoImagenConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPuerta.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(35,"gen_st_iconoAudioConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPuerta.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(36,"gen_st_imagenConcepto_gen_puerta","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_puerta.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_interfazKee_miki */
			(37,"gen_st_nombreConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Interfaz Kee de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(38,"gen_st_descripcionConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene la configuracion de la interfaz de usuario de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(39,"gen_st_rotuloConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Interfaz Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(40,"gen_st_iconoImagenConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgInterfazKee_miki.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(41,"gen_st_iconoAudioConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioInterfazKee_miki.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(42,"gen_st_imagenConcepto_gen_interfazKee_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_interfazKee_miki.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_usuario_miki */
			(43,"gen_st_nombreConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(44,"gen_st_descripcionConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene la informacion del usuario miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(45,"gen_st_rotuloConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usuario Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(46,"gen_st_iconoImagenConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgUsuarioMiki.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(47,"gen_st_iconoAudioConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioUsuarioMiki.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(48,"gen_st_imagenConcepto_gen_usuario_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_usuarioMiki.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_musica */
			(49,"gen_st_nombreConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Musica","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(50,"gen_st_descripcionConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion musical","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(51,"gen_st_rotuloConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Musica","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(52,"gen_st_iconoImagenConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMusica.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(53,"gen_st_iconoAudioConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMusica.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(54,"gen_st_imagenConcepto_gen_musica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Musica.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_amigos */
			(55,"gen_st_nombreConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Amigos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(56,"gen_st_descripcionConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre amigos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(57,"gen_st_rotuloConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Amigos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(58,"gen_st_iconoImagenConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgAmigos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(59,"gen_st_iconoAudioConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioAmigos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(60,"gen_st_imagenConcepto_gen_amigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Amigos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_datosLudicos */
			(61,"gen_st_nombreConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Datos ludicos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(62,"gen_st_descripcionConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion aficiones y gustos de un usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(63,"gen_st_rotuloConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Datos Ludicos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(64,"gen_st_iconoImagenConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgDatosLudicos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(65,"gen_st_iconoAudioConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioDatosLudicos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(66,"gen_st_imagenConcepto_gen_datosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_DatosLudicos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiPrivacidadDeDatos */
			(67,"gen_st_nombreConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Privacidad de datos de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(68,"gen_st_descripcionConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre la privacidad de datos de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(69,"gen_st_rotuloConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Privacidad de datos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(70,"gen_st_iconoImagenConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiPrivacidadDeDatos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(71,"gen_st_iconoAudioConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiPrivacidadDeDatos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(72,"gen_st_imagenConcepto_gen_mikiPrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiPrivacidadDeDatos.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiIdentidad*/
			(73,"gen_st_nombreConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Identidad Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(74,"gen_st_descripcionConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre la identidad miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(75,"gen_st_rotuloConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Identidad","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(76,"gen_st_iconoImagenConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiIdentidad.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(77,"gen_st_iconoAudioConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiIdentidad.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(78,"gen_st_imagenConcepto_gen_mikiIdentidad","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiIdentidad.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiCurriculum*/
			(79,"gen_st_nombreConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Curriculum de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(80,"gen_st_descripcionConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre el curriculum de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(81,"gen_st_rotuloConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Curriculum","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(82,"gen_st_iconoImagenConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiCurriculum.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(83,"gen_st_iconoAudioConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiCurriculum.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(84,"gen_st_imagenConcepto_gen_mikiCurriculum","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiCurriculum.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiHistorialMedico*/
			(85,"gen_st_nombreConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Historial medico de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(86,"gen_st_descripcionConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre del historial medico de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(87,"gen_st_rotuloConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Historial Medico","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(88,"gen_st_iconoImagenConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiHistorialMedico.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(89,"gen_st_iconoAudioConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiHistorialMedico.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(90,"gen_st_imagenConcepto_gen_mikiHistorialMedico","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiHistorialMedico.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiMusica*/
			(91,"gen_st_nombreConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Gustos musicales de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(92,"gen_st_descripcionConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre los gustos musicales de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(93,"gen_st_rotuloConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Musica","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(94,"gen_st_iconoImagenConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiMusica.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(95,"gen_st_iconoAudioConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiMusica.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(96,"gen_st_imagenConcepto_gen_mikiMusica","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiMusica.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiAmigos*/
			(97,"gen_st_nombreConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Amigos de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(98,"gen_st_descripcionConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre los amigos de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(99,"gen_st_rotuloConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Amigos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(100,"gen_st_iconoImagenConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiAmigos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(101,"gen_st_iconoAudioConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiAmigos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(102,"gen_st_imagenConcepto_gen_mikiAmigos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiAmigos.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_mikiDatosLudicos*/
			(103,"gen_st_nombreConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Datos ludicos de Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(104,"gen_st_descripcionConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre los gustos y aficiones de miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(105,"gen_st_rotuloConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: Datos ludicos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(106,"gen_st_iconoImagenConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMikiDatosLudicos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(107,"gen_st_iconoAudioConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMikiDatosLudicos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(108,"gen_st_imagenConcepto_gen_mikiDatosLudicos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_MikiDatosLudicos.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_miki*/
			(109,"gen_st_nombreConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(110,"gen_st_descripcionConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre miki","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(111,"gen_st_rotuloConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Miki: ","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(112,"gen_st_iconoImagenConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgMiki.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(113,"gen_st_iconoAudioConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioMiki.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(114,"gen_st_imagenConcepto_gen_miki","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Miki.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),


			/*  ***********************  Para conceptos de prueba  ******************************** /*
			/* datos de   gen_ai_es_gen_prueba_001*/
			(115,"gen_st_nombreConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"prueba_001","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(116,"gen_st_descripcionConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene informacion sobre prueba_001","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(117,"gen_st_rotuloConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Rotulo prueba_001: ","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(118,"gen_st_iconoImagenConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgTex.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(119,"gen_st_iconoAudioConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(120,"gen_st_imagenConcepto_gen_prueba_001","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_pruebas.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

			
/*    Ultimo identificador utilizado para esta tabla de arriba   120, debes utilizar uno posterior para el siguiente registro. OJOO a partir del 1000, tambien esta ocupado  **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos de   gen_ai_es_gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_nombreUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_descripcionUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el usuario que genera por defecto al generar la BBDD de una aplicacion DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_rotuloUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1 */
			(1003,"gen_st_nombreConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Interfaz Kee de Administrador Local 1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1004,"gen_st_descripcionConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Contiene la configuracion de la interfaz de usuario de  Administrador Local 1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1005,"gen_st_rotuloConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Interfaz  Administrador Local 1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1006,"gen_st_iconoImagenConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgInterfazKee_AdministradorLocal1.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1007,"gen_st_iconoAudioConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioInterfazKee_AdministradorLocal1.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1008,"gen_st_imagenConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_interfazKee_AdministradorLocal1.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			

			/*  *********************  FIN Tablas de ai_es_conceptos  ************************************** */

/*  ******************************************   FIN TABLAS DE IDIOMAS PARA AYUDA A INTERFAZ  ********************************* */
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
