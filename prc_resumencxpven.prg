// Proceso RESUMENCXP          
#INCLUDE "DPXBASE.CH"

PROCE MAIN(uPar)
 LOCAL aData:={},nNeto:=0,nVence:=0,cData:="XXXX"
 LOCAL cSql

 IF !oDp:lPanel 
    aData:=EJECUTAR("BRDPDOCCXPRES" , NIL , NIL , oDp:lPanel , NIL )
    RETURN .F.
 ENDIF

 cSql:=" SELECT SUM(DOC_CXP*DOC_NETO) AS DOC_NETO, "+;
       " SUM(DOC_MTOIVA*DOC_CXP) AS DOC_MTOIVA, "+;
       " SUM((DOC_NETO *DOC_CXP)* IF(DOC_FCHVEN<='2018-02-17',1,0)) AS VENCIDO "+;
       " FROM DPDOCPRO "+;
       " WHERE DOC_CODSUC"+GetWhere("=",oDp:cSucursal)+" AND DOC_CXP<>0 AND DOC_ACT=1 AND DOC_FECHA"+GetWhere("<=",oDp:dFecha)+;
       " HAVING SUM(DOC_CXP*DOC_NETO)<>0 "

  aData:=ASQL(cSql)

  IF ValType(aData)="A" 

     AEVAL(aData,{ |a,n| nNeto :=nNeto+ a[1] ,;
                         nVence:=nVence+a[3] })

     cData:="Resumen de Cuentas por Pagar "+CRLF+;
            "Monto:  "+TRAN(nNeto ,"999,999,999,999.99")+CRLF+;
            "Vencido:"+TRAN(nVence,"999,999,999,999.99")

  ENDIF

  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=nNeto      // Monto a Publicar
  oErp:nColor :=1          // Color a Mostrar
  oErp:cDescri:=cData      // Descripción
  oErp:lPanel :=.T.        // Publicar en el Panel


RETURN NIL
// EOF
