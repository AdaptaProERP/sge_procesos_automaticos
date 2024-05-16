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
  LOCAL cDescri:=""

  IF !oDp:lPanel
    EJECUTAR("DPCTAIMPORT")   
    RETURN .T.
  ENDIF
 
  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=2          // Color a Mostrar
  oErp:lPanel :=.T.        // Publicar en el Panel

  IF nCantid<=1

    oErp:cDescri:="Plan de cuentas no está registrado"+CRLF+"Presione Click para Importarlo desde Excel"
    oErp:nColor :=4     
    oErp:nMonto :=0  
    oErp:cSPEAK :="Será presentado el formulario para que importes el plan de cuentas" 
    EJECUTAR("DPCTAIMPORT")   

  ELSE

    oErp:cDescri:=LSTR(nCantid)+" Registros en el Plan de Cuentas "

  ENDIF

RETURN .T.
// EOF
