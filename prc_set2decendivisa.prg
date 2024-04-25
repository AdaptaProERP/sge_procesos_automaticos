// Proceso SET2DECENDIVISA     
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)

     IF !oDp:lPanel
        EJECUTAR("BRACTHISMON")
        RETURN .F.
     ENDIF

     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{4,[999,999,999.99]},[CAM_NAME="HMN_VALOR"])
     oDp:cPictValCam:=ALLTRIM(SQLGET("DPCAMPOS","CAM_FORMAT","CAM_TABLE"+GetWhere("=","DPHISMON")+" AND CAM_NAME"+GetWhere("=","HMN_VALOR")))

     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=0          // Monto a Publicar
     oErp:nColor :=1          // Color a Mostrar
     oErp:cDescri:="Activado Dos(2) Decimales para Divisas (Dolar)"+CRLF+"Formato " +oDp:cPictValCam
     oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF

u

