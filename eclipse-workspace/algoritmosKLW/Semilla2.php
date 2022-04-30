<?php

/*
 * @author : Roberto Cruzado Martínez
 * @año: 2022
 * Semilla 2
 */


function semilla2($conBBDD){
    
    //Necesitamos caracteres para crear la columna ClaveHijo
    $caracteres = 'abcdefghijklmnopqrstuvwxyz_';
    $PadreActual = 1;
    
    //borramos los datos que pueda haber en la BBDD de otras semillas
    mysqli_query($conBBDD,"delete from conceptos_conceptos");
    
    //Creamos la semilla 2
    
    //Se asignan los datos a la BBDD. Se pueden hacer varios similares de distinto tamaño y cada uno sería un concepto
    for ($IdRel = 1; $IdRel <= 100; $IdRel++) {
        if ($IdRel == 1){
            //mo ramifica
            $IdRelPadre = 0;
        }else{
            //ramifica
            $IdRel2 = $IdRel-1;
            $posiblesPadres = array($PadreActual, $IdRel2);
            $IdRelPadre = $posiblesPadres[array_rand($posiblesPadres)];
            if($IdRelPadre == $IdRel2){
                $PadreActual = $IdRel2;
            }
            elseif($IdRelPadre == $vist){
                $PadreActual = $vist;
            }
            //si no no añade a la lista de visitados para no volver a ese nodo que es cerrado
            
        }
        $ClaveHijo = substr(str_shuffle($caracteres), 0, 10);
        $InsRef = rand(0,2);
        print $IdRel."*".$IdRelPadre."*".$ClaveHijo."*".$InsRef." ";
    }
    
}


/*
 1*0*ctzl_sjrwx*1
 2*1*sohpfzjtmq*2
 3*2*giluytxcwk*0
 4*3*o_tcdxywbu*0
 5*4*jlzxfbwoir*1
 6*5*mkjqx_ldwp*1
 7*6*su_jxeclva*0
 8*6*uanmdcvztl*2
 9*8*szrhkpd_vo*0
 10*8*ipbqcjgknl*1
 11*8*zdowy_ftpe*1
 12*11*jsmcwixatu*0
 13*12*ipzmfvdugq*1
 14*12*yfpsvml_bx*1
 15*14*oinpdtsxe_*1
 16*14*xbzstowj_n*1
 17*16*ruf_jbtzvn*1
 18*17*_rhadiwceg*2
 19*17*txgpwmnrqc*1
 20*17*vla_rjtkbw*2
 21*17*qhorvxejms*1
 22*21*clnrgzpmyh*0
 23*21*jksomdcezt*1
 24*21*zgjyhqrwps*1 25*24*hejsczdkug*0 26*25*ifydgmueop*1 27*26*dplyezoxbm*0 28*27*byofmsxkal*2 29*27*q_bphmiwzg*1 30*29*yvsc_ngiab*0
 */
