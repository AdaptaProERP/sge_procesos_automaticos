// Proceso DPHISTABMON         
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(dDesde,dHasta)
   LOCAL cSql,cWhere:=NIL
   LOCAL dFecha:=NIL
   LOCAL nCant,nValor,nDias:=0,nCbt:=0
   LOCAL cSql,dDesde_:=CTOD(""),dHasta_:=CTOD("")
   LOCAL oTable

   DEFAULT dDesde:=oDp:dFechaIni,;
           dHasta:=oDp:dFechaFin

   IF !oDp:lPanel 
     cWhere:=NIL
     EJECUTAR("BRACTHISMON",cWhere,oDp:cSucursal,10,dDesde,dHasta,NIL,oDp:cMonedaExt)
     RETURN NIL
   ENDIF

   cWhere:="MOC_CODSUC"+GetWhere("=",oDp:cSucursal)+" AND "+;
           "MOC_ACTUAL"+GetWhere("<>","N")+" AND "+;
           GetWhereAnd("MOC_FECHA",dDesde,dHasta)

   nCbt  :=COUNT("DPASIENTOS",cWhere)

   cWhere:=" HMN_CODIGO"+GetWhere("=",oDp:cMonedaExt)+;
           " ORDER BY HMN_FECHA DESC LIMIT 1 "

   nValor :=SQLGET("DPHISMON","HMN_VALOR,HMN_FECHA",cWhere)
   dFecha :=DPSQLROW(2,"D")

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=0          // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar
   oErp:cDescri:=""         // Descripción
   oErp:lPanel :=.T.        // Publicar en el Panel

   cWhere:=" LEFT  JOIN DPHISMON ON HMN_CODIGO"+GetWhere("=",oDp:cMonedaExt)+;
           " AND CBT_FECHA=HMN_FECHA "+;
           " WHERE "+GetWhereAnd("CBT_FECHA",dDesde,dHasta)+" AND HMN_FECHA IS NULL "


   nCant  :=SQLGET("VIEW_DPCBTEDIA","SUM(CBT_CANT)",cWhere)
   dDesde_:=SQLGET("VIEW_DPCBTEDIA","MIN(CBT_FECHA),MAX(CBT_FECHA)",cWhere)
   dHasta_:=DPSQLROW(2,"D")

   cSql   :=" SELECT MIN(MOC_FECHA) AS DESDE,MAX(MOC_FECHA) AS HASTA,COUNT(*) AS CUANTOS "+;
            " FROM DPASIENTOS  "+;
            " LEFT JOIN DPHISMON DPHISMON ON HMN_CODIGO"+GetWhere("=",oDp:cMonedaExt)+" AND HMN_FECHA=MOC_FECHA "+;
            " WHERE MOC_CODSUC"+GetWhere("=",oDp:cSucursal)+" AND "+GetWhereAnd("MOC_FECHA",dDesde,dHasta)+" AND MOC_ACTUAL<>'N' AND HMN_FECHA IS NULL "

   oTable :=OpenTable(cSql,.T.)
   nCant  :=oTable:CUANTOS
   dDesde_:=oTable:DESDE
   dHasta_:=oTable:HASTA
   oTable:End()
   oErp:dFecha :=dFecha     // Fecha

   oErp:nMonto :=nCant      // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar

   oErp:cDescri:=LSTR(oErp:nMonto)+" de "+LSTR(nCbt)+" ("+LSTR(RATA(oErp:nMonto,nCbt))+"%) Comprobante"+IF(oErp:nMonto>1,"s","")+" Contable"+;
                 " sin Vinculos con Divisa ("+oDp:cMonedaExt+" ) Desde "+DTOC(dDesde_)+" Hasta "+DTOC(dHasta_)+CRLF+;
                 "Ultima Actualización "+DTOC(dFecha)+" Valor "+ALLTRIM(TRAN(nValor,"999,999,999,999.99"))
/*
   oErp:cDescri:=LSTR(oErp:nMonto)+" Comprobante"+IF(oErp:nMonto>1,"s","")+" Contable"+;
                 " sin Vinculos con Divisa ("+oDp:cMonedaExt+" ) Desde "+DTOC(dDesde_)+" Hasta "+DTOC(dHasta_)+CRLF+;
                 "Ultima Actualización "+DTOC(dFecha)+" Valor "+ALLTRIM(TRAN(nValor,"999,999,999,999.99"))

*/

   IF oErp:nMonto>0

     oErp:nColor :=4 // Color a Mostrar

   ENDIF

   oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
