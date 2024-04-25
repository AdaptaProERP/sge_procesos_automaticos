// Proceso RETISLRAUTOMATICA   
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
  LOCAL cData

  oDp:lRetISLR:=.T.

  cData:="Todas las Retenciones de ISLR se Realiza en Forma Automática"

  oErp:dFecha :=CTOD("")   // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=1          // Color a Mostrar
  oErp:cDescri:=cData      // Descripción
  oErp:lPanel :=.T.        // Publicar en el Panel

// RETURN {"Todas las Retenciones de ISLR se Realiza en Forma Automática",0,1}
RETURN NIL
// EOF
