// Proceso TAREASAUTMXUSUARIO  
#INCLUDE "DPXBASE.CH"

PROCE MAIN(uPar)
  LOCAL nCuantos:=0,dDesde:=CTOD(""),dHasta:=CTOD("")

  nCuantos:=COUNT("DPTAREASXEJEC","TXE_EJECUT=0 AND TXE_USUREG"+GetWhere("=",oDp:cUsuario))

  oErp:dFecha :=oDp:dFecha     // Fecha
  oErp:nMonto :=LSTR(nCuantos) // Monto a Publicar
  oErp:nColor :=4              // Color a Mostrar
  oErp:cDescri:="["+LSTR(nCuantos)+"] Tareas Automáticas por Ejecutar" +CRLF+;
                "Usuario "+oDp:cUsuario+" "+;
                SQLGET("DPUSUARIOS","OPE_NOMBRE","OPE_NUMERO"+GetWhere("=",oDp:cUsuario))

  oErp:lPanel :=.T.            // Publicar en el Panel

  IF !oDp:lPanel

     EJECUTAR("DPTARAUTEJEC",NIL,NIL,dDesde,dHasta,oDp:cUsuario)
 
  ENDIF

RETURN .T.
// EOF
