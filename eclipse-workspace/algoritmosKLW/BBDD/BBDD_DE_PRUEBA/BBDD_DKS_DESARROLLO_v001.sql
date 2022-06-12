

/* la base de datos tiene que estar dada de alta */
CREATE DATABASE IF NOT EXISTS dos_dksdesarrollo CHARSET = utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `dos_dksdesarrollo`;  /* Aqui se identifica la base de datos  */

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


/* Usuarios para el alta inicial */
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


/*  
*********************  INICIO Tablas de conceptos  ************************************** */
/* Creamos la tabla principal de conceptos. Almacena  la tabla de declaracion de los conceptos  */
DROP TABLE IF EXISTS `conceptos`;

CREATE TABLE `conceptos` (
  `IdConcepto` bigint(255) unsigned NOT NULL auto_increment,  /* Identificador de concepto */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,
  PRIMARY KEY  (`IdConcepto`),
  KEY `Clave` (`Clave`)
); 

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `conceptos`(`IdConcepto`,`Clave`,`Localizacion`) 
	values
			/* *****************  CONCEPTOS PARA TEST y pruebas  ******************
			/*   Concepto prueba_001 de prueba  ***********  */
			(18,"gen_prueba_001",@locDKSLocal);

			
/* Creamos la tabla principal de conceptos_conceptos. Almacena la descripcion del arbol definicion de cada concepto*/
DROP TABLE IF EXISTS `conceptos_conceptos`;

CREATE TABLE `conceptos_conceptos` (
  `IdRel` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de relacion de concepto_concepto */
  `IdRelPadre` bigint(255) unsigned NOT NULL, /* Es el padre en el arbol de descripcion. Si es cero, la entrada es la raiz de una descripcion */
  `ClaveHijo` varchar(255) NOT NULL, /* Clave del hijo. (En caso de que  corresponda a un sinTecho o tabla local, aqui se almacena el Idcst de la tabla correspondiente.*/  
  `LocalizacionHijo` varchar(255) NOT NULL, /* Localizacion del hijo. (En caso de que  corresponda a una tabla local, aqui se almacena el nombre de la tabla. LO SABEMOS PORQUE LA LOCALIZACION NO TENDRA PUNTOS */  
  `Localidad` int(2) NOT NULL default '1', /* Externo = 0, Interno = 1. Indica si el concepto reside en el DKS o en uno externo */
  `Familia` varchar(255), /* Indica la familia de datos a la que corresponde el concepto en el DKS Local. No tiene sentido en conceptos externos.*/  
  `IdEnTabla` bigint(255), /*  Indica el identificador dentro de la tabla en la que esta el concepto dentro del DKS. No tiene sentido en conceptos externos.*/  
  `InsRef` int(1) NOT NULL, /*   1 = Referencia ,  0 = Instancia  2=SinTecho*/
  PRIMARY KEY (`IdRel`)
); 

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`, `InsRef`) 
	values 

			/* *****************  CONCEPTOS PARA TEST y pruebas  ******************
			/*   Concepto prueba_001 de prueba  ***********  */

	/* Relaciones del concepto gen_prueba_001  ***********  */
			(356,0,"gen_prueba_001",@locDKSLocal,1,"",18,0),
				(357,356,"gen_ayudaInterfaz",@localizacion_DKS_KLW,0,"",2,0),
					(358,357,"gen_ai_es_gen_prueba_001",@locDKSLocal_ai_es,1,"ai_es_",20,1),
					
				(359,356,"gen_miki",@locDKSLocal,1,"",17,1),
				(360,356,"gen_miCasa",@locDKSLocal,1,"",6,1),

				(361,356,"gen_curriculum",@localizacionGenericDKS,0,"",55,0),
					(362,361,"gen_mikiCurriculum",@locDKSLocal,1,"",12,1),
					(363,361,"gen_miCasa",@locDKSLocal,1,"",6,1),
					
					(364,361,"gen_amigos",@locDKSLocal,1,"",8,0),
						(365,364,"gen_miki",@locDKSLocal,1,"",17,1),
						(366,364,"gen_miki",@locDKSLocal,1,"",17,1),
						(367,364,"gen_miki",@locDKSLocal,1,"",17,1),

						(368,364,"gen_casa",@locDKSLocal,1,"",3,0),
							(369,368,"gen_miCasa",@locDKSLocal,1,"",6,1),
							
					(370,361,"gen_st_ejemplo01_01",@locDKSLocal,1,"",1,2),
							
					(371,361,"gen_st_ejemplo01_02",@locDKSLocal,1,"",2,2),
							

				(372,356,"gen_st_ejemplo01_03",@locDKSLocal,1,"",3,2),

				(373,356,"gen_st_ejemplo01_04",@locDKSLocal,1,"",4,2),
				
					/*si cambiamos el orden sigue funcionando, se hace de forma ordenada y busca primero el 2*/
					(2,361,"gen_miCoche",@locDKSLocal,1,"",6,2);
				
/*    Ultimo identificador utilizado para esta tabla de arriba   355.  debes utilizar uno posterior para el siguiente registro  **********  */			
					
/* Creamos la tabla principal de conceptos_sin_techo. Almacena el dato de los conceptos que no tienen descripcion (numeros enteros, nombres, etc...)*/
DROP TABLE IF EXISTS `conceptos_sin_techo`;

CREATE TABLE `conceptos_sin_techo` (
  `Idcst` bigint(255) unsigned NOT NULL auto_increment, /* Identificador de concepto sinTecho */
  `Clave` varchar(255) NOT NULL,  /* OJOOO la clave debe ser distinta para todos los conceptos del mismo localizador */
  `Localizacion` varchar(255) NOT NULL,  /*  En esta tabla el localizador será la misma tabla y famoila, ya que por narices son locales */
  `Contenido` varchar(255), /* Ojo, en principio debe poder meterse cualquier cosa, un dato, la localizacion de un fichero. u otros */  
  /* El tipo de los datos de un sinTecho, puede cualificarse asociandolo a un concepto, en el que encontraremos informacion de como tratarlo, mostrarlo, etc... */
  `ClaveTipo` varchar(255) NOT NULL, /* Clave del Tipo del sinTecho*/    
  `OrdinalTipo` int(255) unsigned NOT NULL,
  PRIMARY KEY  (`Idcst`)
); 

/*  Conceptos basicos para este DKS especifico ***********  */
insert  into `conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Contenido`,`ClaveTipo`,`OrdinalTipo`) 
	values	
		(1,"gen_st_ejemplo01_01","conceptos_sin_techo","Contenido concepto sin techo ejemplo_01_01","gen_tipoDeSinTechoTextoPlano",@ordinalDeAlta_KLW),
		(2,"gen_st_ejemplo01_02","conceptos_sin_techo",22,"gen_tipoDeSinTecho_NumeroEntero",@ordinalDeAlta_KLW),
		(3,"gen_st_ejemplo01_03","conceptos_sin_techo","Contenido concepto sin techo ejemplo_01_03","gen_tipoDeSinTechoTextoPlano",@ordinalDeAlta_KLW),
		(4,"gen_st_ejemplo01_04","conceptos_sin_techo",4444,"gen_tipoDeSinTecho_NumeroEntero",@ordinalDeAlta_KLW);

/*  *********************  FIN Tablas de conceptos  ************************************** */
