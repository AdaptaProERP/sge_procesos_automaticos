// Proceso PROCFALLIDOS        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
 LOCAL nCantid:=COUNT("DPPROCESOS","PRC_ACTIVO=0 AND PRC_INICIA=1 AND PRC_FIN=0")
 LOCAL nCanPro:=COUNT("DPPROCESOS","PRC_ACTIVO=1")

 IF !oDp:lPanel
 
     EJECUTAR("BRPRCFALLIDO")
     RETURN 
 ENDIF

 oErp:dFecha :=oDp:dFecha // Fecha
 oErp:nMonto :=0          // Monto a Publicar
 oErp:nColor :=IF(nCantid>0,2,0)    // Color a Mostrar
 oErp:cDescri:="Procesos Automáticos Fallidos "+LTRAN(nCantid)+"/"+LTRAN(nCanPro)
 oErp:lPanel :=.T.        // Publicar en el Panel



RETURN .T.
// EOF
