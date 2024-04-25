// Proceso RECVSCAJAMOV         
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
  LOCAL cWhere,cCodSuc,nPeriodo:=11,dDesde,dHasta,cTitle,nCant:=0

  IF !oDp:lPanel 
     EJECUTAR("BRRECVSMOVCAJ",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
     RETURN NIL
  ENDIF


  cSql  :=[ SELECT COUNT(*) AS CUANTOS]+;
          [ FROM DPRECIBOSCLI ]+;
          [ INNER JOIN DPCAJAMOV  ON REC_CODSUC=CAJ_CODSUC AND REC_NUMERO=CAJ_DOCASO AND CAJ_ORIGEN="REC" ]+;
          [ WHERE CAJ_ACT=0 AND REC_ACT=1 ]

  oTable:=OpenTable(cSql,.T.)
  nCant:= oTable:CUANTOS
  oTable:End()

  oErp:nMonto :=nCant
  oErp:nColor :=IF(oErp:nMonto>0,4,1)

  oErp:cDescri:=LTRAN(oErp:nMonto)+" Recibos de Ingreso con Movimientos de Caja Inactivos "+CRLF+"con Cuentas Indefinidas"
  oErp:cSPEAK :=oErp:cDescri
      
  oErp:lPanel :=.T.             // Publicar en el Panel


RETURN .T.
// EOF
