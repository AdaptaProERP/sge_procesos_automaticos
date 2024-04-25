// Proceso RESDPCBTEPAGO           
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
   LOCAL dDesde:=FCHINIMES(oDp:dFecha)
   LOCAL dHasta:=FCHFINMES(oDp:dFecha),nMonto:=0,cWhere

   cWhere:="PAG_CODSUC"+GetWhere("=",oDp:cSucursal)+" AND "+;
           "PAG_ACT=1 AND "+;
           GetWhereAnd("PAG_FECHA",dDesde,dHasta)

   nMonto:=SQLGET("DPCBTEPAGO","SUM(PAG_MONTO),SUM(PAG_MTOIVA)",cWhere)

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=nMonto     // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar
   oErp:cDescri:="Resumen "+oDp:DPCBTEPAGO+" "+DTOC(dDesde)+" - "+DTOC(dHasta)  // Descripción
   oErp:lPanel :=.T.        // Publicar en el Panel

   IF !oDp:lPanel
     EJECUTAR("DPCBTEPAGOXPRO",NIL,NIL,dDesde,dHasta)
   ENDIF

RETURN .T.
// EOF
