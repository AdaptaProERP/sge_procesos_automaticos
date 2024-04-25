// Proceso RESOBLIGANOREG      
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
   LOCAL cWhere,nCant:=0,aData,cSql
   LOCAL dFecha:=FCHFINMES(oDp:dFecha)

   IF !oDp:lPanel 
      EJECUTAR("BRRESOBLIGAX")
      RETURN .F.
   ENDIF

   cSql  :=" SELECT  "+;
           " COUNT(*) AS CUANTOS"+;
           " FROM DPDOCPROPROG    "+;
           " INNER JOIN DPPROVEEDOR     ON PLP_CODIGO=PRO_CODIGO       "+;
           " INNER JOIN DPPROVEEDORPROG ON PLP_CODSUC=PGC_CODSUC AND "+;
           "                               PLP_CODIGO=PGC_CODIGO AND"+;
           "                               PLP_TIPDOC=PGC_TIPDOC AND"+;
           "                               PLP_NUMERO=PGC_NUMERO AND"+;
           "                               PLP_REFERE=PGC_REFERE     "+;
           " LEFT  JOIN DPDOCPRO ON PLP_CODSUC=DOC_CODSUC AND"+;
           "                        PLP_TIPDOC=DOC_TIPDOC AND"+;
           "                        PLP_CODIGO=DOC_CODIGO AND"+;
           "                        PLP_NUMREG=DOC_PPLREG AND"+;
           "                        DOC_TIPTRA='D'     "+;
           " LEFT  JOIN VIEW_DPDOCPROPAG ON PLP_CODSUC=PAG_CODSUC AND "+;
           "                                PLP_TIPDOC=PAG_TIPDOC AND"+;
           "                                PLP_CODIGO=PAG_CODIGO AND"+;
           "                                PLP_NUMREG=PAG_NUMERO                           "+;
           " WHERE DPDOCPROPROG.PLP_FECHA "+GetWhere("<=",dFecha      )+" AND "+;
           "                    PLP_CODSUC"+GetWhere("=",oDp:cSucursal)+" AND "+;
           "                    DOC_NUMERO IS NULL "

       aData:=ASQL(cSql)
       nCant:=IF(LEN(aData)>0,ATOTALES(aData)[1],0)

       oErp:dFecha :=dFecha     // Fecha
       oErp:nMonto :=nCant      // Monto a Publicar
       oErp:nColor :=IIF(nCant>1,2,1)        // Color a Mostrar
       oErp:cDescri:="("+LSTR(nCant)+") Obligaciones y Compromisos por Ref. no Registrado"         // Descripción
       oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
