// Proceso TRABAJADORCUMP      
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
 LOCAL nCantid:=0,cData:=""

 DEFAULT oDp:lNomina:=.F.

 IF !oDp:lNomina
    RETURN NIL
 ENDIF

 nCantid:=EJECUTAR("NMTRABJCUMP")
 cData  :=LSTR(nCantid)+", Trabajador(es) Cumpleañeros del Mes"

 oErp:dFecha :=oDp:dFecha // Fecha
 oErp:nMonto :=nCantid    // Monto a Publicar
 oErp:nColor :=1          // Color a Mostrar
 oErp:cDescri:=cData      // Descripción
 oErp:lPanel :=.T.        // Publicar en el Panel

RETURN NIL
// {LSTR(nCantid)+", Trabajador(es) Cumpleañeros del Mes",nCantid,0}
// EOF
