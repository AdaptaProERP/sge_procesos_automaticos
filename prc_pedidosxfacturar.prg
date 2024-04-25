// Proceso PEDIDOSXFACTURAR    
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
 LOCAL nCant:=0
 LOCAL nCantPend :=0
 LOCAL nMontoPend:=0
 LOCAL dFchMin   :=CTOD("")
 LOCAL dFchMax   :=CTOD("")

 IF !oDp:lPanel

   EJECUTAR("BRPEDXFACT")
   RETURN NIL

 ENDIF

 nCant:=SQLGET("VIEW_PEDIDOSXFACTURAR","COUNT(*),SUM(PED_PENDTE),SUM(PED_TOTEXP),MIN(PED_FCHVEN),MAX(PED_FCHVEN)")

 IF !Empty(oDp:aRow)
    nCantPend :=oDp:aRow[2]
    nMontoPend:=oDp:aRow[3]
    dFchMin   :=oDp:aRow[4]
    dFchMax   :=oDp:aRow[5]
 ENDIF
 
 oErp:dFecha :=oDp:dFecha  // Fecha
 oErp:nMonto :=nCant       // Monto a Publicar
 oErp:nColor :=1           // Color a Mostrar
 oErp:cDescri:=LSTR(nCant)+" Pedido(s) por Facturar"+CRLF+;
               "Unidades "+LSTR(nCantPend)+"  Monto:"+TRAN(nMontoPend,"999,999,999.99")+" "+;
               "Desde : "+DTOC(dFchMin)+" Hasta "+DTOC(dFchMax)
 oErp:lPanel :=.T.        // Publicar en el Panel


RETURN .T.
// EOF
