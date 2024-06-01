// Proceso DPHISTABMON         
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
   LOCAL cSql,cWhere
   LOCAL dFecha:=SQLGET("DPHISMON","MAX(HMN_FECHA)","HMN_CODIGO"+GetWhere("=",oDp:cEurBcv  )+" GROUP BY HMN_CODIGO ORDER BY HMN_FECHA LIMIT 1 ")
   LOCAL nCant,nValor,nDias:=0

   IF !oDp:lPanel
     EJECUTAR("BRACTHISMON")
     RETURN NIL
   ENDIF

   cWhere  :=GetWhereAnd("DIA_FECHA",dFecha,oDp:dFecha)

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=0          // Monto a Publicar
   oErp:nColor :=3          // Color a Mostrar
   oErp:cDescri:=""         // Descripción
   oErp:lPanel :=.T.        // Publicar en el Panel

   cWhere:=" LEFT JOIN DPHISMON ON HMN_CODIGO"+GetWhere("=",oDp:cEurBcv  )+;
           " AND DIA_FECHA=HMN_FECHA WHERE "+cWhere+" AND  HMN_FECHA IS NULL ORDER BY DIA_FECHA"

   oDp:cErp_cMsg
:=""
   nCant:=COUNT("DPDIARIO",cWhere)

   IF nCant>0 .OR. !oDp:lPanel       MsgRun("Actualizado Valor de Euro Desde www.bcv.org.ve ["+oDp:cUsdBcv+"]"  ,"Por favor Espere",{||EJECUTAR("GETURLDIV_BCV",.T.  )})
   ENDIF

   cWhere:=" LEFT  JOIN DPHISMON ON DIA_FECHA=HMN_FECHA "+;
           " WHERE "+GetWhereAnd("DIA_FECHA",oDp:dFchInicio,oDp:dFecha)

   nDias :=SQLGET("DPDIARIO","COUNT(IF(HMN_VALOR IS NULL,1,NULL)) AS CUANTOS",cWhere)

   dFecha:=SQLGET("DPHISMON","MAX(HMN_FECHA)","HMN_CODIGO"+GetWhere("=",oDp:cEurBcv  )+" GROUP BY HMN_CODIGO ORDER BY HMN_FECHA LIMIT 1 ")
   cWhere:=GetWhereAnd("DIA_FECHA",dFecha,oDp:dFecha)
   nCant :=MAX(COUNT("DPDIARIO",cWhere)-1,0)
   nValor
:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=",oDp:cEurBcv  )+" AND HMN_FECHA"+GetWhere("=",dFecha))
  
   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=nCant      // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar

   oDp:nEurBcv :=nValor 
   IF oErp:nMonto>0

     oErp:nColor :=2 // Color a Mostrar

   
     oErp:cDescri:=LSTR(oErp:nMonto)+" Dia"+IF(oErp:nMonto>1,"s","")+;
                " sin Actualizar Euro www.bcv.org.ve/ ("+oDp:cEurBcv  +" ) Desde "+DTOC(dFecha)+CRLF+;
                " Valor: "+ALLTRIM(TRAN(nValor,"99,999,999.99"))
   ELSE

     oErp:nColor :=3
     oErp:cDescri:=" Valor Actual Euro en  www.bcv.org.ve/ ("+oDp:cEurBcv  +") Hoy "+DTOC(dFecha)+CRLF+;
                   " Valor: "+ALLTRIM(TRAN(nValor,"99,999,999.99"))+CRLF+;
                   LSTR(nDias)+" sin Registro desde el "+DTOC(oDp:dFchInicio)+" hasta el "+DTOC(oDp:dFecha)

 

   ENDIF

   IF !Empty(oDp:cErp_cMsg)
     oErp:cDescri:="Obtener Valor del Auro desde BCV.ORG.VE"+CRLF+oDp:cErp_cMsg
   ENDIF
     oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
