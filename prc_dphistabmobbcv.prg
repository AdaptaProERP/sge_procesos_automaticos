// Proceso DPHISTABMOBBCV             
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
   LOCAL dFecha:=NIL
   LOCAL nCant,nValor,nDias:=0

   DEFAULT oDp:cUsdBcv:="DBC",;
           oDp:cPictureDivisa:="999,999,999.99999"

   oDp:dFechaBcv:=oDp:dFecha

   dFecha :=SQLGET("DPHISMON","MAX(HMN_FECHA)","HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+" GROUP BY HMN_CODIGO ORDER BY HMN_FECHA LIMIT 1 ")

   // Cotización Publicada el Martes por el BCV cuando el lunes no hay Actividad Bancaria
   cWhere:="HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha)

   nValor:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha))

   // 11/09/2023
   IF DOW(dFecha)=3 .AND. DOW(oDp:dFecha)=2 .AND. !ISSQLFIND("DPHISMON",cWhere)
 
      EJECUTAR("CREATERECORD","DPHISMON",{"HMN_CODIGO","HMN_FECHA"  ,"HMN_HORA","HMN_VALOR"},;
                                         {oDp:cUsdBcv ,oDp:dFecha   ,"00:00:00"   ,nValor  },NIL,.T.,cWhere)
   ENDIF

   cWhere:=GetWhereAnd("DIA_FECHA",dFecha,oDp:dFecha)

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=nValor     // Monto a Publicar
   oErp:nColor :=3          // Color a Mostrar
   oErp:cDescri:=""         // Descripción
   oErp:lPanel :=.T.        // Publicar en el Panel

   cWhere:=" LEFT JOIN DPHISMON ON HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+;
           " AND DIA_FECHA=HMN_FECHA WHERE "+cWhere+" AND  HMN_FECHA IS NULL ORDER BY DIA_FECHA"

   nCant:=COUNT("DPDIARIO",cWhere)

   oDp:cErp_cMsg:=""

   IF nValor=0 .AND. oDp:lPanel  

       IF ValType(oDp:oMsgRun)="O"
         oDp:oMsgRun:oSay:SetText("Actualizado Valor de Divisa Desde www.bcv.org.ve ["+oDp:cUsdBcv+"]")
         EJECUTAR("GETURLDIV_BCV",.T.  )
       ELSE
         MsgRun("Actualizado Valor de Divisa Desde www.bcv.org.ve ["+oDp:cUsdBcv+"]"  ,"Por favor Espere",{||EJECUTAR("GETURLDIV_BCV",.T.  )})
       ENDIF

     // 25/08/2023 Si este Proceso Está Activo, Obtiene el valor del COP
     IF ISSQLFIND("DPPROCESOS","PRC_CODIGO"+GetWhere("=","DPHISTABMOBCOP")+ " AND PRC_ACTIVO=1")
        EJECUTAR("PUTBCVCOP")
     ENDIF

   ENDIF

   cWhere:=" LEFT  JOIN DPHISMON ON DIA_FECHA=HMN_FECHA "+;
           " WHERE "+GetWhereAnd("DIA_FECHA",oDp:dFchInicio,oDp:dFecha)

   nDias :=SQLGET("DPDIARIO","COUNT(IF(HMN_VALOR IS NULL,1,NULL)) AS CUANTOS",cWhere)
   dFecha:=SQLGET("DPHISMON","HMN_FECHA","HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+" AND  HMN_FECHA"+GetWhere("=",oDp:dFechaBcv))

   IF Empty(dFecha)
      dFecha:=SQLGET("DPHISMON","MAX(HMN_FECHA)","HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+" GROUP BY HMN_CODIGO ORDER BY HMN_FECHA DESC LIMIT 1 ")
   ENDIF

   cWhere:=GetWhereAnd("DIA_FECHA",dFecha,oDp:dFecha)
   nCant :=MAX(COUNT("DPDIARIO",cWhere)-1,0)
   nValor:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv  )+" AND HMN_FECHA"+GetWhere("=",dFecha))
  
   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=nCant      // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar
   oDp:nUsdBcv :=nValor

//   IF nValor>0
//     oErp:nMonto :=nValor   // Monto a Publicar
//   ENDIF

   // Valor del USD
   IF oErp:nMonto>0

     oErp:nColor :=2 // Color a Mostrar
     oErp:cDescri:=LSTR(nCant)+" Dia"+IF(nCant>1,"s","")+;
                " sin Actualizar Dolar www.bcv.org.ve/ ("+oDp:cUsdBcv  +" ) Desde "+DTOC(dFecha)+CRLF+;
                " Valor: "+ALLTRIM(TRAN(nValor,oDp:cPictureDivisa))
   ELSE

     oErp:nColor :=3
     oErp:cDescri:=" Valor Actual Dólar www.bcv.org.ve/ ("+oDp:cUsdBcv  +") Hoy "+DTOC(dFecha)+CRLF+;
                   " Valor: "+ALLTRIM(TRAN(nValor,oDp:cPictureDivisa))+CRLF+;
                   LSTR(nDias)+" sin Registro desde el "+DTOC(oDp:dFchInicio)+" hasta el "+DTOC(oDp:dFecha)

     oErp:nMonto :=nValor   // Monto a Publicar

   ENDIF

   IF !Empty(oDp:cErp_cMsg)
     oErp:cDescri:="Obtener Valor del Dolar desde bcv.org.ve "+CRLF+oDp:cErp_cMsg
   ENDIF
 
   oErp:lPanel :=.T.        // Publicar en el Panel

   IF !oDp:lPanel 
     EJECUTAR("BRACTHISMON","HMN_CODIGO"+GetWhere("=",oDp:cUsdBcv))
     RETURN NIL
   ENDIF

RETURN .T.
// EOF
