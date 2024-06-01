// Proceso IPC                 
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
       LOCAL dFecha:=EVAL(oDp:dFchInt)
       LOCAL nMeses:=MESES(dFecha,DPFECHA())

       IF (Empty(dFecha) .OR. nMeses>1) .AND. EJECUTAR("ISRUNWEB","www.bcv.org.ve")
         EJECUTAR("BCVTASASINT")
         dFecha:=EVAL(oDp:bFchInpc)
         nMeses:=MESES(dFecha,DPFECHA())
       ENDIF

       IF !oDp:lPanel 
         DPLBX("NMTASASINT")
         RETURN .F.
       ENDIF

       oErp:dFecha :=oDp:dFecha // Fecha
       oErp:nMonto :=0          // Monto a Publicar
       oErp:nColor :=1          // Color a Mostrar

       oErp:cDescri:="Fecha de Tasa de Interés "+DTOC(dFecha)+" Actualizado"

       IF nMeses>2
          oErp:nColor :=4          // Color a Mostrar
          oErp:cDescri:="Fecha de Tasa de Interés  "+DTOC(dFecha)+" han transcurrido "+LSTR(nMeses)+" Meses por Actualizar"         
       ENDIF

       oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
