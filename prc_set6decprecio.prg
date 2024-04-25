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
  
  IF oTable:FieldDec("MOV_PRECIO")<6
     SQLUPDATE([DPCAMPOS],{[CAM_DEC]    ,[CAM_FORMAT]},{6,[9,999,999.999999]},[CAM_NAME="MOV_PRECIO"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[9,999,999.999999],[CTD_FIELD="MOV_PRECIO"])
     SQLUPDATE([DPTIPDOCCLICOL],[CTD_PICTUR] ,[9,999,999],[CTD_FIELD="MOV_CANTID"])
     EJECUTAR("DPLOADPICTURE")
     Checktable("DPMOVINV")
     oDp:cPictPrecio:=FIELDPICTURE("DPMOVINV" ,"MOV_PRECIO" ,.T.)
  ENDIF

  oTable:End()

  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=1          // Color a Mostrar
  oErp:cDescri:="Documentos del Cliente [Facturación]"+CRLF+;
                 LSTR(oTable:FieldDec("MOV_PRECIO"))+" Decimales en Precio"  +CRLF+;
                 "0 Decimales en Cantidad"
  oErp:lPanel :=.T.

RETURN .T.
// EOF
