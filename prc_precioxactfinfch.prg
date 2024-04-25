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
    LOCAL cSql,oTable,nTotal
    LOCAL cWhere,cCodSuc:=oDp:cSucursal,nPeriodo:=11,dDesde:=CTOD(""),dHasta:=CTOD(""),cTitle:=NIL

    IF !oDp:lPanel
       cWhere:=" PRE_FECHA IS NULL"
       EJECUTAR("BRPRECIOSFCH",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
       RETURN .F.
    ENDIF

    cSql:=" SELECT MIN(PRE_FECHA) AS PRE_FCHMIN,DATEDIFF(NOW(),MIN(PRE_FECHA)) AS PRE_DIFMIN, "+;
          " MAX(PRE_FECHA) AS PRE_FCHMAX,DATEDIFF(NOW(),MAX(PRE_FECHA)) AS PRE_DIFMAX, COUNT(*) AS CANT "+;
          " FROM DPPRECIOS "+;
          " WHERE PRE_FECHA IS NULL "

    oTable:=OpenTable(cSql,.T.)
    oTable:End()
  
    nTotal:=COUNT("DPPRECIOS")
    oErp:dFecha :=oDp:dFecha // Fecha
    oErp:nMonto :=0          // Monto a Publicar

    IF oTable:RecCount()>0
      oErp:nColor :=2          // Color a Mostrar
      oErp:cDescri:=LTRAN(oTable:CANT)+" de "+LTRAN(nTotal)+" "+LTRAN(RATA(oTable:CANT,nTotal))+"% Lista de Precios sin Fecha de Registro"
    ELSE
      oErp:nColor :=1          // Color a Mostrar
      oErp:cDescri:="Todos las listas de Precios con Fecha de Actualización"
    ENDIF

    oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
