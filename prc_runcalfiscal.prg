// Proceso RUNCALFISCAL        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
   LOCAL cWhere,nCuantos:=0,cWhere,cCodSuc
   LOCAL dDesde:=FCHINIMES(oDp:dFecha)
   LOCAL dHasta:=FCHFINMES(dDesde)

   IF !oDp:lPanel
      EJECUTAR("CALFRM")
      RETURN .T.
   ENDIF
    
   cWhere:=[ INNER JOIN DPPROVEEDOR      ON PLP_CODIGO=PRO_CODIGO AND LEFT(PRO_TIPO,1)='R' ]+;
           [ INNER JOIN DPPROVEEDORPROG  ON PLP_CODSUC=PGC_CODSUC AND PLP_CODIGO=PGC_CODIGO AND ]+;
           [                                PLP_TIPDOC=PGC_TIPDOC AND PLP_NUMERO=PGC_NUMERO AND ]+;
           [                                PLP_REFERE=PGC_REFERE ]+;
           [ LEFT  JOIN DPDOCPRO         ON PLP_CODSUC=DOC_CODSUC AND PLP_TIPDOC=DOC_TIPDOC AND PLP_CODIGO=DOC_CODIGO AND PLP_NUMREG=DOC_NUMERO AND  DOC_TIPTRA='D']+;    
           [ LEFT  JOIN VIEW_DPDOCPROPAG ON PLP_CODSUC=PAG_CODSUC AND PLP_TIPDOC=PAG_TIPDOC AND PLP_CODIGO=PAG_CODIGO AND PLP_NUMREG=PAG_NUMERO ]+;
           [ WHERE PLP_CODSUC]+GetWhere("=",oDp:cSucMain)+[ AND ]+;
           GetWhereAnd("PLP_FECHA",dDesde,dHasta)
              
   nCuantos:=COUNT("DPDOCPROPROG",cWhere)


   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=nCuantos   // Monto a Publicar
   oErp:nColor :=IF(nCuantos>0,1,4) // Color a Mostrar
   oErp:cDescri:=LSTR(nCuantos)+ " Registro(s) del Calendario Fiscal "+DTOC(dDesde)+" - "+DTOC(dHasta)
   oErp:lPanel :=.T.        // Publicar en el Panel
   oErp:nNivPri:=1

   EJECUTAR("CALFRM")

RETURN .T.
// EOF
