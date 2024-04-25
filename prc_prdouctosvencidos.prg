// Proceso PRDOUCTOSVENCIDOS   
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
  LOCAL cSql,dDesde,dHasta,nCuantos:=0,cWhere:="",nExiste:=0
  LOCAL nPeriodo:=9,aData:={}

  dDesde:=FCHINIMES(oDp:dFecha)
  dHasta:=FCHFINMES(dDesde)

  IF !oDp:lPanel

    EJECUTAR("DPINVVENCIDOS",oDp:cSucursal,nPeriodo,dDesde,dHasta)

    RETURN .T.

  ENDIF

  oTable:=OpenTable(" SELECT COUNT(*) AS CUANTOS, "+;
                    " SUM(MOV_FISICO*MOV_CANTID*MOV_CXUND) AS EXISTE "+;
                    " FROM DPINVCAPAPRECIOS"+;
                    " LEFT JOIN DPMOVINV ON CAP_CODIGO=MOV_CODIGO AND MOV_CAPAP"+GetWhere("<>","")+;
                    " INNER JOIN DPINV ON MOV_CODIGO=INV_CODIGO   "+;
                    " WHERE MOV_CODSUC"+GetWhere("=",oDp:cSucursal)+;
                    "   AND MOV_INVACT=1  "+;
                    "   AND "+GetWhereAnd("CAP_FCHVEN",dDesde,dHasta)+;
                    " HAVING SUM(MOV_FISICO*MOV_CANTID*MOV_CXUND) > 0 ",;
                    ,.T.)

  nCuantos:=oTable:RecCount()
  nExiste :=oTable:EXISTE

  oTable:End()

  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=nExiste   // Monto a Publicar
  oErp:nColor :=IIF(nExiste=0,1,4)       // Color a Mostrar
  oErp:cDescri:=LSTR(nCuantos)+" Código(s) de Productos Vencidos "+DTOC(dDesde)+" "+DTOC(dHasta)+CRLF+;
                "Cantidad de Productos "+LSTR(nExiste)
  oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
