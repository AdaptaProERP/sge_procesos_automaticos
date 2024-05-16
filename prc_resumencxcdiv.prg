// Proceso RESUMENCXC          
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
  LOCAL cSql,nDolar,nMonto,dFecha
  LOCAL cWhere,cSql,oTable,nCant:=0

/*
  cWhere:=" LEFT JOIN DPHISMON ON HMN_CODIGO"+GetWhere("=",oDp:cMonedaExt)+" AND HMN_FECHA=CXD_FECHA  "+;
          " WHERE CXD_CODSUC"+GetWhere("=",oDp:cSucursal)+;
          " AND   CXD_FECHA "+GetWhere("<=",oDp:dFecha)

  nDolar:=SQLGET("VIEW_DOCCLICXC","SUM((CXD_NETO/HMN_VALOR)) AS CANTDIV,"+;
                                  "SUM((CXD_NETO/HMN_VALOR))*"+GetWhere("",oDp:nKpiValor)+" AS MTODIV",;
                                  cWhere)
  nMonto:=DPSQLROW(2,0)
*/

  cSql:=[ SELECT  SUM(CXD_NETO)   AS DOC_NETO, SUM(CXD_CXCDIV) AS CXD_CXCDIV, COUNT(*) AS CUANTOS  ]+;
        [ FROM view_docclicxcdiv  ]+;
        [ WHERE CXD_CODSUC]+GetWhere("=",oDp:cSucursal)+[ AND CXD_FCHMAX ]+GetWhere("<=",oDp:dFecha)

  IF !oDp:lPanel 
     // EJECUTAR("BRCXCENDIV",NIL,NIL,11,NIL,NIL,NIL)
     EJECUTAR("BRCXC")
     RETURN NIL
  ENDIF

  oTable:=OpenTable(cSql,.T.)
  nMonto:=oTable:DOC_NETO
  nDolar:=oTable:CXD_CXCDIV
  nCant :=oTable:CUANTOS
  oTable:End(.T.)

  dFecha       :=SQLGET("DPHISMON","MAX(HMN_FECHA)","HMN_CODIGO"+GetWhere("=",oDp:cMonedaExt)+" GROUP BY HMN_CODIGO ORDER BY HMN_FECHA LIMIT 1 ")
  oErp:dFecha  :=dFecha     // Fecha
  oErp:nMonto  :=nMonto     // Monto a Publicar
  oErp:nColor  :=2          // Color a Mostrar
  oErp:cPicture:="999,999,999,999,999.99"
  oErp:cDescri :="Cuentas por Cobrar CxC "+ALLTRIM(TRAN(nDolar,oErp:cPicture))+"("+oDp:cMonedaExt+")"+CRLF+;
                 "Actualizado Bs "+ALLTRIM(TRAN(nMonto,oErp:cPicture))+" al "+DTOC(dFecha)+CRLF+;
                 "#Clientes="+LSTR(nCant)
                
  oErp:lPanel :=.T.        // Publicar en el Panel
  

RETURN NIL 
// {cData,nNeto}
// EOF


