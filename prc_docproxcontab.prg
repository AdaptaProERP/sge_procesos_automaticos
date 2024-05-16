// Proceso DOCPROXCONTAB       
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
  LOCAL cWhere,cCodSuc,nPeriodo:=10,dDesde:=oDp:dFchInicio,dHasta:=oDp:dFchCierre,cTitle:=NIL,nCant:=0

  cCodSuc:=oDp:cSucursal
  dDesde :=oDp:dFchInicio
  dHasta :=oDp:dFchCierre

  IF !oDp:lPanel 
     EJECUTAR("BRDOCPRORESXCNT",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
     RETURN NIL
  ENDIF

  cSql:=[ SELECT MIN(DOC_FCHDEC) AS DESDE,MAX(DOC_FCHDEC) AS HASTA,]+;
        [ COUNT(IF(DOC_CBTNUM='',1, NULL)) AS XCONTAB, ]+;  
        [ COUNT(IF(DOC_CBTNUM<>'',1, NULL)) AS CONTAB, ]+; 
        [ SUM(IF(DOC_CBTNUM='',DOC_NETO*DOC_CXP,0)) AS SUMXCON,]+;   
        [ COUNT(*) AS CUANTOS ]+;
        [ FROM DPDOCPRO ]+;
        [ INNER JOIN DPTIPDOCPRO ON DOC_TIPDOC=TDC_TIPO AND TDC_CONTAB=1 ]+;
        [ WHERE ]+GetWhereAnd("DPDOCPRO.DOC_FCHDEC",dDesde,dHasta)+[ AND  DOC_TIPDOC<>'ANT' AND  DOC_CODSUC]+GetWhere("=",oDp:cSucursal)+[ AND DOC_TIPTRA='D' AND DOC_ACT=1 AND DOC_DOCORG<>'P' ]

  oTable:=OpenTable(cSql,.T.)
  oTable:End()


  oErp:dFecha :=oTable:DESDE          // Fecha
  oErp:nMonto :=oTable:XCONTAB        // , DOC_NETO // Monto a Publicar
  oErp:nColor :=IF(oErp:nMonto>0,2,1)
  oErp:cDescri:=LTRAN(oErp:nMonto)+" de "+LSTR(oTable:CUANTOS)+" ("+LSTR(RATA(oErp:nMonto,oTable:CUANTOS))+"%) Cant. Documentos de Proveedores por Contabilizar. Desde "+DTOC(oTable:DESDE)+" Hasta "+DTOC(oTable:HASTA)+;
                CRLF+" Monto : "+ALLTRIM(FDP(oTable:SUMXCON,"999,999,999,999.99"))

  oErp:cSPEAK :=oErp:cDescri

  oErp:lPanel :=.T.             // Publicar en el Panel

RETURN .T.
// EOF
