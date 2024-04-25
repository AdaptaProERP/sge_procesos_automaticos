// Proceso PEDIDOSPENDIENTES   
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
  LOCAL cSql,aPedidos

  cSql:="SELECT MOV_DOCUME,MOV_FECHA,SUM(MOV_TOTAL) AS MOV_BRUTO,"+;
         "SUM(MOV_CANTID) AS CANTID,SUM(MOV_EXPORT) AS EXPORT "+;
         "FROM DPMOVINV "+;
         "WHERE MOV_TIPDOC='PED' "+;
         "GROUP BY  MOV_DOCUME,MOV_FECHA "+;
         "HAVING SUM(MOV_CANTID-MOV_EXPORT)>0 "

   aPedidos:=ASQL(cSql)

   ViewArray(aPedidos)

RETURN .T.
// EOF
