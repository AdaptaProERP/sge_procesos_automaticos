// Proceso DPHISTABMOBBCVCOP   
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL cMoneda:="COP"
    LOCAL lFind  :=COUNT("DPHISMON","HMN_CODIGO"+GetWhere("=",cMoneda)+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha))>0 

    IF !lFind

      IF ValType(oDp:oMsgRun)="O"
         oDp:oMsgRun:oSay:SetText("Actualizado Valor del Peso Colombiano Desde www.bcv.org.ve ")
      ENDIF 

      EJECUTAR("GETBCVCOP")

    ENDIF

    oErp:dFecha  :=oDp:dFecha // Fecha
    oErp:nMonto  :=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=",cMoneda)+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha))
    oErp:cPicture:="999.99999" 
    oErp:nColor  :=1          // Color a Mostrar
    oErp:cDescri :="Peso Colombiando según BCV"+CRLF+"Valor "+LSTR(oErp:nMonto,19,8)
    oErp:lPanel  :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
