// Proceso FACTURASET4DEC      
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
  
  IF oTable:FieldDec("MOV_PRECIO")<4
     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{4,[9,999,999.9999]},[CAM_NAME="MOV_PRECIO"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[9,999,999.9999],[CTD_FIELD="MOV_PRECIO"])
     EJECUTAR("DPLOADPICTURE")
     Checktable("DPMOVINV")
     oDp:cPictPrecio:=FIELDPICTURE("DPMOVINV" ,"MOV_PRECIO" ,.T.)
  ENDIF

  IF oTable:FieldDec("MOV_CANTID")<4
     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{4,[9,999,999.9999]},[CAM_NAME="MOV_CANTID"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[9,999,999.9999],[CTD_FIELD="MOV_CANTID"])
     Checktable("DPMOVINV")
     EJECUTAR("DPLOADPICTURE")
     oDp:cPictCanUnd:=FIELDPICTURE("DPMOVINV" ,"MOV_CANTID" ,.T.)
  ENDIF   

  oTable:End()

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=0          // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar
   oErp:cDescri:="Documentos del Cliente [Facturación]"+CRLF+;
                 LSTR(oTable:FieldDec("MOV_PRECIO"))+" Decimales en Precio"  +CRLF+;
                 LSTR(oTable:FieldDec("MOV_CANTID"))+" Decimales en Cantidad"
   oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
