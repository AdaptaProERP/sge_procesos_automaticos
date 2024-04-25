// Proceso RECMON2018          
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
LOCAL nCant:=0

   IF oDp:dFecha>=CTOD("15/06/2018")
      oErp:lPanel :=.F.   // No aparece en el Panel ERP
      RETURN .F.
   ENDIF

   IF !oDp:lPanel
      EJECUTAR("BRDPEMPPLAREC",.F.)
      RETURN .T.
   ENDIF

   nCant:=EJECUTAR("BRDPEMPPLAREC",.T.)

   oErp:dFecha :=oDp:dFecha        // Fecha
   oErp:nMonto :=nCant             // Monto a Publicar
   oErp:nColor :=IF(nCant=0,1,2)   // Color a Mostrar
   oErp:cDescri:=LSTR(nCant)+" Empresa(s) para Reconversion Monetaria"     
   oErp:lPanel :=.T.               // Publicar en el Panel

RETURN .T.
// EOF
