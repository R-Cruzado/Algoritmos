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
	imagen_familiaDeDatosKlw.jpg

	imagen_familiaDeDatosKlw_conceptos.jpg

	imagen_familiaDeDatosKlw_familias.jpg

	imagen_familiaDeDatosKlw_usuarios.jpg
	
	imagen_familiaDeDatosKlw_ai_es.jpg

	imagen_familiaDeDatosKlw_ai_ing.jpg

*/

/* esto que sigue no se para que sirve */
/*SET NAMES utf8;*/
/*!40101 SET SQL_MODE=''*/;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/* la base de datos tiene que estar dada de alta */
CREATE DATABASE IF NOT EXISTS dksklw CHARSET = utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `dksklw`;  /* Aqui se identifica la base de datos  */

/*  ******* Definimos algunas variables para utilizarlas a lo largo del script **************************  */

/*  otros DKS a los que se hace referencia  */
SET @localizacionGenericDKS = "http://localhost/klw/dks_Generic"; /* Para DKS geberico  */
SET @localizacion_DKS_LANGUAJES = "http://localhost/klw/dks_Languajes"; /* Para el DKS de idiomas  */

/* ****
SET @localizacionGenericDKS = "http://www.ideando.net/klw/dks_Generic";
SET @localizacion_DKS_LANGUAJES = "http://www.ideando.net/klw/dks_Languajes";
*/

SET @locDKSLocal = "http://localhost/klw/dks_klw";  /* Para el DKS local (el que se esta instalando). La localizacion @locSelfService  debe ser la url de instalacion del servicio.  */ 
/*	SET @locDKSLocal = "http://www.ideando.net/klw/dks_klw"; */ 
SET @localizacion_DKS_KLW = @locDKSLocal;  /* Estam,os en el DKS de KLW.  */ 
SET @locSelfService = @locDKSLocal;   /* este no se para que sirve  */

SET @locDKSLocal_ai_es = "http://localhost/klw/dks_klw/lan_es";  
SET @locDKSLocal_ai_ing = "http://localhost/klw/dks_klw/lan_ing";


/* Usuarios para el alta inicial  */
SET @claveUsuario = "gen_usr_genesis";  /* Indica el usuario por defecto para el alta de los conceptos en el proceso de instalacion es un concepto de generikDKS*/
SET @localizacionUsuario = @locDKSLocal;  /* Indica la localizacion por defecto del usuario para el alta de los conceptos en el proceso de instalacion */

/* Datos por defecto para el alta de los datos del DKS  lOCAL */
SET @ordinalDeAlta = 0;  /* Indica el ordinal por defecto para el alta inicial de datos de este DKS*/
SET @tiemoDeAlta = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS*/
	/* existen datos cruzados, por lo que es necesario indicar los datos por defecto de alta de otros DKS.
		Estos deben modificarse cuando se den de alta los DKS pertinentes, y modificarse si estos se modifican, modificando la naturaleza de los datos segun corresponda en el DKS BASICO para futuras altas de DKSs */

/*  En este caso es el local SET @ordinalDeAlta_KLW = 0;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_KLW*/
/*  En este caso es el local SET @tiemoDeAlta_KLW = 0;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_KLW*/


SET @ordinalDeAlta_KLW = @ordinalDeAlta;  /* Indica el ordinal por defecto para el alta inicial de datos referenciados a DKS_GENERICO*/
SET @tiemoDeAlta_KLW = @tiemoDeAlta;  /* Indica el tiempo de modificacion por defecto para el alta inicial de datos de este DKS_GENERICO*/


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
			/*  Concepto de principio o genesis (reside en generickDKS)  ***********  */
			(1,"gen_genesis",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de ayuda a interfaz generico sin idioma asociado (reside en generickDKS)   ***********  */
			(2,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* ************* Tipos de datos SIN TECHO ***************************************************************** */
				/*  Concepto de tipos de datos de sin techo (texto plano, ficheros de disco, codigo autoejecutable, direccion web, etc  ) (reside en generickDKS)  ***********  */
			(8,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de texto plano como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(9,"gen_tipoDeSinTechoTextoPlano",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de numero entero como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(66,"gen_tipoDeSinTecho_NumeroEntero",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de url como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(70,"gen_tipoDeSinTecho_Url",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de fichero generico como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(71,"gen_tipoDeSinTecho_FicheroGenerico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de fichero de audio como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(72,"gen_tipoDeSinTecho_FicheroAudio",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de fichero de imagen como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(73,"gen_tipoDeSinTecho_FicheroImagen",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de fichero de video como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(74,"gen_tipoDeSinTecho_FicheroVideo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

				/*  Concepto de fichero ejecutable como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(75,"gen_tipoDeSinTecho_LlamadaFuncionKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			/* FIN ************* Tipos de datos SIN TECHO ***************************************************************** */

			/*  Concepto consulta a DKS  (reside en generickDKS)  ***********  */
			(13,"gen_consultaaDKS",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de clave encriptada, como tipos de datos de sin techo  (reside en generickDKS)  ***********  */
			(14,"gen_tipoDeSinTechoClaveEncriptada",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

		/*  Conceptos de KLW (reside en generickDKS)  ***********  */

			/*  Concepto KLW (reside en generickDKS)  ***********  Corresponde al KLW (Knowledge Living in Web) tal como lo hemos definido.  *** */
			(15,"gen_KLW",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto concepto C (reside en generickDKS)  *********** Es el concepto C de KLW tal como lo hemos definido.  *** */
			(16,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto KDL (reside en generickDKS)  ***********   Corresponde al KDL (Knowledge Description Languaje) tal como lo hemos definido.en KLW  *** */
			(17,"gen_KDL",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto I = Identificador KDL (reside en generickDKS)  ***********   Es el concepto I = Identificador es decir el identificador (key+host)  de KDL en KLW tal como lo hemos definido.  *** */
			(18,"gen_I",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto K = Clave o Key KDL (reside en generickDKS)  ***********   Es el concepto K = Clave o Key  de KDL en KLW tal como lo hemos definido.  *** */
			(19,"gen_K",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto H = Localizacion ( host) KDL (reside en generickDKS)  ***********  Es el concepto H = Localizacion ( host) de KDL en KLW tal como lo hemos definido.  *** */
			(20,"gen_H",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto F = Control de configuracion KDL (reside en generickDKS)  ***********   Es el concepto F = Control de configuracion es decir el elemento para control de configuracion de KDL en KLW tal como lo hemos definido.  *** */
			(21,"gen_F",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto O = Ordinal KDL (reside en generickDKS)  ***********   Es el concepto O = Ordinal de KDL en KLW tal como lo hemos definido.  *** */
			(22,"gen_O",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto M = Fecha de ultima modificacion o tiempo de actualizacion KDL (reside en generickDKS)  ***********  Es el concepto M = Fecha de ultima modificacion o tiempo de actualizacion de KDL en KLW tal como lo hemos definido.  *** */
			(23,"gen_M",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto D = Descripcion (reside en generickDKS)  ***********   Es el concepto D = Descripcion KDL en KLW tal como lo hemos definido.  *** */
			(24,"gen_D",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto E = Enlace KDL (reside en generickDKS)  ***********   Es el concepto E = Enlace de KDL en KLW tal como lo hemos definido.  *** */
			(25,"gen_E",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto A = Instancia KDL (alude al concepto) (reside en generickDKS)  ***********  Es el concepto A = Instancia (alude al concepto) de KDL en KLW tal como lo hemos definido.  *** */
			(26,"gen_A",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto R = Referencia KDL (reside en generickDKS)  ***********   Es el concepto R = Referencia a un concepto de KDL en KLW tal como lo hemos definido.  *** */
			(27,"gen_R",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto Z = Sin techo KDL ( non plus ultra) (reside en generickDKS)  ***********  Es el concepto Z = Sin techo o dato sin referencia con conocimiento tan solo en el dominio del observador( non plus ultra) de KDL en KLW tal como lo hemos definido.  *** */
			(28,"gen_Z",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto T = Dato KDL, texto cuya informacion reside en el dominio del observador (UTF-8) (reside en generickDKS)  ***********  Es el concepto T = Dato, texto cuya informacion reside en el dominio del observador de KDL en KLW tal como lo hemos definido.  *** */
			(29,"gen_T",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto P = De ayuda a interfaz KDL  (reside en generickDKS)  ***********   Es el concepto P = Descripcion del concepto de ayuda a interfaz asociado a una referencia o instancia de KDL en KLW tal como lo hemos definido.  *** */
			(30,"gen_P",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto L = Lenguaje KDL ( reside en generickDKS)  ***********   Es el concepto L = Lenguaje ( su contenido es una referencia a un concepto que debe ser una lengua conocida) de KDL en KLW tal como lo hemos definido.  *** */
			(31,"gen_L",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

		/*  ****************  FIN DE conceptos DE KLW   *************************************  */	

			/*  Concepto solicitud a DKS (reside en generickDKS)  ***********  */
			(36,"gen_solicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* Concepto getDetails (como tipo de solicitud) devuelve el KDL de un concepto en el idioma correspondiente (instancian  el concepto clase, que es mas generico) **** */
			(37,"gen_getDetails",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* Concepto gen_getAyudaInterfaz (como tipo de solicitud) devuelve el KDL de la ayuda a interfaz (P) de un concepto en el idioma correspondiente **** */
			(42,"gen_getAyudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* Concepto gen_getConceptoInterfazUsuario (como tipo de solicitud) devuelve el KDL del concepto de interfaz  de un usuario, para configurar su interfaz **** */
			(53,"gen_getConceptoInterfazUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto respuesta a una solicitud a DKS  ***********  */
			(38,"gen_respuestaAsolicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto errorDeAccesoABbdd (reside en generickDKS)  ***********  */
			(40,"gen_errorDeAccesoABbdd",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto errorKLW (***********  */
			(41,"gen_errorKLW",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto errorEnAyudaInterfazKlw   ***********  */
			(55,"gen_errorEnAyudaInterfazKlw",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto configuracionDeAcceso  ***********  */
			(43,"gen_configuracionDeAcceso",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto configuracionDeAcceso  ***********  */
			(44,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto configuracionDeAcceso   ***********  */
			(45,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto configuracionDeAcceso  ***********  */
			(46,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

		/*  ****************   conceptos DE INTERFAZ KEE   *************************************  */	
	
			/*  Concepto de interfaz, contiene la informacion de configuracion de la interfaz de usuario  ***********  */
			(47,"gen_interfazKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de interfaz, contiene la informacion de configuracion de la interfaz de usuario  ***********  */
			(77,"gen_botonKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto lista de entornos, contiene la informacion de la lista de los entornos que existen en una configuracion de la interfaz de usuario  ***********  */
			(48,"gen_listaEntornos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto entorno de trabajo KEE, contiene la informacion de un entorno de trabajo en la configuracion de la interfaz de usuario  ***********  */
			(49,"gen_entornoDeTrabajoKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto lista de requerimientos, contiene la informacion de lalista de requerimientos realizados en un entorno de la configuracion de la interfaz de usuario  ***********  */
			(50,"gen_listaRequeraimientosKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto requerimiento KEE, contiene la informacion de un requerimiento realizado desde el cliente a su KEE correspondiente, para almacenar en la configuracion de la interfaz de usuario  ***********  */
			(51,"gen_requerimientoKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto lista de conceptos, contiene la lista de conceptos presentes en un entorno de la configuracion de la interfaz de usuario  ***********  */
			(52,"gen_ListaConceptosPresentes",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto asociado a conceptos no almacenados en DKS, son conceptos para mesajes u otros  ***********  */
			(54,"gen_ConceptoEfimero",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto Privacidad de datos (almacena la informacion referente a la propiedad y privacidad de datos  ***********  */
			(56,"gen_PrivacidadDeDatos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de recurso web como tipo de "sin techo"  ***********  */
			(57,"gen_tipoDeSinTechoRecursoWeb",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de buscador de la interfaz KEE"  ***********  */
			(58,"gen_BuscadorKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de lista de idiomas de la interfaz KEE"  ***********  */
			(59,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  ****************  FIN DE conceptos DE INTERFAZ KEE   *************************************  */	
			
		/*  ****************   conceptos DE BBDD KLW   *************************************  */	
	
			/*  Concepto de familia de datos en la base de datos de KLW"  ***********  */
			(60,"gen_familiaDeDatosKlw",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/*  Concepto de familia de datos de conceptos generales en la base de datos de KLW"  ***********  */
			(61,"gen_familiaDeDatosKlw_conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto de familia de datos de tablas de familia generales en la base de datos de KLW"  ***********  */
			(62,"gen_familiaDeDatosKlw_familias",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto de familia de datos de usuarios generales en la base de datos de KLW"  ***********  */
			(63,"gen_familiaDeDatosKlw_usuarios",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto de familia de datos de ayuda a interfaz en español generales en la base de datos de KLW"  ***********  */
			(64,"gen_familiaDeDatosKlw_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto de familia de datos de ayuda a interfaz en ingles generales en la base de datos de KLW"  ***********  */
			(65,"gen_familiaDeDatosKlw_ai_ing",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  ****************  FIN DE conceptos DE BBDD KLW   *************************************  */	
			
		/*  ****************   conceptos AÑADIDOS POSTERIORMENTE los pongo todos aqui por no renumerarlo todo (algunos estan con su numero mas arriba)  *************************************  */	

			/*  Concepto ParaConceptoNuevo se usara para generar conceptos nuevos  ***********  */
			(67,"gen_ParaConceptoNuevo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

						/*  Concepto recAyuIntf (recursos de ayuda a interfaz se usara para contener todas las ayudas a interfaz en los distintoss idiomas asi como los recursos para maquetacion  ***********  */
			(68,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

						/*  Concepto recMaq se usa para almacenar los recursos de maquetacion o layout  ***********  */
			(69,"gen_recMaq",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/*  Concepto de buscador de la interfaz KEE"  ***********  */
			(76,"gen_BuscadorKee_por_key_host",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);



		/*  ****************   FIN conceptos AÑADIDOS POSTERIORMENTE los pongo todos aqui por no renumerarlo todo   *************************************  */	
			
/*    Ultimo identificador utilizado para esta tabla de arriba   77
			- 67 Para "gen_ParaConceptoNuevo" 
			- Hasta el 75 para varios "gen_tipoDeSinTecho_xxxx" (2021-11-08)
			- 76 para "gen_BuscadorKee_por_key_host" (2021-11-23)
			- 77 para "gen_botonKee" (2021-11-23)

			debes utilizar uno posterior para el siguiente registro **********  */			
			
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
			(1,0,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(2,1,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(3,2,"gen_ai_es_gen_ayudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,1),
			(178,1,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,1),
			(179,1,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,1),
			(180,1,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,1),
			(181,1,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,0),
			(182,1,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",45,0),
			(183,1,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",46,0),
			(321,1,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,1),

			/* Relaciones del concepto gen_tipoDeSinTecho de ayuda a interfaz EN ESPAÑOL  ***********  */
			(10,0,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
			(11,10,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(12,11,"gen_ai_es_tipoDeSinTecho",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,1),

			/* Relaciones del concepto gen_tipoDeSinTechoTextoPlano   ***********  */
			(13,0,"gen_tipoDeSinTechoTextoPlano",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",9,0),
			(14,13,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(15,14,"gen_ai_es_tipoDeSinTechoTextoPlano",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,1),
			(16,13,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),

			/* Relaciones del concepto gen_tipoDeSinTechoTextoPlano   ***********  */
			(314,0,"gen_tipoDeSinTecho_NumeroEntero",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",66,0),
				(315,314,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(316,315,"gen_ai_es_tipoDeSinTecho_NumeroEntero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",69,1),
				(317,314,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),

			/* Relaciones del concepto gen_tipoDeSinTechoClaveEncriptada   ***********  */
			(17,0,"gen_tipoDeSinTechoClaveEncriptada",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",14,0),
			(18,17,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(19,18,"gen_ai_es_tipoDeSinTechoClaveEncriptada",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",9,1),
			(20,17,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),

			/* Relaciones del concepto gen_tipoDeSinTecho de ayuda a interfaz   ***********  */
			(166,0,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",44,0),
			(167,166,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(168,167,"gen_ai_es_gen_iconoImagenConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",43,1),
			(169,166,"gen_imagen",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",48,1),

			/* Relaciones del concepto gen_iconoAudioConcepto de ayuda a interfaz   ***********  */
			(170,0,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",45,0),
			(171,170,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				(172,171,"gen_ai_es_gen_iconoAudioConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",44,1),
			(173,170,"gen_audio",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",50,1),

			/* Relaciones del concepto gen_imagenConcepto de ayuda a interfaz   ***********  */
			(174,0,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",46,0),
			(175,174,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(176,175,"gen_ai_es_gen_imagenConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",45,1),
			(177,174,"gen_imagen",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",48,1),

	/* Relaciones del concepto gen_KLW  ***********  */
			(44,0,"gen_KLW",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",15,0),
			(45,44,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(46,45,"gen_ai_es_gen_KLW",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,1),

	/* Relaciones del concepto gen_concepto  ***********  */
			(47,0,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,0),
			(48,47,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(49,48,"gen_ai_es_gen_concepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,1),

	/* Relaciones del concepto gen_KDL  ***********  */
			(50,0,"gen_KDL",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",17,0),
			(51,50,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(52,51,"gen_ai_es_gen_KDL",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,1),

	/* Relaciones del concepto gen_I  ***********  */
			(53,0,"gen_I",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",18,0),
			(54,53,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(55,54,"gen_ai_es_gen_I",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,1),

	/* Relaciones del concepto gen_K  ***********  */
			(56,0,"gen_K",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",19,0),
				(57,56,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(58,57,"gen_ai_es_gen_K",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,1),
				(390,56,"gen_st_vacio_para_textoPlano","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",30,2),

	/* Relaciones del concepto gen_H  ***********  */
			(59,0,"gen_H",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",20,0),
				(60,59,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(61,60,"gen_ai_es_gen_H",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,1),
				(391,59,"gen_st_vacio_para_textoPlano","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",30,2),

	/* Relaciones del concepto gen_F  ***********  */
			(62,0,"gen_F",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",21,0),
			(63,62,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(64,63,"gen_ai_es_gen_F",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,1),

	/* Relaciones del concepto gen_O  ***********  */
			(65,0,"gen_O",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",22,0),
			(66,65,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(67,66,"gen_ai_es_gen_O",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",21,1),

	/* Relaciones del concepto gen_M  ***********  */
			(68,0,"gen_M",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",23,0),
			(69,68,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(70,69,"gen_ai_es_gen_M",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",22,1),

	/* Relaciones del concepto gen_D  ***********  */
			(71,0,"gen_D",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",24,0),
			(72,71,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(73,72,"gen_ai_es_gen_D",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",23,1),

	/* Relaciones del concepto gen_E  ***********  */
			(74,0,"gen_E",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",25,0),
			(75,74,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(76,75,"gen_ai_es_gen_E",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",24,1),

	/* Relaciones del concepto gen_A  ***********  */
			(77,0,"gen_A",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",26,0),
			(78,77,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(79,78,"gen_ai_es_gen_A",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",25,1),

	/* Relaciones del concepto gen_R  ***********  */
			(80,0,"gen_R",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",27,0),
			(81,80,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(82,81,"gen_ai_es_gen_R",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",26,1),

	/* Relaciones del concepto gen_Z  ***********  */
			(83,0,"gen_Z",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",28,0),
			(84,83,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(85,84,"gen_ai_es_gen_Z",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",27,1),

	/* Relaciones del concepto gen_T  ***********  */
			(86,0,"gen_T",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",29,0),
			(87,86,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(88,87,"gen_ai_es_gen_T",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",28,1),

	/* Relaciones del concepto gen_P  ***********  */
			(89,0,"gen_P",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",30,0),
			(90,89,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(91,90,"gen_ai_es_gen_P",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",29,1),

	/* Relaciones del concepto gen_L  ***********  */
			(92,0,"gen_L",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",31,0),
			(93,92,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(94,93,"gen_ai_es_gen_L",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",30,1),

		/*  ****************  FIN DE conceptos DE KLW   *************************************  */	

	/* Relaciones del concepto gen_solicitudADks  ***********  */
			(107,0,"gen_solicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",36,0),
			(108,107,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(109,108,"gen_ai_es_gen_solicitudADks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",35,1),
			(110,107,"gen_clase",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",35,1),
			(223,107,"gen_datacion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",52,1),

	/* Relaciones del concepto gen_getDetails  ***********  */
			(111,0,"gen_getDetails",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",37,0),
				(112,111,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(113,112,"gen_ai_es_gen_getDetails",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",36,1),
				(114,111,"gen_solicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",36,0),
				(115,111,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
				(116,111,"gen_input",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",33,0),
					(117,116,"gen_I",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",18,0),
						(118,117,"gen_K",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",19,0),
						(119,117,"gen_H",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",20,0),
					(120,116,"gen_F",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",21,0),
						(121,120,"gen_O",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",22,0),
						(122,120,"gen_M",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",23,0),
				(123,111,"gen_output",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",34,0),
					(124,123,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,1),
			
	/* Relaciones del concepto gen_getAyudaInterfaz  ***********  */
			(142,0,"gen_getAyudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",42,0),
				(143,142,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(144,143,"gen_ai_es_gen_getAyudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",41,1),
				(145,142,"gen_solicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",36,0),
				(146,142,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
				(147,142,"gen_input",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",33,0),
					(148,147,"gen_I",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",18,0),
						(149,148,"gen_K",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",19,0),
						(150,148,"gen_H",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",20,0),
					(151,147,"gen_F",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",21,0),
						(152,151,"gen_O",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",22,0),
						(153,151,"gen_M",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",23,0),
				(154,142,"gen_output",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",34,0),
					(155,154,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,1),

	/* Relaciones del concepto gen_getConceptoInterfazUsuario  ***********  */
			(230,0,"gen_getConceptoInterfazUsuario",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",53,0),
				(231,230,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(232,231,"gen_ai_es_gen_getConceptoInterfazUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",41,1),
				(233,230,"gen_solicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",36,0),
				(234,230,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
				(235,230,"gen_input",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",33,0),
					(236,235,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,0),
						(237,236,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
				(238,230,"gen_output",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",34,0),
					(239,238,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,1),

	/* Relaciones del concepto gen_respuestaAsolicitudADks  ***********  */
			(125,0,"gen_respuestaAsolicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",38,0),
			(126,125,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(127,126,"gen_ai_es_gen_respuestaAsolicitudADks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",37,1),
			(128,125,"gen_clase",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",35,1),
			(224,125,"gen_datacion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",52,1),

	/* Relaciones del concepto gen_errorDeAccesoABbdd  ***********  */
			(134,0,"gen_errorDeAccesoABbdd",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",40,0),
			(135,134,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
			(136,135,"gen_ai_es_gen_errorDeAccesoABbdd",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",39,1),
			(137,134,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,1),

	/* Relaciones del concepto gen_errorKLW  ***********  */
			(138,0,"gen_errorKLW",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",41,0),
				(139,138,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(140,139,"gen_ai_es_gen_errorKLW",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",40,1),
				(165,138,"gen_error",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",39,0),
					(159,165,"gen_clase",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",35,1),
					(141,165,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,1),
					(160,165,"gen_accionConsecuente",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",42,1),
					(161,165,"gen_nivelDeGravedad",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",43,1),
					(162,165,"gen_localizacion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",44,1),
					(163,165,"gen_agente",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",45,1),
					(164,165,"gen_anexos",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",46,1),

	/* Relaciones del concepto gen_errorEnAyudaInterfazKlw  ***********  */
			(243,0,"gen_errorEnAyudaInterfazKlw",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",41,0),
				(244,243,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(245,244,"gen_ai_es_gen_errorEnAyudaInterfazKlw",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",54,1),
					
	/* Relaciones del concepto gen_configuracionDeAcceso  ***********  */
			(156,0,"gen_configuracionDeAcceso",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",43,0),
				(157,156,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(158,157,"gen_ai_es_gen_configuracionDeAcceso",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,1),
				(269,156,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",59,0),
					(270,269,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
						(271,270,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
							(272,271,"gen_st_gen_ordinal_263","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",1,2),
						(273,270,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,1),
					
	/* Relaciones del concepto gen_interfazKee  ***********  */
			(184,0,"gen_interfazKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",47,0),
				(185,184,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(186,185,"gen_ai_es_gen_interfazKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",46,1),
				(197,184,"gen_configuracionDeAcceso",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",43,1),
					(264,197,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",59,0),
						(265,264,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
							(266,265,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
								(267,266,"gen_st_gen_ordinal_263","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",1,2),
							(268,265,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,1),
				(187,184,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
					(188,187,"gen_listaEntornos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",48,0),
						(189,188,"gen_entornoDeTrabajoKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",48,0),
							(190,189,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
							(191,189,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
								(192,191,"gen_listaRequerimientosKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",50,0),
									(193,192,"gen_requerimientoKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",51,1),
							(194,189,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
								(195,194,"gen_ListaConceptosPresentes",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",52,0),
									(196,195,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,1),
				(198,184,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,1),
						
	/* Relaciones del concepto gen_listaEntornos  ***********  */
			(199,0,"gen_listaEntornos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",48,0),
				(200,199,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(201,200,"gen_ai_es_gen_listaEntornos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",47,1),
				(202,199,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,1),
				(203,199,"gen_entornoDeTrabajoKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",49,1),

	/* Relaciones del concepto gen_entornoDeTrabajoKee  ***********  */
			(204,0,"gen_entornoDeTrabajoKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",49,0),
				(205,204,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(206,205,"gen_ai_es_gen_entornoDeTrabajoKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",48,1),
				(207,204,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
					(208,207,"gen_listaRequerimientosKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",50,1),
				(209,204,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
					(210,209,"gen_ListaConceptosPresentes",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",52,1),
				(211,204,"gen_configuracionDeAcceso",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",43,1),
					(262,211,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,0),
						(263,262,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",59,1),
						
	/* Relaciones del concepto gen_listaRequerimientosKEE  ***********  */
			(212,0,"gen_listaRequerimientosKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",50,0),
				(213,212,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(214,213,"gen_ai_es_gen_listaRequerimientosKEE",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",49,1),
				(215,212,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,1),
				(216,212,"gen_requerimientoKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",51,1),

	/* Relaciones del concepto gen_requerimientoKEE  ***********  */
			(217,0,"gen_requerimientoKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",51,0),
				(218,217,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(219,218,"gen_ai_es_gen_requerimientoKEE",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",50,1),
				(220,217,"gen_Identificador",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",32,0),
				(221,217,"gen_solicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",36,1),
				(222,217,"gen_respuestaAsolicitudADks",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",38,1),

	/* Relaciones del concepto gen_ListaConceptosPresentes  ***********  */
			(225,0,"gen_ListaConceptosPresentes",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",52,0),
				(226,225,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(227,226,"gen_ai_es_gen_ListaConceptosPresentes",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",51,1),
				(228,225,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,1),
				(229,225,"gen_concepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",16,1),

	/* Relaciones del concepto gen_ConceptoEfimero  ***********  */
			(240,0,"gen_ConceptoEfimero",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",54,0),
				(241,240,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(242,241,"gen_ai_es_gen_ConceptoEfimero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",53,1),

	/* Relaciones del concepto gen_PrivacidadDeDatos  ***********  */
			(246,0,"gen_PrivacidadDeDatos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",56,0),
				(247,246,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(248,247,"gen_ai_es_gen_PrivacidadDeDatos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,1),

	/* Relaciones del concepto gen_tipoDeSinTechoRecursoWeb  ***********  */
			(249,0,"gen_tipoDeSinTechoRecursoWeb",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",57,0),
				(250,249,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(251,250,"gen_ai_es_gen_tipoDeSinTechoRecursoWeb",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",56,1),

	/* Relaciones del concepto gen_listaDeIdiomasDeInterfaz  ***********  */
			(255,0,"gen_listaDeIdiomasDeInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",59,0),
				(256,255,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(257,256,"gen_ai_es_gen_listaDeIdiomasDeInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",58,1),
				(258,255,"gen_lista",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",51,1),
					(259,258,"gen_ordinal",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",58,0),
						(260,259,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",2,0),
					
		/*  ****************   conceptos DE BBDD KLW   *************************************  */	

	/* Relaciones del concepto gen_familiaDeDatosKlw  ***********  */
			(274,0,"gen_familiaDeDatosKlw",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",60,0),
				(275,274,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(276,275,"gen_ai_es_gen_familiaDeDatosKlw",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",59,1),
				(277,274,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,1),
				(278,274,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,1),
		
	/* Relaciones del concepto gen_familiaDeDatosKlw_conceptos  ***********  */
			(279,0,"gen_familiaDeDatosKlw_conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",61,0),
				(280,279,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(281,280,"gen_ai_es_gen_familiaDeDatosKlw_conceptos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",60,1),
				(282,279,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
					(283,282,"gen_st_gen_familiaDeDatosKlw_conceptos_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",2,2),
				(284,279,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
					(285,284,"gen_concepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",16,1),
		
	/* Relaciones del concepto gen_familiaDeDatosKlw_familias  ***********  */
			(286,0,"gen_familiaDeDatosKlw_familias",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",62,0),
				(287,286,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(288,287,"gen_ai_es_gen_familiaDeDatosKlw_familias",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",61,1),
				(289,286,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
					(290,289,"gen_st_gen_familiaDeDatosKlw_fasmilias_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",3,2),
				(291,286,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
					(292,291,"gen_familiaDeDatosKlw",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",60,1),

	/* Relaciones del concepto gen_familiaDeDatosKlw_usuarios  ***********  */
			(293,0,"gen_familiaDeDatosKlw_usuarios",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",63,0),
				(294,293,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(295,294,"gen_ai_es_gen_familiaDeDatosKlw_usuarios",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",62,1),
				(296,293,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
					(297,296,"gen_st_gen_familiaDeDatosKlw_usuarios_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",4,2),
				(298,293,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
					(299,298,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,1),

	/* Relaciones del concepto gen_familiaDeDatosKlw_ai_es  ***********  */
			(300,0,"gen_familiaDeDatosKlw_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",64,0),
				(301,300,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(302,301,"gen_ai_es_gen_familiaDeDatosKlw_ai_es",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",63,1),
				(303,300,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
					(304,303,"gen_st_gen_familiaDeDatosKlw_ai_es_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",5,2),
				(305,300,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
					(306,305,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones del concepto gen_familiaDeDatosKlw_ai_ing  ***********  */
			(307,0,"gen_familiaDeDatosKlw_ai_ing",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",65,0),
				(308,307,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(309,308,"gen_ai_es_gen_familiaDeDatosKlw_ai_ing",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",64,1),
				(310,307,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
					(311,310,"gen_st_gen_familiaDeDatosKlw_ai_ing_prefijo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",6,2),
				(312,307,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
					(313,312,"gen_ayudaInterfazIng",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,1,"",5,1),

	/*  ****************  FIN DE conceptos DE BBDD KLW   *************************************  */	
	
	/*  ****************   conceptos AÑADIDOS POSTERIORMENTE los pongo todos aqui por no renumerarlo todo   *************************************  */	

		/* Relaciones del concepto gen_ParaConceptoNuevo  ***********  */
			(318,0,"gen_ParaConceptoNuevo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",67,0),
				(319,318,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(320,319,"gen_ai_es_gen_ParaConceptoNuevo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",70,1),

		/* Relaciones del concepto gen_recAyuIntf  ***********  */
			(322,0,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",68,0),
				(323,322,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,1),
				(324,322,"gen_recMaq",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,1),
				(325,322,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(326,325,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(327,326,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(328,327,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(329,326,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(330,329,"gen_st_nombreRecAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",6,2),
					/* descripcion */
						(331,326,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(332,331,"gen_st_descripcionRecAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",7,2),
					/* rotulo */
						(333,326,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(334,333,"gen_st_rotuloRecAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",8,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(335,326,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(336,335,"gen_st_iconoImagenConcepto_gen_recAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",9,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(337,326,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(338,337,"gen_st_iconoAudioConcepto_gen_recAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",10,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(339,326,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(340,339,"gen_st_imagenConcepto_gen_recAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",11,2),
				
		/* Relaciones del concepto gen_recMaq (recursos para la maquetacion o layout)  ***********  */
			(341,0,"gen_recMaq",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",69,0),
				(342,341,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(343,342,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(344,343,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(345,344,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(346,343,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(347,346,"gen_st_nombre_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",12,2),
					/* descripcion */
						(348,343,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(349,348,"gen_st_descripcion_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",13,2),
					/* rotulo */
						(350,343,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(351,350,"gen_st_rotulo_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",14,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(352,343,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(353,352,"gen_st_iconoImagenConcepto_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",15,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(354,343,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(355,354,"gen_st_iconoAudioConcepto_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",16,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(356,343,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(357,356,"gen_st_imagenConcepto_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",17,2),
				
		/* Relaciones del concepto gen_BuscadorKee_po_key_hos (busqueda por key y host)  ***********  */
			(358,0,"gen_BuscadorKee_por_key_host",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",76,0),
				/* definimos los recursos de ayuda a interfaz *** */
				(359,358,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					(360,359,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
						/* idioma español */
						(361,360,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(362,361,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
						/* nombre */
						(363,360,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(364,363,"gen_st_nombre_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",18,2),
						/* descripcion */
						(365,360,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(366,365,"gen_st_descripcion_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",19,2),
						/* rotulo */
						(367,360,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(368,367,"gen_st_rotulo_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",20,2),
						/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(369,360,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(370,369,"gen_st_iconoImagenConcepto_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",21,2),
						/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(371,360,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(372,371,"gen_st_iconoAudioConcepto_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",22,2),
						/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(373,360,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(374,373,"gen_st_imagenConcepto_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",23,2),
				/* definimos ahora el resto de la descripcion del concepto *** */
				/* gen_BuscadorKee_por_key_host instancia a gen_BuscadorKee */
				(392,358,"gen_BuscadorKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					/* como buscador, tiene una referencia a una referencia a gen_K y otra a gen_H  */
					(393,392,"gen_K",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",56,1),
					(394,392,"gen_H",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",59,1),
					(415,392,"gen_st_para_LlamadaFuncionKEE_funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",45,2),
					
		/* Relaciones del concepto gen_BuscadorKee  ***********  
				OJOOOO este concepto le pongo las dos configuraciones de ayuda a interfaz para probar  *************** */
			(252,0,"gen_BuscadorKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",58,0),
				(253,252,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(254,253,"gen_ai_es_gen_BuscadorKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",57,1),
				(375,252,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(376,375,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(377,376,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(378,377,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(379,376,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(380,379,"gen_st_nombre_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",24,2),
					/* descripcion */
						(381,376,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(382,381,"gen_st_descripcion_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",25,2),
					/* rotulo */
						(383,376,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(384,383,"gen_st_rotulo_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",26,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(395,376,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(385,395,"gen_st_iconoImagenConcepto_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",27,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(386,376,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(387,386,"gen_st_iconoAudioConcepto_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",28,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(388,376,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(389,388,"gen_st_imagenConcepto_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",29,2),
							
		/* Relaciones del concepto gen_botonKee  *************** */
			(396,0,"gen_botonKee",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",77,0),
				(397,396,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(398,397,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(399,398,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(400,399,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(401,398,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(402,401,"gen_st_nombre_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",38,2),
					/* descripcion */
						(403,398,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(404,403,"gen_st_descripcion_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",39,2),
					/* rotulo */
						(405,398,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(406,405,"gen_st_rotulo_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",40,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(407,398,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(408,407,"gen_st_iconoImagenConcepto_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",41,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(409,398,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(410,409,"gen_st_iconoAudioConcepto_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",42,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(411,398,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(412,411,"gen_st_imagenConcepto_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",43,2),
				/* definimos ahora el resto de la descripcion del concepto *** */
				/* Tiene basicamente un texto para indicar la identidad del boton y un ejecutable aue indica la funcion de codigo que se ejecuta al pulsarlo */
				(413,396,"gen_st_vacio_para_textoPlano","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",30,2),
				(414,396,"gen_st_vacio_para_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",37,2),
				
		/* Relaciones del concepto gen_tipoDeSinTecho_Url  *************** */
			(416,0,"gen_tipoDeSinTecho_Url",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",70,0),
				(417,416,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(418,417,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(419,418,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(420,419,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(421,418,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(422,421,"gen_st_nombre_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",80,2),
					/* descripcion */
						(423,418,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(424,423,"gen_st_descripcion_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",81,2),
					/* rotulo */
						(425,418,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(426,425,"gen_st_rotulo_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",46,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(427,418,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(428,427,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",47,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(429,418,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(430,429,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",48,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(431,418,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(432,431,"gen_st_imagenConcepto_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",49,2),
				(518,416,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				
		/* Relaciones del concepto gen_tipoDeSinTecho_FicheroGenerico  *************** */
			(433,0,"gen_tipoDeSinTecho_FicheroGenerico",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",71,0),
				(434,433,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(435,434,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(436,435,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(437,436,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(438,435,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(439,438,"gen_st_nombre_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",50,2),
					/* descripcion */
						(440,435,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(441,440,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",51,2),
					/* rotulo */
						(442,435,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(443,442,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",52,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(444,435,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(445,444,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",53,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(446,435,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(447,446,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",54,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(448,435,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(449,448,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",55,2),
				(519,433,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				
		/* Relaciones del concepto gen_tipoDeSinTecho_FicheroAudio  *************** */
			(450,0,"gen_tipoDeSinTecho_FicheroAudio",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",72,0),
				(451,450,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(452,451,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(453,452,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(454,453,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(455,452,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(456,455,"gen_st_nombre_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",56,2),
					/* descripcion */
						(457,452,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(458,457,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",57,2),
					/* rotulo */
						(459,452,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(460,459,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",58,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(461,452,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(462,461,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",59,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(463,452,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(464,463,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",60,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(465,452,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(466,465,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",62,2),
				(520,450,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				
		/* Relaciones del concepto gen_tipoDeSinTecho_FicheroImagen  *************** */
			(467,0,"gen_tipoDeSinTecho_FicheroImagen",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",73,0),
				(468,467,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(469,468,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(470,469,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(471,470,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(472,469,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(473,472,"gen_st_nombre_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",62,2),
					/* descripcion */
						(474,469,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(475,474,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",63,2),
					/* rotulo */
						(476,469,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(477,476,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",64,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(478,469,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(479,478,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",65,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(480,469,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(481,480,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",66,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(482,469,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(483,482,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",67,2),
				(521,467,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				
		/* Relaciones del concepto gen_tipoDeSinTecho_FicheroVideo  *************** */
			(484,0,"gen_tipoDeSinTecho_FicheroVideo",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",74,0),
				(485,484,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(486,485,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(487,486,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(488,487,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(489,486,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(490,489,"gen_st_nombre_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",68,2),
					/* descripcion */
						(491,486,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(492,491,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",69,2),
					/* rotulo */
						(493,486,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(494,493,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",70,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(495,486,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(496,495,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",71,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(497,486,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(498,497,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",72,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(499,486,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(500,499,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",73,2),
				(522,484,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				
		/* Relaciones del concepto gen_tipoDeSinTecho_LlamadaFuncionKEE  *************** */
			(501,0,"gen_tipoDeSinTecho_LlamadaFuncionKEE",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",75,0),
				(502,501,"gen_recAyuIntf",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(503,502,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
				/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
					/* idioma español */
						(504,503,"gen_idioma",@localizacion_DKS_LANGUAJES,@ordinalDeAlta,@tiemoDeAlta,0,"",2,0),
							(505,504,"gen_idioma_español",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
					/* nombre */
						(506,503,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
							(507,506,"gen_st_nombre_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",74,2),
					/* descripcion */
						(508,503,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
							(509,508,"gen_st_descripcion_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",75,2),
					/* rotulo */
						(510,503,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
							(511,510,"gen_st_rotulo_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",76,2),
					/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(512,503,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
							(513,512,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",77,2),
					/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(514,503,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
							(515,514,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",78,2),
					/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
						(516,503,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
							(517,516,"gen_st_imagenConcepto_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"",79,2),
				(523,501,"gen_tipoDeSinTecho",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",8,0),
				
		/* Relaciones del concepto gen_consultaaDKS  *************** */
			(524,0,"gen_consultaaDKS",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",13,0),
				(525,524,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",2,0),
					(526,525,"ggen_ai_es_gen_consultaaDKS",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",8,1);
				
/*  Conceptos basicos para este DKS especifico ***********  
insert  into `conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
 1 = Referencia ,  0 = Instancia  2=SinTecho
*/
		
	/*  ****************   FIN conceptos AÑADIDOS POSTERIORMENTE los pongo todos aqui por no renumerarlo todo   *************************************  */	
	

/*    Ultimo identificador utilizado para esta tabla de arriba es 526
			- 321 (para gen_idioma en gen_ayudaInterfaz 2021-11-08). 
			- 322 a 357 (para "gen_recAyuIntf" y "gen_recMaq" (2021-11-08).
			- 358 a 389 (para "gen_recAyuIntf" y "gen_recMaq" (2021-11-08).
			- 390 a 391 (para "poner un sin tcho vacio de texto plano en gen_K y gen_H  (2021-11-08).
			- 392 a 394 (para poner a gen_K y gen_H en la descripcion de "gen_BuscadorKee_por_key_host" (2021-11-08).
			- 395 (habia duplicado 384 (2021-11-08).
			- 396 a 414 (para poner la descripcion de "gen_botonKee" (2021-11-08).
			- 415 (para poner "gen_botonKee" en la descripcion de "gen_BuscadorKee_por_key_host" (2021-11-08).
			- 416 a 526 (para poner la descripcion de un monton de tipos sin techo que los habia dejado sin descripcion (2021-12-12).
			debes utilizar uno posterior para el siguiente registro 
			**********  */			
			
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
			(30,"gen_st_vacio_para_textoPlano","conceptos_sin_techo",0,0,"","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(31,"gen_st_vacio_para_NumeroEntero","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_NumeroEntero",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(32,"gen_st_vacio_para_Url","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_Url",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(33,"gen_st_vacio_para_FicheroGenerico","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroGenerico",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(34,"gen_st_vacio_para_FicheroAudio","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(35,"gen_st_vacio_para_FicheroImagen","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(36,"gen_st_vacio_para_FicheroVideo","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroVideo",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
					/* Para ficheros ejecutables que no tienen nada que ver con la interfaz de KEE */
			(44,"gen_st_vacio_para_FicheroEjecutableExterno","conceptos_sin_techo",0,0,"","gen_tipoDeSinTecho_FicheroEjecutableExterno",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
					/* Para ficheros que conoce la interfaz a priori y que pueden ejecutarse como funciones preexistentes en KEE */
						/* Para botones en general sin definicion especifica asociados a funciones conocidas por KEE */
			(37,"gen_st_vacio_para_LlamadaFuncionKEE","conceptos_sin_techo",0,0,"funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","gen_tipoDeSinTecho_LlamadaFuncionKEE",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
						/* Para que funcione como boton de busqueda en busqueda por Key y host "gen_BuscadorKee_por_key_host" en KEE */
			(45,"gen_st_para_LlamadaFuncionKEE_funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","conceptos_sin_techo",0,0,"funcionKEE_ActivadoBoton_BuscadorKee_por_key_host","gen_tipoDeSinTecho_LlamadaFuncionKEE",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   no se muy bien que es esto (2021-11-23) MAFG */
			(1,"gen_st_gen_ordinal_263","conceptos_sin_techo",0,0,"1","gen_numero",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de familias */
			(2,"gen_st_gen_familiaDeDatosKlw_conceptos_prefijo","conceptos_sin_techo",0,0,"","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(3,"gen_st_gen_familiaDeDatosKlw_fasmilias_prefijo","conceptos_sin_techo",0,0,"fam_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(4,"gen_st_gen_familiaDeDatosKlw_usuarios_prefijo","conceptos_sin_techo",0,0,"usr_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_gen_familiaDeDatosKlw_ai_es_prefijo","conceptos_sin_techo",0,0,"ai_es_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_recAyuIntf" */
			(6,"gen_st_nombreRecAyuIntf","conceptos_sin_techo",0,0,"Contenedor de recursos de interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(7,"gen_st_descripcionRecAyuIntf","conceptos_sin_techo",0,0,"Contiene ayudas a interfaz y recursos de maquetacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(8,"gen_st_rotuloRecAyuIntf","conceptos_sin_techo",0,0,"Recursos AI (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(9,"gen_st_iconoImagenConcepto_gen_recAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoRecursosAyudaInterfaz.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(10,"gen_st_iconoAudioConcepto_gen_recAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioRecursosAyudaIntf.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(11,"gen_st_imagenConcepto_gen_recAyuIntf","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_RecursosAyudaIntf.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_recMaq" */
			(12,"gen_st_nombre_gen_recMaq","conceptos_sin_techo",0,0,"Contenedor de recursos de maquetacion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(13,"gen_st_descripcion_gen_recMaq","conceptos_sin_techo",0,0,"Contiene recursos para la maquetacion o layout","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(14,"gen_st_rotulo_gen_recMaq","conceptos_sin_techo",0,0,"Recursos Maquetación (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(15,"gen_st_iconoImagenConcepto_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoRecursosMaquetacion.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(16,"gen_st_iconoAudioConcepto_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioRecursosMaquetacion.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(17,"gen_st_imagenConcepto_gen_recMaq","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_RecursosMaquetacion.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_BuscadorKee_por_key_host" */
			(18,"gen_st_nombre_gen_BuscadorKee_por_key_host","conceptos_sin_techo",0,0,"Buscador mediante Key y Host","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(19,"gen_st_descripcion_gen_BuscadorKee_por_key_host","conceptos_sin_techo",0,0,"Posibilita buscar un concepto mediante su key y host","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(20,"gen_st_rotulo_gen_BuscadorKee_por_key_host","conceptos_sin_techo",0,0,"Busqueda K H","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(21,"gen_st_iconoImagenConcepto_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"icono_BuscadorKH.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(22,"gen_st_iconoAudioConcepto_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudio_BuscadorKH.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(23,"gen_st_imagenConcepto_gen_BuscadorKee_por_key_host","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_BuscadorKH.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_BuscadorKee" */
			(24,"gen_st_nombre_gen_BuscadorKee","conceptos_sin_techo",0,0,"Buscador","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(25,"gen_st_descripcion_gen_BuscadorKee","conceptos_sin_techo",0,0,"Posibilita busqueda de conceptos e  general","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(26,"gen_st_rotulo_gen_BuscadorKee","conceptos_sin_techo",0,0,"Buscador","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(27,"gen_st_iconoImagenConcepto_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgBusqueda.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(28,"gen_st_iconoAudioConcepto_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioBuscador.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(29,"gen_st_imagenConcepto_gen_BuscadorKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Buscador.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_botonKee" */
			(38,"gen_st_nombre_gen_botonKee","conceptos_sin_techo",0,0,"Boton","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(39,"gen_st_descripcion_gen_botonKee","conceptos_sin_techo",0,0,"Boton que genera una accion al pulsar expandir","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(40,"gen_st_rotulo_gen_botonKee","conceptos_sin_techo",0,0,"Boton","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(41,"gen_st_iconoImagenConcepto_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImg_botonKee.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(42,"gen_st_iconoAudioConcepto_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudio_botonKee.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(43,"gen_st_imagenConcepto_gen_botonKee","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_botonKee.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de "gen_tipoDeSinTecho_Url" */
			(80,"gen_st_nombre_gen_tipoDeSinTecho_Url","conceptos_sin_techo",0,0,"URL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(81,"gen_st_descripcion_gen_tipoDeSinTecho_Url","conceptos_sin_techo",0,0,"Recurso web","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(46,"gen_st_rotulo_gen_tipoDeSinTecho_Url","conceptos_sin_techo",0,0,"URL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(47,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPorDefecto.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(48,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(49,"gen_st_imagenConcepto_gen_tipoDeSinTecho_Url","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenSinImagen.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_tipoDeSinTecho_FicheroGenerico" */
			(50,"gen_st_nombre_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",0,0,"Fichero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(51,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",0,0,"Fichero Generico","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(52,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",0,0,"Fichero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(53,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPorDefecto.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(54,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(55,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroGenerico","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenSinImagen.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_tipoDeSinTecho_FicheroAudio" */
			(56,"gen_st_nombre_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",0,0,"Audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(57,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",0,0,"Fichero de audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(58,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",0,0,"Audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(59,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPorDefecto.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(60,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(61,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroAudio","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenSinImagen.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_tipoDeSinTecho_FicheroImagen" */
			(62,"gen_st_nombre_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",0,0,"Imagen","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(63,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",0,0,"Fichero de imagen","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(64,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",0,0,"Imagen","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(65,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPorDefecto.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(66,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(67,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroImagen","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenSinImagen.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_tipoDeSinTecho_FicheroVideo" */
			(68,"gen_st_nombre_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",0,0,"Video","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(69,"gen_st_descripcion_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",0,0,"Ficehro de video","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(70,"gen_st_rotulo_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",0,0,"Video","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(71,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPorDefecto.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(72,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(73,"gen_st_imagenConcepto_gen_tipoDeSinTecho_FicheroVideo","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenSinImagen.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de "gen_tipoDeSinTecho_LlamadaFuncionKEE" */
			(74,"gen_st_nombre_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",0,0,"Funcion KEE","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(75,"gen_st_descripcion_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",0,0,"Llama a una funcion de la interfaz KEE","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(76,"gen_st_rotulo_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",0,0,"Funcion KEE","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(77,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPorDefecto.png","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(78,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPorDefecto.wav","gen_tipoDeSinTecho_FicheroAudio",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(79,"gen_st_imagenConcepto_gen_tipoDeSinTecho_LlamadaFuncionKEE","conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ImagenSinImagen.jpg","gen_tipoDeSinTecho_FicheroImagen",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
/*    Ultimo identificador utilizado para esta tabla de arriba es 81  debes utilizar uno posterior para el siguiente registro
			- 12 a 17 (para gen_recMaq 2021-11-08).  
			- 18 a 23 (para gen_BuscadorKee_por_key_host 2021-11-23). 
			- 24 a 29 (para gen_BuscadorKee 2021-11-23). OJO este concept tiene descripciones de ayuda a interfaz en ambas versiones (vieja y nueva 2021-11) 
			- 30 a 37 (para sin techo vacios con diferentes tipos de datos 2021-11-23). 
			- 38 a 43 (para sin techo de "gen_botonKee" 2021-11-23). 
			- 44 (para sin techo de "gen_st_vacio_para_FicheroEjecutableExterno" 2021-11-25). 
			- 45 (para sin techo de "gen_st_para_LlamadaFuncionKEE_funcionKEE_ActivadoBoton_BuscadorKee_por_key_host" 2021-11-25). 
			- 46 a 81 (para un monton de tipos de sin techo  2021-12-12). 
			**********  */		

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
					(3,2,"gen_ai_es_gen_Familia_Conceptos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",65,1),
				(4,1,"gen_familiaDeDatosKlw_conceptos",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",61,0),
					(5,4,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(6,5,"gen_st_gen_Familia_Conceptos_prefijo","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",1,2),
					(7,4,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(8,7,"gen_concepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",16,1),

	/* Relaciones de ayuda interfaz del concepto gen_Familia_Familias_fam  ***********  */
			(9,0,"gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",2,0),
				(10,9,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(11,10,"gen_ai_es_gen_Familia_Familias_fam",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",66,1),
				(12,9,"gen_familiaDeDatosKlw_familias",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",62,0),
					(13,4,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(14,13,"gen_st_gen_Familia_Familias_fam","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",2,2),
					(15,4,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(16,15,"gen_familiaDeDatosKlw",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",60,1),

	/* Relaciones de ayuda interfaz del concepto gen_Familia_Usuarios_usr  ***********  */
			(17,0,"gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",3,0),
				(18,17,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(19,18,"gen_ai_es_gen_Familia_Usuarios_usr",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",67,1),
				(20,17,"gen_familiaDeDatosKlw_usuarios",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",63,0),
					(21,20,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(22,13,"gen_st_gen_Familia_Usuarios_usr","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",3,2),
					(23,20,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(24,15,"gen_usuario",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",10,1),

	/* Relaciones de ayuda interfaz del concepto gen_Familia_AyudaIntEsp_ai_es  ***********  */
			(25,0,"gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"fam_",4,0),
				(26,25,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
					(27,26,"gen_ai_es_gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",68,1),
				(28,25,"gen_familiaDeDatosKlw_ai_es",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",64,0),
					(29,28,"gen_prefijo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",60,0),
						(30,29,"gen_st_gen_Familia_AyudaIntEsp_ai_es","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"fam_",4,2),
					(31,28,"gen_contiene",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",61,0),
						(32,31,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",2,0),
							(33,32,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1);

	/*    Ultimo identificador utilizado para esta tabla de arriba   32, debes utilizar uno posterior para el siguiente registro **********  */			
			
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
			(4,"gen_st_gen_Familia_AyudaIntEsp_ai_es","fam_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"ai_es_","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);


	/*    Ultimo identificador utilizado para esta tabla de arriba   4, debes utilizar uno posterior para el siguiente registro **********  */			
	
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
	
/* MODIFICAR: esta sentencia que sigue da problemas, pero no soy capaz de identificarlos, al ejecutarla, la BBDD da un error de :
	Column 'LocalizacionUsuario' cannot be null
	He comprobado, que este error
	solo aparece si hay una sola linea de values en la sentencia (si aqui pongo dos valores, deja de aparecer el error
	en este caso solucion poniendo otra sentencia  mas, la del usuario 0, que no estaba a priori, para que apareccan mas de una linea de valores.
	COmento el estado anterior para documentar el problema
	SIn embargo, en otras BBDD, con la misma sentencia lo admite sin problemas (2011-11-05) 
	Pasa lo mismo con la sentencia que aparece en la tabla "ai_es_conceptos"    * *
insert  into `usr_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/*  Generamos un usuario administrador al arracar la BBDD, para que aparezca un usuario al dar de alta el sistema  *
			(1000,"gen_usuarioAdministradorLocal1",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);  *** */

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

/*  *********************************   INICIO TABLAS DE IDIOMAS PARA AYUDA A INTERFAZ (una por cada idioma) ********************************* */
	
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
/*   me falta este			(3,2,"gen_ai_es_gen_ayudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,1),  */
		(2,"gen_ai_es_tipoDeSinTecho",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(3,"gen_ai_es_tipoDeSinTechoTextoPlano",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(8,"gen_ai_es_gen_consultaaDKS",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(9,"gen_ai_es_tipoDeSinTechoClaveEncriptada",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(10,"gen_ai_es_gen_ayudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(14,"gen_ai_es_gen_KLW",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(15,"gen_ai_es_gen_concepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(16,"gen_ai_es_gen_KDL",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(17,"gen_ai_es_gen_I",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(18,"gen_ai_es_gen_K",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(19,"gen_ai_es_gen_H",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(20,"gen_ai_es_gen_F",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(21,"gen_ai_es_gen_O",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(22,"gen_ai_es_gen_M",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(23,"gen_ai_es_gen_D",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(24,"gen_ai_es_gen_E",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(25,"gen_ai_es_gen_A",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(26,"gen_ai_es_gen_R",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(27,"gen_ai_es_gen_Z",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(28,"gen_ai_es_gen_T",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(29,"gen_ai_es_gen_P",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(30,"gen_ai_es_gen_L",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(35,"gen_ai_es_gen_solicitudADks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(36,"gen_ai_es_gen_getDetails",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(37,"gen_ai_es_gen_respuestaAsolicitudADks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(39,"gen_ai_es_gen_errorDeAccesoABbdd",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(40,"gen_ai_es_gen_errorKLW",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(41,"gen_ai_es_gen_getAyudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(42,"gen_ai_es_gen_configuracionDeAcceso",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(43,"gen_ai_es_gen_iconoImagenConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(44,"gen_ai_es_gen_iconoAudioConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(45,"gen_ai_es_gen_imagenConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(46,"gen_ai_es_gen_interfazKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(47,"gen_ai_es_gen_listaEntornos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(48,"gen_ai_es_gen_entornoDeTrabajoKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(49,"gen_ai_es_gen_listaRequerimientosKEE",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(50,"gen_ai_es_gen_requerimientoKEE",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(51,"gen_ai_es_gen_ListaConceptosPresentes",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(52,"gen_ai_es_gen_getConceptoInterfazUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(53,"gen_ai_es_gen_ConceptoEfimero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(54,"gen_ai_es_gen_errorEnAyudaInterfazKlw",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(55,"gen_ai_es_gen_PrivacidadDeDatos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(56,"gen_ai_es_gen_tipoDeSinTechoRecursoWeb",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(57,"gen_ai_es_gen_BuscadorKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(58,"gen_ai_es_gen_listaDeIdiomasDeInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(59,"gen_ai_es_gen_familiaDeDatosKlw",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(60,"gen_ai_es_gen_familiaDeDatosKlw_conceptos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(61,"gen_ai_es_gen_familiaDeDatosKlw_familias",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(62,"gen_ai_es_gen_familiaDeDatosKlw_usuarios",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(63,"gen_ai_es_gen_familiaDeDatosKlw_ai_es",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(64,"gen_ai_es_gen_familiaDeDatosKlw_ai_ing",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(65,"gen_ai_es_gen_Familia_Conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(66,"gen_ai_es_gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(67,"gen_ai_es_gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(68,"gen_ai_es_gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(69,"gen_ai_es_tipoDeSinTecho_NumeroEntero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
		(70,"gen_ai_es_gen_ParaConceptoNuevo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
/*    Ultimo identificador utilizado para esta tabla de arriba   70, debes utilizar uno posterior para el siguiente registro **********  */			
			
/*  Conceptos para DKS BASICO ***********  */
/* MODIFICAR: esta sentencia que sigue da problemas, pero no soy capaz de identificarlos, al ejecutarla, la BBDD da un error de :
	Column 'LocalizacionUsuario' cannot be null
	Pero si copio y pego los values en la sentencia anterior no lo da. No entiendo porque. SI he comprobado, que este error
	solo aparece si hay una sola linea de values en la sentencia (si aqui pongo dos valores, deja de aparecer el error
	en este caso solucion convirtiendo las dos sentencias en una sola, para que apareccan mas de una linea de valores.
	COmento el estado anterior para documentar el problema(2011-11-05) 
	Pasa lo mismo con la sentencia que aparece en la tabla "usr_conceptos" 
	SIn embargo, en otras BBDD, con la misma sentencia lo admite sin problemas* *
insert  into `ai_es_conceptos`(`IdConcepto`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	***  */
			(1000,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
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
	/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho en español  ***********  */
			(8,0,"gen_ai_es_tipoDeSinTecho",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",2,0),
		/* nombre */
			(9,8,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(10,9,"gen_st_nombreTipoDeDato","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",4,2),
		/* descripcion */
			(11,8,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(12,11,"gen_st_descripcionTipoDeDato","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",5,2),
		/* rotulo */
			(13,8,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(14,13,"gen_st_rotuloTipoDeDato","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",6,2),

			(439,8,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(440,439,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTechoTextoPlano en español  ***********  */
			(15,0,"gen_ai_es_tipoDeSinTechoTextoPlano",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,0),
		/* nombre */
				(16,15,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(17,16,"gen_st_nombreTipoTextoPLano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",7,2),
		/* descripcion */
				(18,15,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(19,18,"gen_st_descripcionTipoTextoPLano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",8,2),
		/* rotulo */
				(20,15,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(21,20,"gen_st_rotuloTipoTextoPLano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",9,2),

				(441,15,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(442,441,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(523,15,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(524,523,"gen_st_iconoImagenConcepto_gen_tipoDeSinTechoTextoPlano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",193,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(525,15,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(526,525,"gen_st_iconoAudioConcepto_gen_tipoDeSinTechoTextoPlano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",194,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(527,15,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(528,527,"gen_st_imagenConcepto_gen_tipoDeSinTechoTextoPlano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",195,2),

				(529,15,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(530,529,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),


	/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTecho_NumeroEntero en español  ***********  */
			(742,0,"gen_ai_es_tipoDeSinTecho_NumeroEntero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",69,0),
		/* nombre */
				(743,742,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(744,743,"gen_st_nombre_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",280,2),
		/* descripcion */
				(745,742,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(746,745,"gen_st_descripcion_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",281,2),
		/* rotulo */
				(747,742,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(748,747,"gen_st_rotulo_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",282,2),

				(749,742,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(780,749,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(781,742,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(782,781,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",283,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(783,742,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(784,783,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",284,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(785,742,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(786,785,"gen_st_imagenConcepto_gen_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",285,2),

				(787,742,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(788,787,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_tipoDeSinTechoClaveEncriptada en español  ***********  */
			(22,0,"gen_ai_es_tipoDeSinTechoClaveEncriptada",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",3,0),
		/* nombre */
			(23,22,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(24,23,"gen_st_nombreTipoClaveEncriptada","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",25,2),
		/* descripcion */
			(25,22,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(26,25,"gen_st_descripcionTipoClaveEncriptada","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",26,2),
		/* rotulo */
			(27,22,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(28,27,"gen_st_rotuloTipoClaveEncriptada","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",27,2),

			(443,2,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(444,443,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
	
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_consultaaDKS  ***********  */
			(57,0,"gen_ai_es_gen_consultaaDKS",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",8,0),
		/* nombre */
			(58,57,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(59,58,"gen_st_nombreConsultaaDKS","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",22,2),
		/* descripcion */
			(60,57,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(61,60,"gen_st_descripcionConsultaaDKS","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",23,2),
		/* rotulo */
			(62,57,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(63,62,"gen_st_rotuloConsultaaDKS","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",24,2),

			(445,57,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(446,445,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_ayudaInterfaz  ***********  */
			(64,0,"gen_ai_es_gen_ayudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",10,0),
		/* nombre */
			(65,64,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(66,65,"gen_st_nombreAyudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",28,2),
		/* descripcion */
			(67,64,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(68,67,"gen_st_descripcionAyudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",29,2),
		/* rotulo */
			(69,64,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(70,69,"gen_st_rotuloAyudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",30,2),

			(447,64,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(448,447,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(316,64,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
			(317,316,"gen_st_iconoImagenConcepto_gen_ayudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",136,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(318,64,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
			(319,318,"gen_st_iconoAudioConcepto_gen_ayudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",137,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
			(320,64,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
			(321,320,"gen_st_imagenConcepto_gen_ayudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",138,2),

			(449,316,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(450,449,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_KLW  ***********  */
			(92,0,"gen_ai_es_gen_KLW",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",14,0),
		/* nombre */
			(93,92,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(94,93,"gen_st_nombreKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",40,2),
		/* descripcion */
			(95,92,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(96,95,"gen_st_descripcionKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",41,2),
		/* rotulo */
			(97,92,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(98,97,"gen_st_rotuloKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,2),

			(451,92,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(452,451,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_concepto  ***********  */
			(99,0,"gen_ai_es_gen_concepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",15,0),
		/* nombre */
			(100,99,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(101,100,"gen_st_nombreconcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",43,2),
		/* descripcion */
			(102,99,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(103,102,"gen_st_descripcionconcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",44,2),
		/* rotulo */
			(104,99,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(105,104,"gen_st_rotuloconcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",45,2),

			(453,99,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(454,453,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_KDL  ***********  */
			(106,0,"gen_ai_es_gen_KDL",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",16,0),
		/* nombre */
			(107,106,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(108,107,"gen_st_nombreKDL","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",46,2),
		/* descripcion */
			(109,106,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(110,109,"gen_st_descripcionKDL","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",47,2),
		/* rotulo */
			(111,106,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(112,111,"gen_st_rotuloKDL","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",48,2),

			(455,106,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(456,455,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_I  ***********  */
			(113,0,"gen_ai_es_gen_I",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",17,0),
		/* nombre */
			(114,113,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(115,114,"gen_st_nombreI","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",49,2),
		/* descripcion */
			(116,113,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(117,116,"gen_st_descripcionI","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",50,2),
		/* rotulo */
			(118,113,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(119,118,"gen_st_rotuloI","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",51,2),

			(457,113,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(458,457,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_K  ***********  */
			(120,0,"gen_ai_es_gen_K",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",18,0),
		/* nombre */
			(121,120,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(122,121,"gen_st_nombreK","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",52,2),
		/* descripcion */
			(123,120,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(124,123,"gen_st_descripcionK","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",53,2),
		/* rotulo */
			(125,120,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(126,125,"gen_st_rotuloK","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",54,2),

		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(804,120,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(805,804,"gen_st_iconoImagenConcepto_gen_K","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",292,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(806,120,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(807,806,"gen_st_iconoAudioConcepto_gen_K","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",293,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(808,120,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(809,808,"gen_st_imagenConcepto_gen_K","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",294,2),

			(459,120,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(460,459,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_H  ***********  */
			(127,0,"gen_ai_es_gen_H",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",19,0),
		/* nombre */
			(128,127,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(129,128,"gen_st_nombreH","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,2),
		/* descripcion */
			(130,127,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(131,130,"gen_st_descripcionH","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",56,2),
		/* rotulo */
			(132,127,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(133,132,"gen_st_rotuloH","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",57,2),

		/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(810,127,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(811,810,"gen_st_iconoImagenConcepto_gen_H","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",295,2),
		/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(812,127,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(813,812,"gen_st_iconoAudioConcepto_gen_H","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",296,2),
		/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(814,127,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(815,814,"gen_st_imagenConcepto_gen_H","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",297,2),
			
			(461,127,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(462,461,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_F  ***********  */
			(134,0,"gen_ai_es_gen_F",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",20,0),
		/* nombre */
			(135,134,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(136,135,"gen_st_nombreF","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",58,2),
		/* descripcion */
			(137,134,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(138,137,"gen_st_descripcionF","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",59,2),
		/* rotulo */
			(139,134,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(140,139,"gen_st_rotuloF","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",60,2),

			(463,134,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(464,463,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_O  ***********  */
			(141,0,"gen_ai_es_gen_O",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",21,0),
		/* nombre */
			(142,141,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(143,142,"gen_st_nombreO","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",61,2),
		/* descripcion */
			(144,141,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(145,144,"gen_st_descripcionO","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",62,2),
		/* rotulo */
			(146,141,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(147,146,"gen_st_rotuloO","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",63,2),

			(465,141,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(466,465,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_M  ***********  */
			(148,0,"gen_ai_es_gen_M",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",22,0),
		/* nombre */
			(149,148,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(150,149,"gen_st_nombreM","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",64,2),
		/* descripcion */
			(151,148,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(152,151,"gen_st_descripcionM","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",65,2),
		/* rotulo */
			(153,148,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(154,153,"gen_st_rotuloM","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",66,2),

			(467,148,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(468,467,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_D  ***********  */
			(155,0,"gen_ai_es_gen_D",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",23,0),
		/* nombre */
			(156,155,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(157,156,"gen_st_nombreD","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",67,2),
		/* descripcion */
			(158,155,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(159,158,"gen_st_descripcionD","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",68,2),
		/* rotulo */
			(160,155,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(161,160,"gen_st_rotuloD","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",69,2),

			(469,155,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(470,469,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_E  ***********  */
			(162,0,"gen_ai_es_gen_E",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",24,0),
		/* nombre */
			(163,162,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(164,163,"gen_st_nombreE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",70,2),
		/* descripcion */
			(165,162,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(166,165,"gen_st_descripcionE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",71,2),
		/* rotulo */
			(167,162,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(168,167,"gen_st_rotuloE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",72,2),

			(471,162,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(472,471,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_A  ***********  */
			(169,0,"gen_ai_es_gen_A",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",25,0),
		/* nombre */
			(170,169,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(171,170,"gen_st_nombreA","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",73,2),
		/* descripcion */
			(172,169,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(173,172,"gen_st_descripcionA","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",74,2),
		/* rotulo */
			(174,169,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(175,174,"gen_st_rotuloA","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",75,2),

			(473,169,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(474,473,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_R  ***********  */
			(176,0,"gen_ai_es_gen_R",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",26,0),
		/* nombre */
			(177,176,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(178,177,"gen_st_nombreR","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",76,2),
		/* descripcion */
			(179,176,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(180,179,"gen_st_descripcionR","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",77,2),
		/* rotulo */
			(181,176,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(182,181,"gen_st_rotuloR","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",78,2),

			(475,176,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(476,475,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Z  ***********  */
			(183,0,"gen_ai_es_gen_Z",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",27,0),
		/* nombre */
			(184,183,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(185,184,"gen_st_nombreZ","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",79,2),
		/* descripcion */
			(186,183,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(187,186,"gen_st_descripcionZ","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",80,2),
		/* rotulo */
			(188,183,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(189,188,"gen_st_rotuloZ","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",81,2),

			(477,183,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(478,477,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_T  ***********  */
			(190,0,"gen_ai_es_gen_T",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",28,0),
		/* nombre */
			(191,190,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(192,191,"gen_st_nombreT","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",82,2),
		/* descripcion */
			(193,190,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(194,193,"gen_st_descripcionT","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",83,2),
		/* rotulo */
			(195,190,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(196,195,"gen_st_rotuloT","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",84,2),

			(479,190,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(480,479,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_P  ***********  */
			(197,0,"gen_ai_es_gen_P",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",29,0),
		/* nombre */
			(198,197,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(199,198,"gen_st_nombreP","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",85,2),
		/* descripcion */
			(200,197,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(201,1200,"gen_st_descripcionP","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",86,2),
		/* rotulo */
			(202,197,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(203,202,"gen_st_rotuloP","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",87,2),

			(481,197,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(482,481,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_L  ***********  */
			(204,0,"gen_ai_es_gen_L",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",30,0),
		/* nombre */
			(205,204,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(206,205,"gen_st_nombreL","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",88,2),
		/* descripcion */
			(207,204,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(208,207,"gen_st_descripcionL","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",89,2),
		/* rotulo */
			(209,204,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(210,209,"gen_st_rotuloL","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",90,2),

			(483,204,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(484,483,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
		/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_solicitudADks  ***********  */
			(239,0,"gen_ai_es_gen_solicitudADks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",35,0),
		/* nombre */
			(240,239,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(241,240,"gen_st_nombresolicitudADks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",103,2),
		/* descripcion */
			(242,239,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(243,242,"gen_st_descripcionsolicitudADks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",104,2),
		/* rotulo */
			(244,239,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(245,244,"gen_st_rotulosolicitudADks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",105,2),

			(485,239,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(486,485,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_getDetails  ***********  */
			(246,0,"gen_ai_es_gen_getDetails",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",36,0),
		/* nombre */
			(247,246,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(248,247,"gen_st_nombregetDetails","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",106,2),
		/* descripcion */
			(249,246,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(250,249,"gen_st_descripciongetDetails","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",107,2),
		/* rotulo */
			(251,246,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(252,251,"gen_st_rotulogetDetails","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",108,2),

			(487,246,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(488,487,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_getAyudaInterfaz  ***********  */
			(281,0,"gen_ai_es_gen_getAyudaInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",36,0),
		/* nombre */
			(282,281,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(283,282,"gen_st_nombre_gen_ai_es_gen_getAyudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",121,2),
		/* descripcion */
			(284,281,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(285,284,"gen_st_descripcion_gen_ai_es_gen_getAyudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",122,2),
		/* rotulo */
			(286,281,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(287,286,"gen_st_rotulo_gen_ai_es_gen_getAyudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",123,2),

			(489,281,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(490,489,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_respuestaAsolicitudADks  ***********  */
			(253,0,"gen_ai_es_gen_respuestaAsolicitudADks",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",37,0),
		/* nombre */
			(254,253,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(255,254,"gen_st_nombrerespuestaAsolicitudADks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",109,2),
		/* descripcion */
			(256,253,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(257,256,"gen_st_descripcionrespuestaAsolicitudADks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",110,2),
		/* rotulo */
			(258,253,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(259,258,"gen_st_rotulorespuestaAsolicitudADks","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",111,2),

			(491,253,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(492,491,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_errorDeAccesoABbdd  ***********  */
			(267,0,"gen_ai_es_gen_errorDeAccesoABbdd",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",39,0),
		/* nombre */
			(268,267,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(269,268,"gen_st_nombreerrorDeAccesoABbdd","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",115,2),
		/* descripcion */
			(270,267,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(271,270,"gen_st_descripcionerrorDeAccesoABbdd","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",116,2),
		/* rotulo */
			(272,267,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(273,272,"gen_st_rotuloerrorDeAccesoABbdd","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",117,2),

			(493,267,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(494,493,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_errorKLW  ***********  */
			(274,0,"gen_ai_es_gen_errorKLW",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",40,0),
			/* nombre */
				(275,274,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(276,275,"gen_st_nombreerrorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",118,2),
			/* descripcion */
				(277,274,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(278,277,"gen_st_descripcionerrorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",119,2),
			/* rotulo */
				(279,274,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(280,279,"gen_st_rotuloerrorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",120,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(420,274,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(421,420,"gen_st_iconoImagenConcepto_gen_errorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",184,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(422,274,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(423,422,"gen_st_iconoAudioConcepto_gen_errorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",185,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(424,274,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(425,424,"gen_st_imagenConcepto_gen_errorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",186,2),

			(495,274,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(496,495,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_configuracionDeAcceso  ***********  */
			(288,0,"gen_ai_es_gen_configuracionDeAcceso",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,0),
		/* nombre */
			(289,288,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(290,289,"gen_st_nombre_gen_configuracionDeAcceso","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",124,2),
		/* descripcion */
			(291,288,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(292,291,"gen_st_descripcion_gen_configuracionDeAcceso","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",125,2),
		/* rotulo */
			(293,288,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(294,293,"gen_st_rotulo_gen_configuracionDeAcceso","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",126,2),

			(497,288,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(498,497,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_iconoImagenConcepto  ***********  */
			(295,0,"gen_ai_es_gen_iconoImagenConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,0),
		/* nombre */
			(296,295,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(297,296,"gen_st_nombre_gen_iconoImagenConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",127,2),
		/* descripcion */
			(298,295,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(299,298,"gen_st_descripcion_gen_iconoImagenConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",128,2),
		/* rotulo */
			(300,295,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(301,300,"gen_st_rotulo_gen_iconoImagenConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",129,2),

			(499,295,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(500,499,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_iconoAudioConcepto  ***********  */
			(302,0,"gen_ai_es_gen_iconoAudioConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,0),
		/* nombre */
			(303,302,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(304,303,"gen_st_nombre_gen_iconoAudioConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",130,2),
		/* descripcion */
			(305,302,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(306,305,"gen_st_descripcion_gen_iconoAudioConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",131,2),
		/* rotulo */
			(307,302,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(308,307,"gen_st_rotulo_gen_iconoAudioConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",132,2),

			(501,302,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(502,501,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_imagenConcepto  ***********  */
			(309,0,"gen_ai_es_gen_imagenConcepto",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",42,0),
		/* nombre */
			(310,309,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
			(311,310,"gen_st_nombre_gen_imagenConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",133,2),
		/* descripcion */
			(312,309,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
			(313,312,"gen_st_descripcion_gen_imagenConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",134,2),
		/* rotulo */
			(314,309,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
			(315,314,"gen_st_rotulo_gen_imagenConcepto","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",135,2),

			(503,309,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(504,503,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_interfazKee  ***********  */
			(322,0,"gen_ai_es_gen_interfazKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",46,0),
			/* nombre */
				(323,322,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(324,323,"gen_st_nombre_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",139,2),
			/* descripcion */
				(325,322,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(326,325,"gen_st_descripcion_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",140,2),
			/* rotulo */
				(327,322,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(328,327,"gen_st_rotulo_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",141,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(329,322,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(330,329,"gen_st_iconoImagenConcepto_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",142,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(331,322,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(332,331,"gen_st_iconoAudioConcepto_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",143,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(333,322,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(334,333,"gen_st_imagenConcepto_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",144,2),

			(505,322,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(506,505,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_listaEntornos  ***********  */
			(335,0,"gen_ai_es_gen_listaEntornos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",47,0),
			/* nombre */
				(336,335,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(337,336,"gen_st_nombre_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",145,2),
			/* descripcion */
				(338,335,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(339,338,"gen_st_descripcion_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",146,2),
			/* rotulo */
				(340,335,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(341,340,"gen_st_rotulo_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",147,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(342,335,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(343,342,"gen_st_iconoImagenConcepto_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",148,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(344,335,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(345,344,"gen_st_iconoAudioConcepto_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",149,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(346,335,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(347,346,"gen_st_imagenConcepto_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",150,2),

			(507,335,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(508,507,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_entornoDeTrabajoKee  ***********  */
			(348,0,"gen_ai_es_gen_entornoDeTrabajoKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",48,0),
			/* nombre */
				(349,348,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(350,349,"gen_st_nombre_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",151,2),
			/* descripcion */
				(351,348,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(352,351,"gen_st_descripcion_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",152,2),
			/* rotulo */
				(353,348,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(354,353,"gen_st_rotulo_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",153,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(355,348,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(356,355,"gen_st_iconoImagenConcepto_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",154,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(357,348,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(358,357,"gen_st_iconoAudioConcepto_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",155,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(359,348,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(360,359,"gen_st_imagenConcepto_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",156,2),

			(509,348,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(510,509,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_listaRequerimientosKEE  ***********  */
			(361,0,"gen_ai_es_gen_listaRequerimientosKEE",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",49,0),
			/* nombre */
				(362,361,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(363,362,"gen_st_nombre_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",157,2),
			/* descripcion */
				(364,361,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(365,364,"gen_st_descripcion_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",158,2),
			/* rotulo */
				(366,361,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(367,366,"gen_st_rotulo_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",159,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(368,361,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(369,368,"gen_st_iconoImagenConcepto_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",160,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(370,361,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(371,370,"gen_st_iconoAudioConcepto_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",161,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(372,361,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(373,372,"gen_st_imagenConcepto_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",162,2),

			(511,361,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(512,511,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_requerimientoKEE  ***********  */
			(374,0,"gen_ai_es_gen_requerimientoKEE",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",50,0),
			/* nombre */
				(375,374,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(376,375,"gen_st_nombre_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",163,2),
			/* descripcion */
				(377,374,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(378,377,"gen_st_descripcion_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",164,2),
			/* rotulo */
				(379,374,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(380,379,"gen_st_rotulo_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",165,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(381,374,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(382,381,"gen_st_iconoImagenConcepto_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",166,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(383,374,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(384,383,"gen_st_iconoAudioConcepto_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",167,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(385,374,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(386,385,"gen_st_imagenConcepto_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",168,2),

				(513,374,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(514,513,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			
	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_ListaConceptosPresentes  ***********  */
			(387,0,"gen_ai_es_gen_ListaConceptosPresentes",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",51,0),
			/* nombre */
				(388,387,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(389,388,"gen_st_nombre_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",169,2),
			/* descripcion */
				(390,387,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(391,390,"gen_st_descripcion_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",170,2),
			/* rotulo */
				(392,387,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(393,392,"gen_st_rotulo_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",171,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(394,387,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(395,394,"gen_st_iconoImagenConcepto_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",172,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(396,387,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(397,396,"gen_st_iconoAudioConcepto_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",173,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(398,387,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(399,398,"gen_st_imagenConcepto_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",174,2),

			(515,387,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(516,515,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_getConceptoInterfazUsuario  ***********  */
			(400,0,"gen_ai_es_gen_getConceptoInterfazUsuario",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",52,0),
			/* nombre */
				(401,400,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(402,401,"gen_st_nombre_gen_getConceptoInterfazUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",175,2),
			/* descripcion */
				(403,400,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(404,403,"gen_st_descripcion_gen_getConceptoInterfazUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",176,2),
			/* rotulo */
				(405,400,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(406,405,"gen_st_rotulo_gen_getConceptoInterfazUsuario","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",177,2),

			(517,400,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(518,517,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_ConceptoEfimero  ***********  */
			(407,0,"gen_ai_es_gen_ConceptoEfimero",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",53,0),
			/* nombre */
				(408,407,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(409,408,"gen_st_nombre_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",178,2),
			/* descripcion */
				(410,407,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(411,410,"gen_st_descripcion_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",179,2),
			/* rotulo */
				(412,407,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(413,412,"gen_st_rotulo_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",180,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(414,407,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(415,414,"gen_st_iconoImagenConcepto_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",181,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(416,407,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(417,416,"gen_st_iconoAudioConcepto_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",182,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(418,407,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(419,418,"gen_st_imagenConcepto_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",183,2),

			(519,407,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
				(520,519,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_errorEnAyudaInterfazKlw  ***********  */
			(426,0,"gen_ai_es_gen_errorEnAyudaInterfazKlw",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",54,0),
			/* nombre */
				(427,426,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(428,427,"gen_st_nombre_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",187,2),
			/* descripcion */
				(429,426,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(430,429,"gen_st_descripcion_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",188,2),
			/* rotulo */
				(431,426,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(432,431,"gen_st_rotulo_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",189,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(433,426,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(434,433,"gen_st_iconoImagenConcepto_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",190,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(435,426,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(436,435,"gen_st_iconoAudioConcepto_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",191,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(437,426,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(438,437,"gen_st_imagenConcepto_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",192,2),

				(521,426,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(522,521,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_PrivacidadDeDatos  ***********  */
			(531,0,"gen_ai_es_gen_PrivacidadDeDatos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,0),
			/* Ayuda a interfaz del concepto */
				(532,531,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(533,532,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(534,531,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(535,534,"gen_st_nombre_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",196,2),
			/* descripcion */
				(536,531,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(537,536,"gen_st_descripcion_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",197,2),
			/* rotulo */
				(538,531,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(539,538,"gen_st_rotulo_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",198,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(540,531,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(541,540,"gen_st_iconoImagenConcepto_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",199,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(542,531,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(543,542,"gen_st_iconoAudioConcepto_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",200,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(544,531,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(545,544,"gen_st_imagenConcepto_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",201,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_tipoDeSinTechoRecursoWeb  ***********  */
			(546,0,"gen_ai_es_gen_tipoDeSinTechoRecursoWeb",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",55,0),
			/* Ayuda a interfaz del concepto */
				(547,546,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(548,547,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(549,546,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(550,549,"gen_st_nombre_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",202,2),
			/* descripcion */
				(551,546,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(552,551,"gen_st_descripcion_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",203,2),
			/* rotulo */
				(553,546,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(554,553,"gen_st_rotulo_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",204,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(555,546,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(556,555,"gen_st_iconoImagenConcepto_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",205,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(557,546,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(558,557,"gen_st_iconoAudioConcepto_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",206,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(559,546,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(560,559,"gen_st_imagenConcepto_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",207,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_BuscadorKee  ***********  */
			(561,0,"gen_ai_es_gen_BuscadorKee",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",57,0),
			/* Ayuda a interfaz del concepto */
				(562,561,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(563,562,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(564,561,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(565,564,"gen_st_nombre_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",208,2),
			/* descripcion */
				(566,561,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(567,566,"gen_st_descripcion_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",209,2),
			/* rotulo */
				(568,561,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(569,568,"gen_st_rotulo_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",210,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(570,561,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(571,570,"gen_st_iconoImagenConcepto_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",211,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(572,561,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(573,572,"gen_st_iconoAudioConcepto_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",212,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(574,561,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(575,574,"gen_st_imagenConcepto_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",213,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_listaDeIdiomasDeInterfaz  ***********  */
			(576,0,"gen_ai_es_gen_listaDeIdiomasDeInterfaz",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",58,0),
			/* Ayuda a interfaz del concepto */
				(577,576,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(578,577,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(579,576,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(580,579,"gen_st_nombre_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",214,2),
			/* descripcion */
				(581,576,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(582,581,"gen_st_descripcion_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",215,2),
			/* rotulo */
				(583,576,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(584,583,"gen_st_rotulo_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",216,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(585,576,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(586,585,"gen_st_iconoImagenConcepto_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",217,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(587,576,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(588,587,"gen_st_iconoAudioConcepto_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",218,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(589,576,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(590,589,"gen_st_imagenConcepto_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",219,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_familiaDeDatosKlw  ***********  */
			(591,0,"gen_ai_es_gen_familiaDeDatosKlw",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",59,0),
			/* Ayuda a interfaz del concepto */
				(592,591,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(593,592,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(594,591,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(595,594,"gen_st_nombre_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",220,2),
			/* descripcion */
				(596,591,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(597,596,"gen_st_descripcion_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",221,2),
			/* rotulo */
				(598,591,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(599,598,"gen_st_rotulo_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",222,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(600,591,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(601,600,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",223,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(602,591,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(603,602,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",224,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(604,591,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(605,604,"gen_st_imagenConcepto_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",225,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_familiaDeDatosKlw_conceptos  ***********  */
			(606,0,"gen_ai_es_gen_familiaDeDatosKlw_conceptos",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",60,0),
			/* Ayuda a interfaz del concepto */
				(607,606,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(608,607,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(609,606,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(610,609,"gen_st_nombre_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",226,2),
			/* descripcion */
				(611,606,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(612,611,"gen_st_descripcion_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",227,2),
			/* rotulo */
				(613,606,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(614,613,"gen_st_rotulo_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",228,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(615,606,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(616,615,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",229,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(617,606,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(618,617,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",230,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(619,606,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(620,619,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",231,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_familiaDeDatosKlw_familias  ***********  */
			(621,0,"gen_ai_es_gen_familiaDeDatosKlw_familias",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",61,0),
			/* Ayuda a interfaz del concepto */
				(622,621,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(623,622,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(624,621,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(625,624,"gen_st_nombre_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",232,2),
			/* descripcion */
				(626,621,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(627,626,"gen_st_descripcion_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",233,2),
			/* rotulo */
				(628,621,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(629,628,"gen_st_rotulo_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",234,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(630,621,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(631,630,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",235,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(632,621,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(633,632,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",236,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(634,621,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(635,634,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",237,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_familiaDeDatosKlw_usuarios  ***********  */
			(636,0,"gen_ai_es_gen_familiaDeDatosKlw_usuarios",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",62,0),
			/* Ayuda a interfaz del concepto */
				(637,636,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(638,637,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(639,636,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(640,639,"gen_st_nombre_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",238,2),
			/* descripcion */
				(641,636,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(642,641,"gen_st_descripcion_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",239,2),
			/* rotulo */
				(643,636,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(644,643,"gen_st_rotulo_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",240,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(645,636,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(646,645,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",241,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(647,636,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(648,647,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",242,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(649,636,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(650,649,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",243,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_familiaDeDatosKlw_ai_es  ***********  */
			(651,0,"gen_ai_es_gen_familiaDeDatosKlw_ai_es",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",63,0),
			/* Ayuda a interfaz del concepto */
				(652,651,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(653,652,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(654,651,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(655,654,"gen_st_nombre_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",244,2),
			/* descripcion */
				(656,651,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(657,656,"gen_st_descripcion_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",245,2),
			/* rotulo */
				(658,651,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(659,658,"gen_st_rotulo_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",246,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(660,651,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(661,660,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",247,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(662,651,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(663,662,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",248,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(664,651,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(665,664,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",249,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_familiaDeDatosKlw_ai_ing  ***********  */
			(666,0,"gen_ai_es_gen_familiaDeDatosKlw_ai_ing",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",64,0),
			/* Ayuda a interfaz del concepto */
				(667,666,"gen_ayudaInterfaz",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"",0,0),
					(668,667,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(669,666,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",4,0),
					(670,669,"gen_st_nombre_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",250,2),
			/* descripcion */
				(671,666,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",5,0),
					(672,671,"gen_st_descripcion_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",251,2),
			/* rotulo */
				(673,666,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",6,0),
					(674,673,"gen_st_rotulo_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",252,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(675,666,"gen_iconoImagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",44,0),
					(676,675,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",253,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(677,666,"gen_iconoAudioConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",45,0),
					(678,677,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",254,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(679,666,"gen_imagenConcepto",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,0,"",46,0),
					(680,679,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",255,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_Conceptos  ***********  */
			(681,0,"gen_ai_es_gen_Familia_Conceptos",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",65,0),
			/* el concepto es una ayuda a interfaz */
				(682,681,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
					(683,682,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(684,681,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(685,684,"gen_st_nombre_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",256,2),
			/* descripcion */
				(686,681,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(687,686,"gen_st_descripcion_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",257,2),
			/* rotulo */
				(688,681,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(689,688,"gen_st_rotulo_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",258,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(690,681,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(691,690,"gen_st_iconoImagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",259,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(692,681,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(693,692,"gen_st_iconoAudioConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",260,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(694,681,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(695,694,"gen_st_imagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",261,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_Familias_fam  ***********  */
			(696,0,"gen_ai_es_gen_Familia_Familias_fam",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",66,0),
			/* el concepto es una ayuda a interfaz */
				(697,696,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
					(698,697,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(699,696,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(700,699,"gen_st_nombre_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",262,2),
			/* descripcion */
				(701,696,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(702,701,"gen_st_descripcion_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",263,2),
			/* rotulo */
				(703,696,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(704,703,"gen_st_rotulo_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",264,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(705,696,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(706,705,"gen_st_iconoImagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",265,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(707,696,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(708,707,"gen_st_iconoAudioConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",266,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(709,696,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(710,709,"gen_st_imagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",267,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_Usuarios_usr  ***********  */
			(711,0,"gen_ai_es_gen_Familia_Usuarios_usr",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",67,0),
			/* el concepto es una ayuda a interfaz */
				(712,711,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
					(713,712,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(714,711,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(716,714,"gen_st_nombre_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",268,2),
			/* descripcion */
				(717,711,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(718,717,"gen_st_descripcion_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",269,2),
			/* rotulo */
				(719,711,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(720,719,"gen_st_rotulo_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",270,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(721,711,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(722,721,"gen_st_iconoImagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",271,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(723,711,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(724,723,"gen_st_iconoAudioConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",272,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(725,711,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(726,725,"gen_st_imagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",273,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_Familia_AyudaIntEsp_ai_es  ***********  */
			(727,0,"gen_ai_es_gen_Familia_AyudaIntEsp_ai_es",@locDKSLocal,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",68,0),
			/* el concepto es una ayuda a interfaz */
				(728,727,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
					(729,728,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(730,727,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(731,730,"gen_st_nombre_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",274,2),
			/* descripcion */
				(732,727,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(733,732,"gen_st_descripcion_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",275,2),
			/* rotulo */
				(734,727,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(735,734,"gen_st_rotulo_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",276,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(736,727,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(737,736,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",277,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(738,727,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(739,738,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",278,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(740,727,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(741,740,"gen_st_imagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",279,2),

	/* Relaciones de ayuda interfaz del concepto gen_ai_es_gen_ParaConceptoNuevo  ***********  */
			(789,0,"gen_ai_es_gen_ParaConceptoNuevo",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",69,0),
			/* el concepto es una ayuda a interfaz */
				(790,789,"gen_ayudaInterfaz",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,1,"",0,0),
					(791,790,"gen_ayudaInterfazEsp",@localizacion_DKS_LANGUAJES,@ordinalDeAlta_LANGUAJES,@tiemoDeAlta_LANGUAJES,0,"",1,1),
			/* nombre */
				(792,789,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(793,792,"gen_st_nombre_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",286,2),
			/* descripcion */
				(794,789,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(795,794,"gen_st_descripcion_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",287,2),
			/* rotulo */
				(796,789,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
					(797,796,"gen_st_rotulo_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",288,2),
			/* Icono imangen  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(798,789,"gen_iconoImagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",44,0),
					(799,798,"gen_st_iconoImagenConcepto_gen_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",289,2),
			/* Icono audio  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(800,789,"gen_iconoAudioConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",45,0),
					(801,800,"gen_st_iconoAudioConcepto_gen_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",290,2),
			/* Imangen  Concepto  (solo ponemos el nombre del fichero con su extension, el directorio donde se almacena  lo añadira el PHP, para hacerlo mas versatil) */
				(802,789,"gen_imagenConcepto",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,0,"",46,0),
					(803,802,"gen_st_imagenConcepto_gen_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",291,2);

					
/*    Ultimo identificador utilizado para esta tabla de arriba   815 debes utilizar uno posterior para el siguiente registro OJOO  a partir del 1000 tambien estan ocupados **********  */	
/*      - Desde el 804 al 815 para completar la yuda a interfaz de key y host  MAFG 2021-12-29 */

/*  Conceptos  para DKS BASICO ***********  */
insert  into `ai_es_conceptos_conceptos`(`IdRel`,`IdRelPadre`,`ClaveHijo`,`LocalizacionHijo`,`OrdinalHijo`,`TiempoActualizacionHijo`,`Localidad`,`Familia`,`IdEnTabla`,`InsRef`) 
	values	
	/* Relaciones de ayuda interfaz del concepto gen_usuarioAdministradorLocal1  ***********  */
			(1000,0,"gen_ai_es_gen_usuarioAdministradorLocal1",@locDKSLocal_ai_es,@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,0),
		/* nombre */
			(1001,1000,"gen_nombre",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
			(1002,1001,"gen_st_nombreusuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1000,2),
		/* descripcion */
			(1003,1000,"gen_descripcion",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
			(1004,1003,"gen_st_descripcionusuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,1,"ai_es_",1001,2),
		/* rotulo */
			(1005,1000,"gen_rotulo",@localizacionGenericDKS,@ordinalDeAlta_GENERICO,@tiemoDeAlta_GENERICO,0,"",0,0),
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
			/* datos de   gen_ai_es_tipoDeSinTecho */
			(4,"gen_st_nombreTipoDeDato","ai_es_conceptos_sin_techo",0,0,"Tipo de dato","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(5,"gen_st_descripcionTipoDeDato","ai_es_conceptos_sin_techo",0,0,"Indica el tipo de dato (de un concepto sin techo) para que pueda ser procesado como corresponda","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(6,"gen_st_rotuloTipoDeDato","ai_es_conceptos_sin_techo",0,0,"Tipo de dato (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_tipoDeSinTechoTextoPlano */
			(7,"gen_st_nombreTipoTextoPLano","ai_es_conceptos_sin_techo",0,0,"Texto plano","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(8,"gen_st_descripcionTipoTextoPLano","ai_es_conceptos_sin_techo",0,0,"Texto plano en espanol","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(9,"gen_st_rotuloTipoTextoPLano","ai_es_conceptos_sin_techo",0,0,"Texto plano espanol (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(193,"gen_st_iconoImagenConcepto_gen_tipoDeSinTechoTextoPlano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgTipoTextoPlano.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(194,"gen_st_iconoAudioConcepto_gen_tipoDeSinTechoTextoPlano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioTipoTextoPlano.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(195,"gen_st_imagenConcepto_gen_tipoDeSinTechoTextoPlano","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_TipoTextoPlano.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de   gen_ai_es_gen_tipoDeSinTecho_NumeroEntero */
			(280,"gen_st_nombre_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",0,0,"Numero entero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(281,"gen_st_descripcion_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",0,0,"Numero entero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(282,"gen_st_rotulo_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",0,0,"Numero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(283,"gen_st_iconoImagenConcepto_gen_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgTipoNumeroEntero.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(284,"gen_st_iconoAudioConcepto_gen_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioTipoNumeroEntero.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(285,"gen_st_imagenConcepto_gen_tipoDeSinTecho_NumeroEntero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_TipoNumeroEntero.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de   gen_ai_es_gen_consultaaDKS */
			(22,"gen_st_nombreConsultaaDKS","ai_es_conceptos_sin_techo",0,0,"Consulta a DKS (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(23,"gen_st_descripcionConsultaaDKS","ai_es_conceptos_sin_techo",0,0,"Lo son, cualquier consulta a los DKS. Se especifica en los distintos tipos de consulta","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(24,"gen_st_rotuloConsultaaDKS","ai_es_conceptos_sin_techo",0,0,"Consulta a DKS (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_tipoDeSinTechoClaveEncriptada */
			(25,"gen_st_nombreTipoClaveEncriptada","ai_es_conceptos_sin_techo",0,0,"Clave encriptada como tipo de sin techo (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(26,"gen_st_descripcionTipoClaveEncriptada","ai_es_conceptos_sin_techo",0,0,"Es un tipo de concepto de dato Sin Techo que sirve para almacenar las claves encriptadas, por ejemplo claves de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(27,"gen_st_rotuloTipoClaveEncriptada","ai_es_conceptos_sin_techo",0,0,"Clave encriptada como tipo de sin techo (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_ayudaInterfaz */
			(28,"gen_st_nombreAyudaInterfaz","ai_es_conceptos_sin_techo",0,0,"Ayuda a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(29,"gen_st_descripcionAyudaInterfaz","ai_es_conceptos_sin_techo",0,0,"Este es el concepto que almacena la ayuda a interfaz. Los hijos deben ser las ayudas a interfaz en los distintos idiomas","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(30,"gen_st_rotuloAyudaInterfaz","ai_es_conceptos_sin_techo",0,0,"Ayuda a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(136,"gen_st_iconoImagenConcepto_gen_ayudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgAyudaInterfaz.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(137,"gen_st_iconoAudioConcepto_gen_ayudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioAyudaInterfaz.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(138,"gen_st_imagenConcepto_gen_ayudaInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_ayudaInterfaz.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_KLW */
			(40,"gen_st_nombreKLW","ai_es_conceptos_sin_techo",0,0,"KWL. Knowledjw Living in Web","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(41,"gen_st_descripcionKLW","ai_es_conceptos_sin_techo",0,0,"Es el sistema de informacion KLW en si","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(42,"gen_st_rotuloKLW","ai_es_conceptos_sin_techo",0,0,"KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_concepto*/
			(43,"gen_st_nombreconcepto","ai_es_conceptos_sin_techo",0,0,"Concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(44,"gen_st_descripcionconcepto","ai_es_conceptos_sin_techo",0,0,"Representa un concepto en el sistema de informacion KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(45,"gen_st_rotuloconcepto","ai_es_conceptos_sin_techo",0,0,"Concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_KDL*/
			(46,"gen_st_nombreKDL","ai_es_conceptos_sin_techo",0,0,"KDL. Knowledgw Description Languaje","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(47,"gen_st_descripcionKDL","ai_es_conceptos_sin_techo",0,0,"Es el formato de representacion de conceptos (es un esquema XML)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(48,"gen_st_rotuloKDL","ai_es_conceptos_sin_techo",0,0,"KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_I*/
			(49,"gen_st_nombreI","ai_es_conceptos_sin_techo",0,0,"Identificador KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(50,"gen_st_descripcionI","ai_es_conceptos_sin_techo",0,0,"I = Identificador es decir el identificador (key+host)  de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(51,"gen_st_rotuloI","ai_es_conceptos_sin_techo",0,0,"Identificador KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_K*/
			(52,"gen_st_nombreK","ai_es_conceptos_sin_techo",0,0,"Clave o Key de KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(53,"gen_st_descripcionK","ai_es_conceptos_sin_techo",0,0,"K = Clave o Key  de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(54,"gen_st_rotuloK","ai_es_conceptos_sin_techo",0,0,"Clave KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(292,"gen_st_iconoImagenConcepto_gen_K","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgIdentificador.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(293,"gen_st_iconoAudioConcepto_gen_K","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudio_gen_K.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(294,"gen_st_imagenConcepto_gen_K","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Identificador.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de  gen_ai_es_gen_H*/
			(55,"gen_st_nombreH","ai_es_conceptos_sin_techo",0,0,"Localizacion ( host) KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(56,"gen_st_descripcionH","ai_es_conceptos_sin_techo",0,0,"H = Localizacion ( host) de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(57,"gen_st_rotuloH","ai_es_conceptos_sin_techo",0,0,"Localizacion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(295,"gen_st_iconoImagenConcepto_gen_H","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgTipoNumeroEntero.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(296,"gen_st_iconoAudioConcepto_gen_H","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudio_gen_H.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(297,"gen_st_imagenConcepto_gen_H","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_LocLogica.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_F*/
			(58,"gen_st_nombreF","ai_es_conceptos_sin_techo",0,0,"Control de configuracion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(59,"gen_st_descripcionF","ai_es_conceptos_sin_techo",0,0,"F = Control de configuracion es decir el elemento para control de configuracion de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(60,"gen_st_rotuloF","ai_es_conceptos_sin_techo",0,0,"Control de configuracion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_O*/
			(61,"gen_st_nombreO","ai_es_conceptos_sin_techo",0,0,"Ordinal KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(62,"gen_st_descripcionO","ai_es_conceptos_sin_techo",0,0,"O = Ordinal de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(63,"gen_st_rotuloO","ai_es_conceptos_sin_techo",0,0,"Ordinal KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_M*/
			(64,"gen_st_nombreM","ai_es_conceptos_sin_techo",0,0,"Fecha de ultima modificacion o tiempo de actualizacion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(65,"gen_st_descripcionM","ai_es_conceptos_sin_techo",0,0,"M = Fecha de ultima modificacion o tiempo de actualizacion de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(66,"gen_st_rotuloM","ai_es_conceptos_sin_techo",0,0,"Fecha de ultima modificacion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_D*/
			(67,"gen_st_nombreD","ai_es_conceptos_sin_techo",0,0,"Descripcion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(68,"gen_st_descripcionD","ai_es_conceptos_sin_techo",0,0,"D = Descripcion KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(69,"gen_st_rotuloD","ai_es_conceptos_sin_techo",0,0,"Descripcion KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_E*/
			(70,"gen_st_nombreE","ai_es_conceptos_sin_techo",0,0,"Enlace KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(71,"gen_st_descripcionE","ai_es_conceptos_sin_techo",0,0,"E = Enlace de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(72,"gen_st_rotuloE","ai_es_conceptos_sin_techo",0,0,"Enlace KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_A*/
			(73,"gen_st_nombreA","ai_es_conceptos_sin_techo",0,0,"Instancia KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(74,"gen_st_descripcionA","ai_es_conceptos_sin_techo",0,0,"A = Instancia (alude al concepto) de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(75,"gen_st_rotuloA","ai_es_conceptos_sin_techo",0,0,"Instancia KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_R*/
			(76,"gen_st_nombreR","ai_es_conceptos_sin_techo",0,0,"Referencia KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(77,"gen_st_descripcionR","ai_es_conceptos_sin_techo",0,0,"R = Referencia a un concepto de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(78,"gen_st_rotuloR","ai_es_conceptos_sin_techo",0,0,"Referencia KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_Z*/
			(79,"gen_st_nombreZ","ai_es_conceptos_sin_techo",0,0,"Sin techo KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(80,"gen_st_descripcionZ","ai_es_conceptos_sin_techo",0,0,"Z = Sin techo o dato sin referencia con conocimiento tan solo en el dominio del observador( non plus ultra) de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(81,"gen_st_rotuloZ","ai_es_conceptos_sin_techo",0,0,"Sin techo KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_T*/
			(82,"gen_st_nombreT","ai_es_conceptos_sin_techo",0,0,"Dato KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(83,"gen_st_descripcionT","ai_es_conceptos_sin_techo",0,0,"T = Dato, texto cuya informacion reside en el dominio del observador de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(84,"gen_st_rotuloT","ai_es_conceptos_sin_techo",0,0,"Dato KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_P*/
			(85,"gen_st_nombreP","ai_es_conceptos_sin_techo",0,0,"Ayuda a interfaz KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(86,"gen_st_descripcionP","ai_es_conceptos_sin_techo",0,0,"P = Descripcion del concepto de ayuda a interfaz asociado a una referencia o instancia de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(87,"gen_st_rotuloP","ai_es_conceptos_sin_techo",0,0,"Ayuda a interfaz KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_L*/
			(88,"gen_st_nombreL","ai_es_conceptos_sin_techo",0,0,"Idioma (lengua) KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(89,"gen_st_descripcionL","ai_es_conceptos_sin_techo",0,0,"L = Lenguaje ( su contenido es una referencia a un concepto que debe ser una lengua conocida) de KDL en KLW tal como lo hemos definido","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(90,"gen_st_rotuloL","ai_es_conceptos_sin_techo",0,0,"Idioma KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_solicitudADks */
			(103,"gen_st_nombresolicitudADks","ai_es_conceptos_sin_techo",0,0,"Solicitud","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(104,"gen_st_descripcionsolicitudADks","ai_es_conceptos_sin_techo",0,0,"Solicitud o peticion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(105,"gen_st_rotulosolicitudADks","ai_es_conceptos_sin_techo",0,0,"Solicitud","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_getDetails */
			(106,"gen_st_nombregetDetails","ai_es_conceptos_sin_techo",0,0,"Solicitud de descripcion","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(107,"gen_st_descripciongetDetails","ai_es_conceptos_sin_techo",0,0,"Solicita la descripcion de un concpto (definido como servicio web en los DKSs)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(108,"gen_st_rotulogetDetails","ai_es_conceptos_sin_techo",0,0,"Solicitud","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_getAyudaInterfaz */
			(121,"gen_st_nombre_gen_ai_es_gen_getAyudaInterfaz","ai_es_conceptos_sin_techo",0,0,"Solicitud de ayuda a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(122,"gen_st_descripcion_gen_ai_es_gen_getAyudaInterfaz","ai_es_conceptos_sin_techo",0,0,"Solicita la ayuda a interfaz de un concpto (definido como servicio web en los DKSs)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(123,"gen_st_rotulo_gen_ai_es_gen_getAyudaInterfaz","ai_es_conceptos_sin_techo",0,0,"Solicitud","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_respuestaAsolicitudADks */
			(109,"gen_st_nombregetrespuestaAsolicitudADks","ai_es_conceptos_sin_techo",0,0,"Respuesta","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(110,"gen_st_descripcionrespuestaAsolicitudADks","ai_es_conceptos_sin_techo",0,0,"Es la respuesta a una solicitud","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(111,"gen_st_rotulorespuestaAsolicitudADks","ai_es_conceptos_sin_techo",0,0,"Respuesta","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_errorDeAccesoABbdd */
			(115,"gen_st_nombreerrorDeAccesoABbdd","ai_es_conceptos_sin_techo",0,0,"Error de acceso a BBDD","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(116,"gen_st_descripcionerrorDeAccesoABbdd","ai_es_conceptos_sin_techo",0,0,"Identifica los errores de acceso a base de datos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(117,"gen_st_rotuloerrorDeAccesoABbdd","ai_es_conceptos_sin_techo",0,0,"Error de acceso a BBDD","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_errorKLW */
			(118,"gen_st_nombreerrorKLW","ai_es_conceptos_sin_techo",0,0,"Error en proceso de KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(119,"gen_st_descripcionerrorKLW","ai_es_conceptos_sin_techo",0,0,"Identifica los errores al procesar cadena KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(120,"gen_st_rotuloerrorKLW","ai_es_conceptos_sin_techo",0,0,"Error en proceso de KDL","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			(184,"gen_st_iconoImagenConcepto_gen_errorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgErrorKlw.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(185,"gen_st_iconoAudioConcepto_gen_errorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioErrorKlw.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(186,"gen_st_imagenConcepto_gen_errorKLW","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_error_KLW.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
			/* datos de  gen_ai_es_gen_configuracionDeAcceso */
			(124,"gen_st_nombre_gen_configuracionDeAcceso","ai_es_conceptos_sin_techo",0,0,"Configuracion de acceso","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(125,"gen_st_descripcion_gen_configuracionDeAcceso","ai_es_conceptos_sin_techo",0,0,"Contiene la informacion asociada a un acceso al sistema: idiomas, usuario, etc...","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(126,"gen_st_rotulo_gen_configuracionDeAcceso","ai_es_conceptos_sin_techo",0,0,"Configuracion de acceso","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_iconoImagenConcepto */
			(127,"gen_st_nombre_gen_iconoImagenConcepto","ai_es_conceptos_sin_techo",0,0,"Icono de concepto (imagen)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(128,"gen_st_descripcion_gen_iconoImagenConcepto","ai_es_conceptos_sin_techo",0,0,"Contiene la imagen que se usa de icono para un concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(129,"gen_st_rotulo_gen_iconoImagenConcepto","ai_es_conceptos_sin_techo",0,0,"Icono imagen","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_iconoAudioConcepto */
			(130,"gen_st_nombre_gen_iconoAudioConcepto","ai_es_conceptos_sin_techo",0,0,"Icono de concepto (audio)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(131,"gen_st_descripcion_gen_iconoAudioConcepto","ai_es_conceptos_sin_techo",0,0,"Contiene el audio que se usa de icono para un concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(132,"gen_st_rotulo_gen_iconoAudioConcepto","ai_es_conceptos_sin_techo",0,0,"Icono audio","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_imagenConcepto */
			(133,"gen_st_nombre_gen_imagenConcepto","ai_es_conceptos_sin_techo",0,0,"Imagen de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(134,"gen_st_descripcion_gen_imagenConcepto","ai_es_conceptos_sin_techo",0,0,"Contiene la imagen que se usa de fondo para un concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(135,"gen_st_rotulo_gen_imagenConcepto","ai_es_conceptos_sin_techo",0,0,"Imagen de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_interfazKee */
			(139,"gen_st_nombre_gen_interfazKee","ai_es_conceptos_sin_techo",0,0,"Interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(140,"gen_st_descripcion_gen_interfazKee","ai_es_conceptos_sin_techo",0,0,"Este es el concepto que almacena la informacion de la interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(141,"gen_st_rotulo_gen_interfazKee","ai_es_conceptos_sin_techo",0,0,"Interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(142,"gen_st_iconoImagenConcepto_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgInterfazKee.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(143,"gen_st_iconoAudioConcepto_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioInterfazKee.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(144,"gen_st_imagenConcepto_gen_interfazKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_interfazKee.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_listaEntornos */
			(145,"gen_st_nombre_gen_listaEntornos","ai_es_conceptos_sin_techo",0,0,"Lista de entornos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(146,"gen_st_descripcion_gen_listaEntornos","ai_es_conceptos_sin_techo",0,0,"Contiene la lista de entornos dentro de la interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(147,"gen_st_rotulo_gen_listaEntornos","ai_es_conceptos_sin_techo",0,0,"Entornos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(148,"gen_st_iconoImagenConcepto_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgListaEntornos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(149,"gen_st_iconoAudioConcepto_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioListaEntornos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(150,"gen_st_imagenConcepto_gen_listaEntornos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_ListaEntornos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_entornoDeTrabajoKee */
			(151,"gen_st_nombre_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",0,0,"Entorno de trabajo KEE","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(152,"gen_st_descripcion_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",0,0,"Contiene la informacion del entorno de trabajo dentro de la interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(153,"gen_st_rotulo_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",0,0,"Entorno de trabajo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(154,"gen_st_iconoImagenConcepto_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgEntornoTrabaoKee.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(155,"gen_st_iconoAudioConcepto_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioEntornoTrabajoKee.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(156,"gen_st_imagenConcepto_gen_entornoDeTrabajoKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_entornoTrabajoKee.gif","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_listaRequerimientosKEE */
			(157,"gen_st_nombre_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",0,0,"Lista de requerimientos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(158,"gen_st_descripcion_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",0,0,"Contiene la lista de requerimientos al KEE que se han realizado desde el cliente en un entorno de trabajo dentro de la interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(159,"gen_st_rotulo_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",0,0,"Requerimientos realizados","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(160,"gen_st_iconoImagenConcepto_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgListaRequerimientosKee.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(161,"gen_st_iconoAudioConcepto_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioListaRequerimientosKee.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(162,"gen_st_imagenConcepto_gen_listaRequerimientosKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_listaRequerimientosKee.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_requerimientoKEE */
			(163,"gen_st_nombre_gen_requerimientoKEE","ai_es_conceptos_sin_techo",0,0,"Requerimiento KEE","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(164,"gen_st_descripcion_gen_requerimientoKEE","ai_es_conceptos_sin_techo",0,0,"Contiene un requerimiento al KEE que se ha realizado desde el cliente en un entorno de trabajo dentro de la interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(165,"gen_st_rotulo_gen_requerimientoKEE","ai_es_conceptos_sin_techo",0,0,"Requerimiento","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(166,"gen_st_iconoImagenConcepto_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgRequerimientoKee.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(167,"gen_st_iconoAudioConcepto_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioRequerimientoKee.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(168,"gen_st_imagenConcepto_gen_requerimientoKEE","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_requerimientoKee.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_ListaConceptosPresentes */
			(169,"gen_st_nombre_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",0,0,"Lista de conceptos Presentes en Kee","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(170,"gen_st_descripcion_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",0,0,"Contiene la lista de conceptos que se almacenan en un entorno de trabajo dentro de la interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(171,"gen_st_rotulo_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",0,0,"Conceptos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(172,"gen_st_iconoImagenConcepto_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgListaConceptosPresentesKee.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(173,"gen_st_iconoAudioConcepto_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioListaConceptosPresentesKee.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(174,"gen_st_imagenConcepto_gen_ListaConceptosPresentes","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_ListaConceptosPresentesKee.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_getConceptoInterfazUsuario */
			(175,"gen_st_nombre_gen_getConceptoInterfazUsuario","ai_es_conceptos_sin_techo",0,0,"Obten concepto de interfaz de usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(176,"gen_st_descripcion_gen_getConceptoInterfazUsuario","ai_es_conceptos_sin_techo",0,0,"Es el metodo del DKS que obtiene el concepto de configuracion de interfaz de un usuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(177,"gen_st_rotulo_gen_getConceptoInterfazUsuario","ai_es_conceptos_sin_techo",0,0,"Metodo getConceptoInterfazUsuario","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_ConceptoEfimero */
			(178,"gen_st_nombre_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",0,0,"Concepto efimero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(179,"gen_st_descripcion_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",0,0,"Es un concepto que, en principio, no se almacena en ningun DKS, se usa para enviar un mensaje u otros","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(180,"gen_st_rotulo_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",0,0,"Efimero","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(181,"gen_st_iconoImagenConcepto_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgConceptoEfimero.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(182,"gen_st_iconoAudioConcepto_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioConceptoEfimero.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(183,"gen_st_imagenConcepto_gen_ConceptoEfimero","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_ConceptoEfimero.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_errorEnAyudaInterfazKlw */
			(187,"gen_st_nombre_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",0,0,"Error en ayuda a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(188,"gen_st_descripcion_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",0,0,"Indica que no ha podido localizarse la ayuda a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(189,"gen_st_rotulo_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",0,0,"Error en ayuda a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(190,"gen_st_iconoImagenConcepto_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgErrorAyudaInterfaz.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(191,"gen_st_iconoAudioConcepto_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioErrorEnAyudaInterfaz.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(192,"gen_st_imagenConcepto_gen_errorEnAyudaInterfazKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_errorAyudaInterfaz.bmp","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_PrivacidadDeDatos */
			(196,"gen_st_nombre_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",0,0,"Privacidad de datos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(197,"gen_st_descripcion_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",0,0,"Contiene informacion referente a que usuarios tienen acceso a que datos en un DKS concreto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(198,"gen_st_rotulo_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",0,0,"Privacidad de datos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(199,"gen_st_iconoImagenConcepto_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgPrivacidadDeDatos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(200,"gen_st_iconoAudioConcepto_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioPrivacidadDeDatos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(201,"gen_st_imagenConcepto_gen_PrivacidadDeDatos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_PrivacidadDeDatos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_tipoDeSinTechoRecursoWeb */
			(202,"gen_st_nombre_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",0,0,"Recurso web","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(203,"gen_st_descripcion_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",0,0,"Representa un recurso web, como tipo de dato sin techo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(204,"gen_st_rotulo_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",0,0,"Recurso web","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(205,"gen_st_iconoImagenConcepto_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgTipoRecursoWeb.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(206,"gen_st_iconoAudioConcepto_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioTipoRecursoWeb.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(207,"gen_st_imagenConcepto_gen_tipoDeSinTechoRecursoWeb","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_TipoRecursosWeb.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_BuscadorKee */
			(208,"gen_st_nombre_gen_BuscadorKee","ai_es_conceptos_sin_techo",0,0,"Buscador Kee","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(209,"gen_st_descripcion_gen_BuscadorKee","ai_es_conceptos_sin_techo",0,0,"Representa un buscador de la interfaz Kee","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(210,"gen_st_rotulo_gen_BuscadorKee","ai_es_conceptos_sin_techo",0,0,"Buscador Kee","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(211,"gen_st_iconoImagenConcepto_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgBusqueda.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(212,"gen_st_iconoAudioConcepto_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioBuscador.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(213,"gen_st_imagenConcepto_gen_BuscadorKee","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Buscador.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_listaDeIdiomasDeInterfaz */
			(214,"gen_st_nombre_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",0,0,"Lista de idiomas de acceso a interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(215,"gen_st_descripcion_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",0,0,"Contiene la lista de idiomas, ordenados segun preferencia, que el usuario ha seleccionado para el acceso a la interfaz","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(216,"gen_st_rotulo_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",0,0,"Lista de idiomas","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(217,"gen_st_iconoImagenConcepto_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImglistaDeIdiomasDeInterfaz.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(218,"gen_st_iconoAudioConcepto_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudiolistaDeIdiomasDeInterfaz.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(219,"gen_st_imagenConcepto_gen_listaDeIdiomasDeInterfaz","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_listaDeIdiomasDeInterfaz.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_familiaDeDatosKlw */
			(220,"gen_st_nombre_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",0,0,"Familia de datos BBDD KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(221,"gen_st_descripcion_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",0,0,"Es una familia de datos (conjunto de tablas) en la base de datos de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(222,"gen_st_rotulo_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",0,0,"Familia en BBDD","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(223,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgFamiliaDeDatosKlw.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(224,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamiliaDeDatosKlw.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(225,"gen_st_imagenConcepto_gen_familiaDeDatosKlw","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_familiaDeDatosKlw.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_familiaDeDatosKlw_conceptos */
			(226,"gen_st_nombre_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",0,0,"Tablas de instancia de datos generales en BBDD de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(227,"gen_st_descripcion_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",0,0,"Es la familia de datos DD de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(228,"gen_st_rotulo_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",0,0,"Datos genericos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(229,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgFamiliaDeDatosKlw_conceptos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(230,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamiliaDeDatosKlw_conceptos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(231,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_familiaDeDatosKlw_conceptos.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_familiaDeDatosKlw_familias */
			(232,"gen_st_nombre_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",0,0,"Tablas de instancia de datos generales en BBDD de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(233,"gen_st_descripcion_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",0,0,"Refiere el conjunto de tablas que contiene la informacion referente a las familias de datos del DKS en KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(234,"gen_st_rotulo_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",0,0,"Tabla de familia de datos","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(235,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgFamiliaDeDatosKlw_familias.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(236,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamiliaDeDatosKlw_familias.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(237,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_familias","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_familiaDeDatosKlw_familias.JPG","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_familiaDeDatosKlw_usuarios */
			(238,"gen_st_nombre_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",0,0,"Tablas de instancia de datos usuarios en BBDD de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(239,"gen_st_descripcion_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",0,0,"Refiere el conjunto de tablas que contiene la informacion referente a los datos de usuario del DKS en KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(240,"gen_st_rotulo_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",0,0,"Tabla de familia de usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(241,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgFamiliaDeDatosKlw_usuarios.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(242,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamiliaDeDatosKlw_usuarios.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(243,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_usuarios","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_familiaDeDatosKlw_usuarios.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_familiaDeDatosKlw_ai_es */
			(244,"gen_st_nombre_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",0,0,"Tablas de instancia de ayuda a interfaz en español en BBDD de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(245,"gen_st_descripcion_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",0,0,"Refiere el conjunto de tablas que contiene la informacion referente ayuda a interfaz en español del DKS en KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(246,"gen_st_rotulo_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",0,0,"Tabla de familia de ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(247,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgFamiliaDeDatosKlw_ai_es.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(248,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamiliaDeDatosKlw_ai_es.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(249,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_familiaDeDatosKlw_ai_es.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

			/* datos de  gen_ai_es_gen_familiaDeDatosKlw_ai_ing */
			(250,"gen_st_nombre_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",0,0,"Tablas de instancia de ayuda a interfaz en ingles en BBDD de KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(251,"gen_st_descripcion_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",0,0,"Refiere el conjunto de tablas que contiene la informacion referente ayuda a interfaz en ingles del DKS en KLW","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(252,"gen_st_rotulo_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",0,0,"Tabla de familia de ayuda a interfaz en ingles","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(253,"gen_st_iconoImagenConcepto_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoImgFamiliaDeDatosKlw_ai_ing.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(254,"gen_st_iconoAudioConcepto_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamiliaDeDatosKlw_ai_ing.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(255,"gen_st_imagenConcepto_gen_familiaDeDatosKlw_ai_ing","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_familiaDeDatosKlw_ai_ing.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			
	/* datos sin techo de la ayuda interfaz de las tablas de familia */
		/* datos de   gen_ai_es_gen_Familia_Conceptos */
			(256,"gen_st_nombre_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(257,"gen_st_descripcion_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(258,"gen_st_rotulo_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(259,"gen_st_iconoImagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Conceptos.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(260,"gen_st_iconoAudioConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Conceptos.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(261,"gen_st_imagenConcepto_gen_Familia_Conceptos","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Conceptos.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_Familias_fam */
			(262,"gen_st_nombre_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Familias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(263,"gen_st_descripcion_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Familias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(264,"gen_st_rotulo_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Familias","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(265,"gen_st_iconoImagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Familias_fam.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(266,"gen_st_iconoAudioConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Familias_fam.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(267,"gen_st_imagenConcepto_gen_Familia_Familias_fam","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Familias_fam.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_Usuarios_usr */
			(268,"gen_st_nombre_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(269,"gen_st_descripcion_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(270,"gen_st_rotulo_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Usuarios","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(271,"gen_st_iconoImagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_Usuarios_usr.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(272,"gen_st_iconoAudioConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_Usuarios_usr.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(273,"gen_st_imagenConcepto_gen_Familia_Usuarios_usr","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_Usuarios_usr.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
	
		/* datos de   gen_ai_es_gen_Familia_AyudaIntEsp_ai_es */
			(274,"gen_st_nombre_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de familia de Ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(275,"gen_st_descripcion_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Representa las tablas de familia de Ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(276,"gen_st_rotulo_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Tablas de Ayuda a interfaz en español","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(277,"gen_st_iconoImagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgFamilia_AyudaIntEsp_ai_es.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(278,"gen_st_iconoAudioConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioFamilia_AyudaIntEsp_ai_es.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(279,"gen_st_imagenConcepto_gen_Familia_AyudaIntEsp_ai_es","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_Familia_AyudaIntEsp_ai_es.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),

		/* datos de   gen_ai_es_gen_ParaConceptoNuevo */
			(286,"gen_st_nombre_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Nuevo Concepto","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(287,"gen_st_descripcion_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Este concepto se utiliza para generar conceptos nuevos, no es en si un concepto, si no una base para generar conceptos a partir de este","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(288,"gen_st_rotulo_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Concepto Nuevo","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(289,"gen_st_iconoImagenConcepto_gen_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"iconoImgConceptoNuevo.png","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(290,"gen_st_iconoAudioConcepto_gen_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"IconoAudioNuevoConcepto.wav","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(291,"gen_st_imagenConcepto_gen_ParaConceptoNuevo","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"imagen_cajaVacia.jpg","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);
			
/*    Ultimo identificador utilizado para esta tabla de arriba   297 debes utilizar uno posterior para el siguiente registro OJOO  a partir del 1000 tambien estan ocupados **********  */			
/* 		- del 292 al 297 para completar datos de ayuda a interfaz de los concepto s key y host MAFG 2021-12-29 */
			
/*  Conceptos para DKS BASICO ***********  */
insert  into `ai_es_conceptos_sin_techo`(`Idcst`,`Clave`,`Localizacion`,`Ordinal`,`TiempoActualizacion`,`Contenido`,`ClaveTipo`,`LocalizacionTipo`,`OrdinalTipo`,`TiempoActualizacionTipo`,`ClaveUsuario`,`LocalizacionUsuario`,`Acceso`) 
	values	/* datos de   gen_ai_es_gen_usuarioAdministradorLocal1*/
			(1000,"gen_st_nombreUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (nombre)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1001,"gen_st_descripcionUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Es el usuario que genera por defecto al generar la BBDD de una aplicacion DKS","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto),
			(1002,"gen_st_rotuloUsuarioAdministradorLocal1","ai_es_conceptos_sin_techo",@ordinalDeAlta,@tiemoDeAlta,"Usr Administrador local1 (rotulo)","gen_tipoDeSinTechoTextoPlano",@localizacion_DKS_KLW,@ordinalDeAlta_KLW,@tiemoDeAlta_KLW,@claveUsuario,@localizacionUsuario,@accesoPorDefecto);


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
