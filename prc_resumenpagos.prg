// Proceso RESUMENPAGOS        
#INCLUDE "DPXBASE.CH"

PROCE MAIN(uPar)

  LOCAL nMonto,cData:={}

  nMonto:=EJECUTAR("DPPAGOSPRORES" , NIL , NIL , NIL , NIL ,  oDp:lPanel ) 

  IF ValType(nMonto)="N"

      cData:="Resumen de Pagos, Mes: "+CMES(oDp:dFecha)+CRLF+;
             "Monto: "+TRAN(nMonto ,"999,999,999,999.99")+CRLF

  ENDIF

  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=nMonto     // Monto a Publicar
  oErp:nColor :=1          // Color a Mostrar
  oErp:cDescri:=cData      // Descripción
  oErp:lPanel :=.T.        // Publicar en el Panel


RETURN NIL
// EOF {cData,nMonto}
// EOF
