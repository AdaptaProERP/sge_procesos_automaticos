// Proceso MYCHARSET        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)

    EJECUTAR("MYSQLCHARSET")

    oErp:dFecha :=oDp:dFecha // Fecha
    oErp:nMonto :=0          // Monto a Publicar
    oErp:nColor :=1          // Color a Mostrar
    oErp:cDescri:="CharSet="+oDp:cMyCharSet+CRLF+;
                  "Collate="+oDp:cMyCollate

    oErp:lPanel :=.T.        // Publicar en el Panel

    IF !oDp:lPanel 
      EJECUTAR("MYCHARSETBD",oDp:cDsnData)
      RETURN NIL
    ENDIF
 RETURN .T.
// EOF
