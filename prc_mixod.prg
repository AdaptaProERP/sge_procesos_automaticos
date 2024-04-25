// Proceso MIXOD               
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
      LOCAL dFecha:=SQLGETMAX("DPINV","INV_FCHACT","INV_LPT"+GetWhere("=","OD"))
      LOCAL lDescarga

      IF !oDp:lPanel
        EJECUTAR("MXCTAINVOD",NIL,lDescarga)
      ENDIF


      oErp:dFecha :=dFecha // Fecha
      oErp:nMonto :=oDp:dFecha-dFecha               // Monto a Publicar
      oErp:nColor :=IF(oErp:nMonto>1,2,1) // Color a Mostrar

      IF Empty(dFecha)
        oErp:cDescri:="No hay Actualización Precios OD"         // Descripción
      ELSE
        oErp:cDescri:=LSTR(oErp:nMonto)+" Dia(s) sin Actualizar Precios OD"         // Descripción
      ENDIF

      oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
