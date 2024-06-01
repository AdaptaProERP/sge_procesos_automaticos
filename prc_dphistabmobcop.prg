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
    LOCAL nValCam

    nValCam:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=","DBC")+" AND HMN_FECHA"+GetWhere("=",dFecha))

    // Domingo
    IF nValCam=0 .AND. DOW(dFecha)=1
       dFecha:=dFecha+1 // Lunes
       nValCam:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=","DBC")+" AND HMN_FECHA"+GetWhere("=",dFecha))
    ENDIF

    // Sabado
    IF nValCam=0 .AND. DOW(dFecha)=7
       dFecha:=dFecha+2 // Lunes
       nValCam:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=","DBC")+" AND HMN_FECHA"+GetWhere("=",dFecha))
    ENDIF

    // Lunes, buscara el dolar el dia martes
    IF nValCam=0 .AND. DOW(dFecha)=2
       dFecha:=dFecha+1 // Lunes
       nValCam:=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=","DBC")+" AND HMN_FECHA"+GetWhere("=",dFecha))
    ENDIF

    // Obtiene el Valor del Peso Según el Dólar
    EJECUTAR("PUTBCVCOP",cMoneda,oDp:dFecha,nDivide,nDec,nValCam)

    oDp:nValCop  :=nDivide
    oErp:dFecha  :=oDp:dFecha // Fecha
    oErp:nMonto  :=SQLGET("DPHISMON","HMN_VALOR","HMN_CODIGO"+GetWhere("=",cMoneda)+" AND HMN_FECHA"+GetWhere("=",oDp:dFecha))
    oErp:cPicture:="999.99999" 
    oErp:nColor  :=1          // Color a Mostrar
    oErp:cDescri :="Peso Colombiando COP según BCV("+FDP(nValCam,oDp:cPictureDivisa,NIL,.T.)+")/"+LSTR(nDivide)+CRLF+"Valor "+LSTR(oErp:nMonto,19,8)+" Mutiplica "+LSTR( oDp:nValCop)+"*USD$"
    oErp:lPanel  :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
