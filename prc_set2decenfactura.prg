// Proceso SET4DECENFACTURA    
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
        EJECUTAR("DPFACTURAV","FAV")
        RETURN .F.
     ENDIF
 
     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{2,[999,999,999.99]},[CAM_NAME="MOV_CANTID"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[999,999,999.99],[CTD_FIELD="MOV_CANTID"])
     EJECUTAR("DPLOADPICTURE")
     oDp:cPictCanUnd:=FIELDPICTURE("DPMOVINV" ,"MOV_CANTID" ,.T.)
     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=0          // Monto a Publicar
     oErp:nColor :=1          // Color a Mostrar
     oErp:cDescri:="Activado Dos(2) Decimales para Cant. en Facturación y Compras"+CRLF+"Formato " +oDp:cPictCanUnd
     oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF

u
