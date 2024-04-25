// Proceso RESUMENCXC          
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
  LOCAL aData:={},nNeto:=0,nVence:=0,cData:=""

  aData:=EJECUTAR("DPDOCCXCRES",NIL,NIL , oDp:lPanel , .F. ) 

  cData:="Resumen de Cuentas por Cobrar (CxC)"

  IF ValType(aData)="A"

      AEVAL(aData,{ |a,n| nNeto :=nNeto+ a[3] ,;
                          nVence:=nVence+a[5] })  

      cData:="Resumen de Cuentas por Cobrar "+CRLF+;
             "Monto:  "+TRAN(nNeto ,"999,999,999,999,999.99")+CRLF+;
             "Vencido:"+TRAN(nVence,"999,999,999,999,999.99")+CRLF+;
             "Clientes:"+LSTR(LEN(aData))

  ENDIF

  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=nNeto      // Monto a Publicar
  oErp:nColor :=2          // Color a Mostrar
  oErp:cDescri:=cData      // Descripción
  oErp:lPanel :=.T.        // Publicar en el Panel
  oErp:cPicture:="999,999,999,999,999.99"

RETURN NIL 
// {cData,nNeto}
// EOF
