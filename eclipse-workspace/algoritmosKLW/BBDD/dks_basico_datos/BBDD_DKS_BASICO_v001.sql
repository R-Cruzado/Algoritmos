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

/*  Pendientes de hacer :

	/* datos sin techo de la ayuda interfaz de las tablas de familia *
		/* datos de   gen_ai_es_gen_Familia_Conceptos *
			(4,"gen_st_iconoImagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Conceptos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_iconoAudioConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Conceptos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_imagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Conceptos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_Familias_fam *
			(10,"gen_st_iconoImagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Familias_fam.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_st_iconoAudioConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Familias_fam.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_st_imagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Familias_fam.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_Usuarios_usr *
			(16,"gen_st_iconoImagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Usuarios_usr.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_st_iconoAudioConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Usuarios_usr.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(18,"gen_st_imagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Usuarios_usr.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_AyudaIntEsp_ai_es *
			(22,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_AyudaIntEsp_ai_es.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(23,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_AyudaIntEsp_ai_es.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(24,"gen_st_imagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_AyudaIntEsp_ai_es.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
 *******  Fin de pendientes de hacer  */


/* esto que sigue no se para que sirve */
/*!40101 SET NAMES utf8 */;
/*!40101 SET SQL_MODE=''*/;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/* CREATE DATABASE /*!32312 IF NOT EXISTS*/ /*`DKSV07; /* la base de datos tiene que estar dada de alta */
CREATE DATABASE IF NOT EXISTS dksbasico CHARSET = utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `dksbasico`;  /* Aqui se identifica la base de datos  */

/*  ******* Definimos algunas variables para utilizarlas a lo largo del script **************************  */

/*  otros DKS a los que se hace referencia  */
SET @localizacionGenericDKS = "http://localhost/klw/dks_Generic"; /* Para DKS geberico  */
/*	SET @localizacionGenericDKS = "http://www.ideando.net/klw/dks_Generic"; */
SET @ordinalDeAlta_GENERICO = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_GENERICO*/
SET @tiemoDeAlta_GENERICO = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_GENERICO*/

SET @localizacion_DKS_KLW = "http://localhost/klw/dks_klw"; /* Para el DKS  de KLW  */
/*	SET @localizacion_DKS_KLW = "http://www.ideando.net/klw/dks_klw";*/
SET @ordinalDeAlta_KLW = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_KLW*/
SET @tiemoDeAlta_KLW = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_KLW*/

SET @localizacion_DKS_LANGUAJES = "http://localhost/klw/dks_Languajes"; /* Para el DKS de idiomas  */
/*	SET @localizacion_DKS_LANGUAJES = "http://www.ideando.net/klw/dks_Languajes";  */
SET @ordinalDeAlta_LANGUAJES = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_GENERICO*/
SET @tiemoDeAlta_LANGUAJES = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_GENERICO*/

/* Datos por defecto para el alta de los datos del DKS  lOCAL */
SET @locDKSLocal = "http://localhost/klw/dks_basico";  /* Para el DKS local (el que se esta instalando). La localizacion @locSelfService  debe ser la url de instalacion del servicio.  */ 
/*	SET @locDKSLocal = "http://www.ideando.net/klw/dks_basico"; */ 
SET @locSelfService = @locDKSLocal;  /* este no se para que sirve  */
SET @ordinalDeAlta = 0;  /* Indica el ordinal por defecto para el alta inicial de datos de este DKS*/
SET @tiemoDeAlta = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS*/

SET @locDKSLocal_ai_es = "http://localhost/klw/dks_basico/lan_es";  
SET @locDKSLocal_ai_ing = "http://localhost/klw/dks_basico/lan_ing";

/* Usuarios para el alta inicial  */
SET @claveUsuario = "gen_usr_genesis";  /* Indica el usuario por defecto para el alta de los conceptos en el proceso de instalacion es un concepto de generikDKS*/
SET @localizacionUsuario = @locDKSLocal;  /* Indica la localizacion por defecto del usuario para el alta de los conceptos en el proceso de instalacion */

	/* existen datos cruzados, por lo que es necesario indicar los datos por defecto de alta de otros DKS.
		Estos deben modificarse cuando se den de alta los DKS pertinentes, y modificarse si estos se modifican, modificando la naturaleza de los datos segun corresponda en el DKS BASICO para futuras altas de DKSs */

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
			/*  Concepto de principio o genesis (reside en generickDKS)  ***********  */
			(1,"gen_esteDks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
			/*  ****************  FIN DE conceptos DE BBDD KLW   *************************************  */	
			
/*    Ultimo identificador utilizado para esta tabla de arriba   1, debes utilizar uno posterior para el siguiente registro **********  */			

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
			/* Relaciones del concepto de ayuda a interfaz generico sin idioma asociado  *** el concepto de ayuda a interfaz tiene tambien su ayuda a interfaz, como debe ser ********  */
			(1,0,"gen_esteDks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(2,1,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(3,2,"gen_ai_es_gen_esteDks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,1),
					(4,2,"gen_ai_ing_gen_esteDks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",1,1);
			
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

/*  Introducimos las relaciones de los Conceptos de usuario ***********  */
/*  Conceptos  para DKS BASICO ***********  */
insert  into `usr_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	/* DEscripcion del usuario Administrador (creado por defecto) */
			(1000,0,"gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"usr_",1000,0),
				(1001,1000,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(1002,1001,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"ai_es_",1000,1),
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
					(1013,1012,"gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1001,"ai_es_",1001,1),
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

/*  Conceptos de ayuda a interfaz  en español ***********  *
insert  into `ai_es_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	  ****************  */

/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
		/*  datos de los prefijos de familia */
		(1,"gen_ai_es_gen_Familia_Conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(2,"gen_ai_es_gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(3,"gen_ai_es_gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(4,"gen_ai_es_gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(6,"gen_ai_es_gen_Familia_AyudaIntIng_ai_ing",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(5,"gen_ai_es_gen_esteDks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		
		/* datos de   gen_fam_gen_usuarioAdministradorLocal1*/
		(1000,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(1001,"gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

	/*    Ultimo identificador utilizado para esta tabla de arriba   6, debes utilizar uno posterior para el siguiente registro **********  */			

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
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_Conceptos  ***********  */
		(1,0,"gen_ai_es_gen_Familia_Conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1,0),
		/* el concepto es una ayuda a interfaz */
			(2,1,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
				(3,2,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
			(4,1,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(5,4,"gen_st_nombre_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1,2),
		/* descripcion */
			(6,1,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(7,6,"gen_st_descripcion_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,2),
		/* rotulo */
			(8,1,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(9,8,"gen_st_rotulo_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(10,1,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(11,10,"gen_st_iconoImagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(12,1,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(13,12,"gen_st_iconoAudioConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(14,1,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(15,14,"gen_st_imagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_Familias_fam  ***********  */
		(16,0,"gen_ai_es_gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,0),
		/* el concepto es una ayuda a interfaz */
			(17,16,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
				(18,17,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
			(19,16,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(20,19,"gen_st_nombre_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,2),
		/* descripcion */
			(21,16,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(22,21,"gen_st_descripcion_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",8,2),
		/* rotulo */
			(23,16,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(24,23,"gen_st_rotulo_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",9,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(25,16,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(26,25,"gen_st_iconoImagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(27,16,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(28,27,"gen_st_iconoAudioConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",11,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(29,16,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(30,29,"gen_st_imagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",12,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_Usuarios_usr  ***********  */
		(31,0,"gen_ai_es_gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,0),
		/* el concepto es una ayuda a interfaz */
			(32,31,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
				(33,32,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
			(34,31,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(36,34,"gen_st_nombre_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",13,2),
		/* descripcion */
			(37,31,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(38,37,"gen_st_descripcion_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,2),
		/* rotulo */
			(39,31,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(40,39,"gen_st_rotulo_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(41,31,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(42,41,"gen_st_iconoImagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(43,31,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(44,43,"gen_st_iconoAudioConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(45,31,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(46,45,"gen_st_imagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_AyudaIntEsp_ai_es  ***********  */
		(47,0,"gen_ai_es_gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,0),
		/* el concepto es una ayuda a interfaz */
			(48,47,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
				(49,48,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
			(50,47,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(51,50,"gen_st_nombre_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,2),
		/* descripcion */
			(52,47,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(53,52,"gen_st_descripcion_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,2),
		/* rotulo */
			(54,47,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(55,54,"gen_st_rotulo_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",21,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(56,47,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(57,56,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",22,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(58,47,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(59,58,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",23,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(60,47,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(61,60,"gen_st_imagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",24,2),

				
				
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_AyudaIntIng_ai_ing  ***********  */
		(78,0,"gen_ai_es_gen_Familia_AyudaIntIng_ai_ing",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,0),
		/* el concepto es una ayuda a interfaz */
			(79,78,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
				(80,79,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
			(81,78,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(82,81,"gen_st_nombre_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",31,2),
		/* descripcion */
			(83,78,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(84,83,"gen_st_descripcion_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",32,2),
		/* rotulo */
			(85,78,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(86,85,"gen_st_rotulo_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",33,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(87,78,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(88,87,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",34,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(89,78,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(90,89,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",35,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(91,78,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(92,91,"gen_st_imagenConcepto_gen_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",36,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_esteDks  ***********  */
		(62,0,"gen_ai_es_gen_esteDks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,0),
		/* el concepto es una ayuda a interfaz */
			(63,62,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
				(64,63,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
		/* nombre */
			(65,62,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(66,65,"gen_st_nombre_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",25,2),
		/* descripcion */
			(67,62,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(68,67,"gen_st_descripcion_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",26,2),
		/* rotulo */
			(69,62,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(71,70,"gen_st_rotulo_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",27,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(72,62,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(73,72,"gen_st_iconoImagenConcepto_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",28,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(74,62,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(75,74,"gen_st_iconoAudioConcepto_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",29,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(76,62,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(77,76,"gen_st_imagenConcepto_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",30,2),

				
	/* Relaciones de ayuda interfaz del concepto gen_usuarioAdministradorLocal1  ***********  */
		(1000,0,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,0),
		/* nombre */
			(1001,1000,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(1002,1001,"gen_st_nombreusuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,2),
		/* descripcion */
			(1003,1000,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(1004,1003,"gen_st_descripcionusuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1001,2),
		/* rotulo */
			(1005,1000,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(1006,1005,"gen_st_rotulousuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1002,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1007,1000,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(1008,1007,"gen_st_iconoImagenConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1003,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1009,1000,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(1010,1009,"gen_st_iconoAudioConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1004,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1011,1000,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(1012,1011,"gen_st_imagenConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1005,2),
					
	/* Relaciones de ayuda interfaz del concepto gen_interfazKee_gen_usuarioAdministradorLocal1  ***********  */
		(1013,0,"gen_ai_es_gen_interfazKee_gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1001,0),
		/* nombre */
			(1014,1013,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(1015,1014,"gen_st_nombre_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1006,2),
		/* descripcion */
			(1016,1013,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(1017,1016,"gen_st_descripcion_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1007,2),
		/* rotulo */
			(1018,1013,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
				(1019,1018,"gen_st_rotulo_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1008,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1020,1013,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
				(1021,1020,"gen_st_iconoImagenConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1009,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1022,1013,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
				(1023,1022,"gen_st_iconoAudioConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1010,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(1024,1013,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
				(1025,1024,"gen_st_imagenConcepto_gen_interfazKee_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1011,2);
					
	/*    Ultimo identificador utilizado para esta tabla de arriba   92, debes utilizar uno posterior para el siguiente registro **********  */			

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

/*  Conceptos datos (sin techo) de ayuda a interfaz en español ***********  *
insert  into `ai_es_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	  ********** Datos de  gen_ai_es_ayudaInterfazEsp */
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	
	/* datos sin techo de la ayuda interfaz de las tablas de familia */
		/* datos de   gen_ai_es_gen_Familia_Conceptos */
			(1,"gen_st_nombre_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_st_descripcion_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_rotulo_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(4,"gen_st_iconoImagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Conceptos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_iconoAudioConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Conceptos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_imagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Conceptos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_Familias_fam */
			(7,"gen_st_nombre_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Familias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(8,"gen_st_descripcion_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Familias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(9,"gen_st_rotulo_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Familias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(10,"gen_st_iconoImagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Familias_fam.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_st_iconoAudioConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Familias_fam.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(12,"gen_st_imagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Familias_fam.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_Usuarios_usr */
			(13,"gen_st_nombre_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(14,"gen_st_descripcion_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(15,"gen_st_rotulo_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(16,"gen_st_iconoImagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Usuarios_usr.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_st_iconoAudioConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Usuarios_usr.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(18,"gen_st_imagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Usuarios_usr.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_AyudaIntEsp_ai_es */
			(19,"gen_st_nombre_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(20,"gen_st_descripcion_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(21,"gen_st_rotulo_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(22,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_AyudaIntEsp_ai_es.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(23,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_AyudaIntEsp_ai_es.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(24,"gen_st_imagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_AyudaIntEsp_ai_es.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_AyudaIntEsp_ai_es */
			(31,"gen_st_nombre_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Ayuda a interfaz en Ingles","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_st_descripcion_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Ayuda a interfaz en ingles","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_st_rotulo_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Ayuda a interfaz en Ingles","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(34,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_AyudaIntEsp_ai_ing.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(35,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_AyudaIntEsp_ai_ing.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(36,"gen_st_imagenConcepto_gen_Familia_AyudaIntIng_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_AyudaIntEsp_ai_ing.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

		/* datos de   gen_ai_es_gen_esteDks */
			(25,"gen_st_nombre_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Este DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(26,"gen_st_descripcion_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa el DKS local","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(27,"gen_rotulo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"DKS local","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(28,"gen_st_iconoImagenConcepto_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_esteDks.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(29,"gen_st_iconoAudioConcepto_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudio_esp_esteDks.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(30,"gen_st_imagenConcepto_gen_esteDks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_esteDks.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	

	/* datos de   gen_ai_es_gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_nombreUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_descripcionUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el usuario que genera por defecto al generar la BBDD de una aplicacion DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_rotuloUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1003,"gen_st_iconoImagenConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgUsrAdminLocal1.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1004,"gen_st_iconoAudioConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioUsrAdminLocal1.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1005,"gen_st_imagenConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_UsrAdminLocal1.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

	/* datos de   gen_ai_es_gen_usuarioAdministradorLocal1*/
			(1006,"gen_st_nombreUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Interfaz de Usr Administrador local1 (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1007,"gen_st_descripcionUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el concepto de interfaz asociado al usuario que genera por defecto al generar la BBDD de una aplicacion DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1008,"gen_st_rotuloUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Intf Usr Ad loc1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1009,"gen_st_iconoImagenConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgInterfUsrAdminLoc1.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1010,"gen_st_iconoAudioConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioInterfUsrAdminLoc1.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1011,"gen_st_imagenConcepto_gen_usuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_InterfUsrAdminLoc1.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

	/*    Ultimo identificador utilizado para esta tabla de arriba   36, debes utilizar uno posterior para el siguiente registro ojo, a partir del 1000 lo ocupan los datos de usuario **********  */			

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
			(1,"gen_ai_ing_gen_esteDks",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

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
	/* Relaciones de ayuda interfaz del concepto gen_personaFisica  ***********  */
			(1,0,"gen_ai_ing_gen_esteDks",@locDKSLocal_ai_ing,@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",55,0),
		/* Ayuda a interfaz */
				(2,1,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",0,0),
					(3,2,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",5,1),
		/* nombre */
				(4,1,"gen_nombre",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",4,0),
					(5,4,"gen_st_nombre_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",1,2),
		/* descripcion */
				(6,1,"gen_descripcion",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",5,0),
					(7,6,"gen_st_descripcion_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",2,2),
		/* rotulo */
				(8,1,"gen_rotulo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",6,0),
					(9,8,"gen_st_rotulo_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",3,2),
		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(10,1,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(11,10,"gen_st_iconoImagenConcepto_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",4,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(12,1,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(13,12,"gen_st_iconoAudioConcepto_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",5,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(14,1,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(15,14,"gen_st_imagenConcepto_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_ing_",6,2),
			
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
			/* datos de  gen_ai_ing_gen_descripcion */
			(1,"gen_st_nombre_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"This DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(2,"gen_st_descripcion_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"This DKS ","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_rotulo_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"This DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
			(4,"gen_st_iconoImagenConcepto_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_esteDks.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_iconoAudioConcepto_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudio_ing_esteDks.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_imagenConcepto_gen_esteDks","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_esteDks.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

	/*    Ultimo identificador utilizado para esta tabla de arriba   201, debes utilizar uno posterior para el siguiente registro  **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_ing_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos de   gen_ai_ing_gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_nombreUsuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"local administrator user1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_descripcionUsuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"It is the user that is generated by default when you build an application DB DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_rotuloUsuarioAdministradorLocal1","ai_ing_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"local administrator user1","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);

/*    Ultimo identificador utilizado para esta tabla de arriba   162, debes utilizar uno posterior para el siguiente registro  ojo, a partir de 1000 el ultimo es 1002 **********  */			

/*  *********************  FIN Tablas de ai_ing_conceptos  ************************************** */
			
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
