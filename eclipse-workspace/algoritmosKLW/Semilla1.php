<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Semilla 1
 */


function semilla1($conBBDD){
    
    mysqli_query($conBBDD,"delete from conceptos_conceptos");
    
    mysqli_query($conBBDD, 'insert into conceptos_conceptos values
            (356,0,"gen_prueba_001","@locDKSLocal",1,"",18,0),
				(357,356,"gen_ayudaInterfaz","@localizacion_DKS_KLW",0,"",2,0),
					(358,357,"gen_ai_es_gen_prueba_001","@locDKSLocal_ai_es",1,"ai_es_",20,1),
        
				(359,356,"gen_miki","@locDKSLocal",1,"",17,1),
				(360,356,"gen_miCasa","@locDKSLocal",1,"",6,1),
        
				(361,356,"gen_curriculum","@localizacionGenericDKS",0,"",55,0),
					(362,361,"gen_mikiCurriculum","@locDKSLocal",1,"",12,1),
					(363,361,"gen_miCasa","@locDKSLocal",1,"",6,1),
        
					(364,361,"gen_amigos","@locDKSLocal",1,"",8,0),
						(365,364,"gen_miki","@locDKSLocal",1,"",17,1),
						(366,364,"gen_miki","@locDKSLocal",1,"",17,1),
						(367,364,"gen_miki","@locDKSLocal",1,"",17,1),
        
						(368,364,"gen_casa","@locDKSLocal",1,"",3,0),
							(369,368,"gen_miCasa","@locDKSLocal",1,"",6,1),
        
					(370,361,"gen_st_ejemplo01_01","@locDKSLocal",1,"",1,2),
        
					(371,361,"gen_st_ejemplo01_02","@locDKSLocal",1,"",2,2),
        
        
				(372,356,"gen_st_ejemplo01_03","@locDKSLocal",1,"",3,2),
        
				(373,356,"gen_st_ejemplo01_04","@locDKSLocal",1,"",4,2),
        
					/*si cambiamos el orden sigue funcionando, se hace de forma ordenada y busca primero el 2*/
					(2,361,"gen_miCoche","@locDKSLocal",1,"",6,2);');
    
}


