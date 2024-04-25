// Proceso RESBCODEBCRE        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
  LOCAL cCodSuc:=oDp:cSucursal,nPeriodo:=4,dDesde:=FCHININMES(oDp:dFecha),dHasta:=FCHFINMES(oDp:dFecha)
  LOCAL lData :=oDp:lPanel 
  LOCAL aTotal:={}

  aData :=EJECUTAR("DPRESTIPBANCOS",cCodSuc,nPeriodo,dDesde,dHasta,lData)
  aTotal:=ATOTALES(aData)


  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=TRAN(aTotal[3]-aTotal[4],"999,999,999,999.99")      // Monto a Publicar
  oErp:nColor :=1          // Color a Mostrar
  oErp:cDescri:="Resumen Debitos Creditos Todos los Bancos"         // Descripción
  oErp:lPanel :=.T.        // Publicar en el Panel



RETURN .T.
// EOF
