// Proceso DOCCLIXCONTAB       
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
  LOCAL cSql,oTable
  LOCAL dDesde,dHasta
  LOCAL cWhere,cCodSuc,nPeriodo:=11,dDesde,dHasta,cTitle:=NIL
 
  cSql:=[ SELECT  ]+;
        [ MIN(IF(MOB_COMPRO='',MOB_FECHA,NULL)) AS DESDE, ]+;   
        [ MAX(IF(MOB_COMPRO='',MOB_FECHA,NULL)) AS HASTA, ]+;   
        [ COUNT(IF(MOB_COMPRO='',1, NULL)) AS XCONTAB,  ]+;
        [ SUM(IF(MOB_COMPRO='',MOB_MONTO*TDB_SIGNO,0)) AS MOB_MONTO, ]+;
        [ COUNT(*) AS CUANTOS ]+;
        [ FROM DPCTABANCOMOV ]+;
        [ INNER JOIN DPBANCOTIP ON MOB_TIPO=TDB_CODIGO ]+;
        [ WHERE MOB_CODSUC]+GetWhere("=",oDp:cSucursal)+[ AND MOB_ACT=1 ]

  oTable:=OpenTable(cSql,.T.)

  dDesde:=SQLTODATE(oTable:DESDE)
  dHasta:=SQLTODATE(oTable:HASTA)
  oTable:End()

  IF !oDp:lPanel 
     dHasta:=IF(Empty(dDesde),dDesde,dHasta)
     EJECUTAR("BRCTABCOMOVXCON",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
     RETURN NIL
  ENDIF 
  oErp:dFecha :=dDesde              // Fecha
  oErp:nMonto :=oTable:XCONTAB      // Monto a Publicar
  oErp:nColor :=IF(oTable:XCONTAB>0,2,1)      
  oErp:cDescri:=LTRAN(oTable:XCONTAB)+" de "+LTRAN(oTable:CUANTOS)+" ("+LSTR(RATA(oTable:XCONTAB,oTable:CUANTOS))+")"+;
                " Movimientos Bancarios por Contabilizar"+CRLF+;
                "Desde "+CTOO(dDesde)+" Hasta "+CTOO(dHasta)

  oErp:lPanel :=.T.             // Publicar en el Panel


RETURN .T.
// EOF
