// Proceso NMTRABXSINTABLIQ    
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
  LOCAL nCuantos:=0

  IF !oDp:lNomina
    RETURN NIL
  ENDIF

  IF !oDp:lPanel
     EJECUTAR("NMTRABXLIQ")     
     RETURN .F.
  ENDIF

  nCuantos:=COUNT("NMTRABAJADOR "," LEFT JOIN NMTABLIQ ON LIQ_CODTRA=CODIGO AND LIQ_CODTRA IS NULL "+;
            " WHERE CONDICION"+GetWhere("=","A")+" AND FECHA_EGR>FECHA_ING ")


  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=IF(Empty(nCuantos),1,4)          // Color a Mostrar
  oErp:cDescri:=LSTR(nCuantos)+" Trabajadores Egresados y sin Liquidación"
  oErp:lPanel :=.T.        // Publicar en el Panel




RETURN .T.
// EOF
