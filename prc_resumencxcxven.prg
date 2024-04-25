// Proceso RESUMENCXCXVEN      
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
   LOCAL nCxC,cCodVen

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=0          // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar
   oErp:cDescri:=""         // Descripción
   oErp:lPanel :=.T.        // Publicar en el Panel

   cCodVen:=EJECUTAR("DPGETCODVEN")

   IF Empty(cCodVen)
      oErp:cDescri:="Usuario "+oDp:cUsuario+" no esta Asociado en "+oDp:DPVENDEDOR
      RETURN NIL
   ENDIF
  

   nCxC:=SQLGET("DPDOCCLI","SUM(DOC_CXC*DOC_NETO)",;
                "INNER JOIN DPCLIENTES ON CLI_CODIGO=DOC_CODIGO WHERE "+;
                "DOC_CODSUC"+GetWhere("= ",oDp:cSucursal)+" AND "+;
                "DOC_FECHA "+GetWhere("<=",oDp:dFecha   )+" AND DOC_CXC<>0 AND DOC_ACT=1 AND "+;
                "CLI_CODVEN"+GetWhere("=" ,cCodVen      ))

   oErp:cDescri:="Cuentas por Cobrar del "+oDp:xDPVENDEDOR+" "+cCodVen  +CRLF+;
                 SQLGET("DPVENDEDOR","VEN_NOMBRE","VEN_CODIGO"+GetWhere("=",cCodVen))+CRLF+;
                 "Monto : "+TRAN(nCxC,"999,999,999.99")
   oErp:nMonto :=nCxC 

   IF !oDp:lPanel .OR. nCxC<>0
      EJECUTAR("DPDOCCXCRES",NIL,NIL,NIL,NIL,cCodVen)
      RETURN NIL
   ENDIF


RETURN .T.
// EOF
