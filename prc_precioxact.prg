// Proceso PRECIOXACT          
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL cSql,oTable
    LOCAL cWhere,cCodSuc:=oDp:cSucursal,nPeriodo:=11,dDesde:=CTOD(""),dHasta:=CTOD(""),cTitle:=NIL
    LOCAL nTotal

    IF !oDp:lPanel
       EJECUTAR("BRPRECIOSFCH",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
       RETURN .F.
    ENDIF

    cSql:=" SELECT MIN(PRE_FECHA) AS PRE_FCHMIN,DATEDIFF(NOW(),MIN(PRE_FECHA)) AS PRE_DIFMIN, "+;
          " MAX(PRE_FECHA) AS PRE_FCHMAX,DATEDIFF(NOW(),MAX(PRE_FECHA)) AS PRE_DIFMAX, COUNT(*) AS CANT "+;
          " FROM DPPRECIOS "+;
          " WHERE PRE_FECHA IS NOT NULL "

    oTable:=OpenTable(cSql,.T.)
    oTable:End()

    nTotal:=COUNT("DPPRECIOS")
  
    oErp:dFecha :=oDp:dFecha // Fecha
    oErp:nMonto :=0          // Monto a Publicar
    oErp:nColor :=1          // Color a Mostrar

    IF oTable:PRE_DIFMAX>0

      oErp:nColor :=2          // Color a Mostrar
      oErp:cDescri:=LTRAN(oTable:CANT)+" de "+LTRAN(nTotal)+" ("+LTRAN(RATA(oTable:CANT,nTotal))+"%) Lista de Precios por Actualizar Desde "+DTOC(oTable:PRE_FCHMIN)+" Hasta "+DTOC(oTable:PRE_FCHMAX)+CRLF+;
                    "Antigüedad por Actualizar desde "+LTRAN(oTable:PRE_DIFMAX)+" Hasta "+LTRAN(oTable:PRE_DIFMIN)+" Días"

      IF oTable:PRE_DIFMAX=oTable:PRE_DIFMIN

       oErp:cDescri:=LTRAN(oTable:CANT)+" de "+LTRAN(nTotal)+" ("+LTRAN(RATA(oTable:CANT,nTotal))+"%) Lista de Precios por Actualizar Desde "+DTOC(oTable:PRE_FCHMIN)+" Hasta "+DTOC(oTable:PRE_FCHMAX)+CRLF+;
                     "Antigüedad por Actualizar desde "+LTRAN(oTable:PRE_DIFMIN)+" Día"+IF(oTable:PRE_DIFMIN>1,"s","")

      ENDIF

      IF Empty(oTable:PRE_FCHMIN)

        oErp:cDescri:=LTRAN(oTable:CANT)+" de "+LTRAN(nTotal)+" ("+LTRAN(RATA(oTable:CANT,nTotal))+"%) Lista de Precios por Actualizar Desde "+DTOC(oTable:PRE_FCHMIN)+" Hasta "+DTOC(oTable:PRE_FCHMAX)+CRLF+;
                      "Antigüedad por Actualizar desde "+LTRAN(oTable:PRE_DIFMAX)+" Hasta "+LTRAN(oTable:PRE_DIFMIN)+" Días"


      ENDIF

    ELSE

      oErp:nColor :=3  
      oErp:cDescri:=LTRAN(oTable:CANT)+" de "+LTRAN(nTotal)+" ("+LTRAN(RATA(oTable:CANT,nTotal))+"%) Lista de Precios Actualizados Desde "+DTOC(oTable:PRE_FCHMIN)+" Hasta "+DTOC(oTable:PRE_FCHMAX)

    ENDIF

    oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
