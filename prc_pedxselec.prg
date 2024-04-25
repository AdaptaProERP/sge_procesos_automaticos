// Proceso PEDXSELEC           
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
       LOCAL oTable,cSql,cDescri:=""
     
       IF !oDp:lPanel
         EJECUTAR("BRSELPEDAPROB")
         RETURN .T.
       ENDIF


       cSql:=" SELECT SUM(DOC_NETO) AS DOC_NETO,MIN(DOC_FECHA) AS DOC_DESDE,MAX(DOC_FECHA) AS DOC_HASTA,COUNT(*) DOC_CANTID "+;
             " FROM DPDOCCLI "+;
             " WHERE DOC_CODSUC"+GetWhere("=",oDp:cSucursal)+;
             "   AND DOC_TIPDOC='PED' AND DOC_TIPTRA='D' AND DOC_ACT=1 AND (DOC_ESTADO='AC' OR DOC_ESTADO='SE') AND DOC_NETO>0 "

       oTable:=OpenTable(cSql,.T.)
       oTable:End()

       oErp:dFecha :=oTable:DOC_HASTA // Fecha
       oErp:nMonto :=oTable:DOC_NETO  // Monto a Publicar
       oErp:nColor :=1          // Color a Mostrar

       IF oTable:DOC_CANTID>0
          cDescri:="Desde "+DTOC(oTable:DOC_DESDE)+" Hasta "+DTOC(oTable:DOC_HASTA)+CRLF+;
                   "Monto: "+ALLTRIM(FDP(oTable:DOC_NETO,"99,999,999,999.99"))
          oErp:nColor :=2
       ENDIF

       oErp:cDescri:=LSTR(oTable:DOC_CANTID)+" Pedido(s) por Aprobación "+CRLF+cDescri    // Descripción
       oErp:lPanel :=.T.        // Publicar en el Panel



RETURN .T.
// EOF
