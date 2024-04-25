// Proceso NMTRABAJADOR3M      
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
 LOCAL nCantid:=0,cData:="",cWhere:="",dFecha:=oDp:dFecha,nCant30:=0,aData:={}
 LOCAL I,nDias:=0,cWhere

 DEFAULT oDp:lNomina:=.F.

 IF !oDp:lNomina
    RETURN NIL
 ENDIF

 EJECUTAR("TABLASNOMINA")

 // Determina, si hay trabajadores con menos de un mes remanente en el periodo de prueba
 dFecha:=(dFecha-29)
 cWhere:="FECHA_ING"+GetWhere(">=",dFecha)+" AND CONDICION"+GetWhere("=","A")

 aData:=ASQL("SELECT FECHA_ING FROM NMTRABAJADOR WHERE "+cWhere)

 FOR I=1 TO LEN(aData) 

    dFecha:=aData[I,1]+29
    nDias :=dFecha-oDp:dFecha

    IF nDias<=30
      nCant30++
    ENDIF

 NEXT I

 dFecha :=oDp:dFecha-29
 nCantid:=LEN(aData)

 cData  :=LSTR(nCantid)+", Trabajador(es) en Periodo de Prueba "+CRLF+;
          LSTR(nCant30)+", Trabajador(es) Concluyen en Menos de 30 Días"

 oErp:dFecha :=oDp:dFecha // Fecha
 oErp:nMonto :=0          // Monto a Publicar
 oErp:nColor :=1          // Color a Mostrar
 oErp:cDescri:=cData      // Descripción
 oErp:lPanel :=.T.        // Publicar en el Panel

 IF nCant30>0
   oErp:nColor:=2
 ENDIF

 IF !oDp:lPanel .AND. !(nCant30>0)
// EJECUTAR("NMTRABJ3MESES",NIL,.T.)
 ENDIF

RETURN NIL
// {LSTR(nCantid)+", Trabajador(es) en Periodo de Prueba",nCantid,CLR_BLUE}
// EOF
