// Proceso CBLCUOXFACTURAR     
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
      LOCAL cSql:=[ SELECT CXD_CODIGO,COUNT(*) AS CUANTOS ]+;
                  [ FROM view_docclicxcdiv ]+;
                  [ INNER JOIN dpclientes ON CXD_CODIGO=CLI_CODIGO AND (LEFT(CLI_RIF,1)="J" OR LEFT(CLI_RIF,1)="G") ]+;
                  [ WHERE CXD_CODSUC]+GetWhere("=",oDp:cSucursal)+[ AND CXD_TIPDOC="CUO" ]+;
                  [ GROUP BY CXD_CODIGO ]

      LOCAL oTable

      IF !oDp:lPanel 
         EJECUTAR("BRCBLCUOXFACT",NIL,NIL,oDp:nIndefinida,NIL,NIL,NIL)
         RETURN NIL
      ENDIF

      oTable:=OpenTable(cSql,.T.)

      oErp:dFecha :=oDp:dFecha        // Fecha
      oErp:nMonto :=oTable:RECCOUNT() // Monto a Publicar
      oErp:nColor :=2

      IF oErp:nMonto>0
         oErp:nColor :=3 // IF(oErp:nMonto>1,2,3)                 // Color a Mostrar
      ENDIF

      oErp:cDescri:=LSTR(oTable:RECCOUNT())+" Socios Jurídicos por Facturar "
      oErp:lPanel :=.T.        // Publicar en el Panel

      oTable:End()

RETURN .T.
// EOF
