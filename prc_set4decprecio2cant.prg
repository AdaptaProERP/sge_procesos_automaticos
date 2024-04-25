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
     LOCAL oTable

     oTable:=OpenTable("SELECT MOV_CANTID,MOV_PRECIO FROM DPMOVINV LIMIT 0",.T.)

     IF !oDp:lPanel
        EJECUTAR("DPFACTURAV","FAV")
        RETURN .F.
     ENDIF

     // Cantidad con 2 Decimales en Cantidad
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[9,999,999.99],[CTD_FIELD="MOV_CANTID"])
     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{4,[9,999,999.99]},[CAM_NAME="MOV_CANTID"])
     EJECUTAR("DPLOADPICTURE")
   

     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{2,[999,999,999.99]},[CAM_NAME="MOV_CANTID"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[999,999,999.99],[CTD_FIELD="MOV_CANTID"])
     EJECUTAR("DPLOADPICTURE")
     oDp:cPictCanUnd:=FIELDPICTURE("DPMOVINV" ,"MOV_CANTID" ,.T.)

     // 4 Decimales en Precios
     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{4,[9,999,999.9999]},[CAM_NAME="MOV_PRECIO"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[9,999,999.9999],[CTD_FIELD="MOV_PRECIO"])

     IF oTable:FieldDec("MOV_PRECIO")<4
       Checktable("DPMOVINV")
     ENDIF

     oDp:cPictPrecio:=FIELDPICTURE("DPMOVINV" ,"MOV_PRECIO" ,.T.)
     oDp:cPictCanUnd:=FIELDPICTURE("DPMOVINV" ,"MOV_CANTID" ,.T.)

     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=0          // Monto a Publicar
     oErp:nColor :=1          // Color a Mostrar
     oErp:cDescri:="Activado Dos(2) Decimales para Cant. (4) en Precios para Facturación y Compras"+CRLF+"Formato " +oDp:cPictCanUnd
     oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
