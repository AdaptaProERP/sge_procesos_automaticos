// Proceso DPHISTABMOBCOP      
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL cMoneda:="COP",dFecha:=oDp:dFecha,nDivide:=4000,nDec:=8
    LOCAL nValCam:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=","DBC")+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha))

    // Obtiene el Valor del Peso Según el Dólar

    EJECUTAR("PUTBCVCOP",cMoneda,dFecha,nDivide,nDec,nValCam)

    oErp:dFecha  :=oDp:dFecha // Fecha
    oErp:nMonto  :=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=",cMoneda)+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha))
    oErp:cPicture:="999.99999" 
    oErp:nColor  :=1          // Color a Mostrar
    oErp:cDescri :="Peso Colombiando COP según BCV("+LSTR(nValCam)+")/"+LSTR(nDivide)+CRLF+"Valor "+LSTR(oErp:nMonto,19,8)
    oErp:lPanel  :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
