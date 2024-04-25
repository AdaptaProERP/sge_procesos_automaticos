// Proceso LOTESVENCE          
#INCLUDE "DPXBASE.CH"

PROCE MAIN(uPar)
    LOCAL nMeses:=6,I,dFchVence:=DPFECHA(),cSql,nLotes,oTable,nExiste,nValor
    LOCAL dFchMax:=CTOD(""),dFchMin:=CTOD(""),cWhere

    FOR I=1 TO nMeses
       dFchVence:=FCHFINMES(FCHINIMES(dFchVence))+1
    NEXT I

    dFchVence:=FCHFINMES(dFchVence)

    cWhere:=" MOV_LOTE"+GetWhere("<>","")+" AND "+;
            " MOV_INVACT<>0 AND  "+;
            " MOV_FCHVEN"+GetWhere("<=",dFchVence)+" AND "+;
            " MOV_FCHVEN"+GetWhere("<>",CTOD(""))

    dFchMax:=SQLGETMAX("DPMOVINV","MOV_FCHVEN",cWhere+" AND MOV_FCHVEN"+GetWhere("<>",CTOD("")))
    dFchMin:=SQLGETMIN("DPMOVINV","MOV_FCHVEN",cWhere+" AND MOV_FCHVEN"+GetWhere("<>",CTOD("")))

    IF !oDp:lPanel

      EJECUTAR("BRLOTESVNC",cWhere)
      RETURN NIL

    ENDIF
 
    cSql:=" SELECT COUNT(*) AS LOTES, SUM(MOV_CANTID*MOV_FISICO*MOV_CXUND) AS EXISTE,"+;
          " SUM(MOV_CANTID*MOV_FISICO*MOV_CXUND*MOV_COSTO) AS VALOR "+;
          " FROM DPINV "+;
          " INNER JOIN DPMOVINV ON MOV_CODIGO=INV_CODIGO "+;
          " WHERE "+cWhere+;
          " HAVING SUM(MOV_CANTID*MOV_FISICO*MOV_CXUND)>0 "

     oDp:lExcluye:=.F.

     oTable :=OpenTable(cSql,.T.)
     nLotes :=oTable:LOTES
     nExiste:=oTable:EXISTE
     nValor :=oTable:VALOR
     oTable:End()

     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=nValor     // Monto a Publicar
     oErp:nColor :=2          // Color a Mostrar
     oErp:cDescri:=LSTR(nLotes)+" Lote(s) por Vencer al "+DTOC(dFchVence)+CRLF+;
                   LSTR(nExiste)+" Unidad(es) Valorada en "+TRAN(nValor,"99,999,999.99")+CRLF+;
                  " del "+DTOC(dFchMin)+" al "+DTOC(dFchMax)
     oErp:lPanel :=.T.        // Publicar en el Panel


RETURN .T.
// EOF
