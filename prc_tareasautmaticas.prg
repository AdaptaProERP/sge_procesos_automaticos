// Proceso TAREASAUTMATICAS    
#INCLUDE "DPXBASE.CH"

PROCE MAIN(uPar)
  LOCAL nCuantos:=0,dDesde:=CTOD(""),dHasta:=CTOD("")

  nCuantos:=COUNT("DPTAREASXEJEC","TXE_EJECUT=0")

  oErp:dFecha :=oDp:dFecha     // Fecha
  oErp:nMonto :=LSTR(nCuantos) // Monto a Publicar
  oErp:nColor :=4              // Color a Mostrar
  oErp:cDescri:="["+LSTR(nCuantos)+"] Tareas Automáticas por Ejecutar" +CRLF+;
                "Todos los Usuarios"

  oErp:lPanel :=.T.            // Publicar en el Panel

  IF !oDp:lPanel

     EJECUTAR("DPTARAUTEJEC",NIL,NIL,dDesde,dHasta,oDp:cUsuario)
 
  ENDIF

RETURN .T.
//


RETURN .T.
// EOF
