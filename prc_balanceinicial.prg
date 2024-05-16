// Proceso CTAIMPORT
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
  LOCAL nCantid:=COUNT("DPCTA","CTA_CODMOD"+GetWhere("=",oDp:cCtaMod))
  LOCAL nAsientos:=0
  LOCAL cDescri:=""

  IF !oDp:lPanel
    EJECUTAR("BRBALINIDIV")   
    RETURN .T.
  ENDIF

  nAsientos   :=COUNT("DPASIENTOS")
  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=2          // Color a Mostrar
  oErp:lPanel :=.T.        // Publicar en el Panel

  IF nCantid>1 .AND. nAsientos=0

    oErp:cDescri:="No existe el Balance Inicial"+CRLF+"Presione Click para Registrarlo"
    oErp:nColor :=4     
    oErp:nMonto :=0  
    oErp:cSPEAK :="Será presentado el formulario para que Registre el Balance Inicial" 
    EJECUTAR("BRBALINIDIV") 
  
  ENDIF

RETURN .T.
// EOF

