// Proceso PLANCOBRANZA        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL aTotal

    aTotal:=EJECUTAR("DPDIAPLACOB",NIL,NIL,NIL,NIL,NIL,.T.)

    IF !Empty(aTotal)
        

    oErp:dFecha :=oDp:dFecha // Fecha
    oErp:nMonto :=aTotal[3]  // Monto a Publicar
    oErp:nColor :=1          // Color a Mostrar
    oErp:cDescri:="Planificación de Cobranza "+CRLF+;
                  "Monto :"+TRAN(oErp:nMonto,"999,999,999,999.99")+CRLF+;
                  "Tareas:"+TRAN(aTotal[4],"999999")

    oErp:lPanel :=.T.        // Publicar en el Panel

    IF !oDp:lPanel 
      EJECUTAR("DPDIAPLACOB")
    ENDIF

  ENDIF

RETURN .T.
// EOF
