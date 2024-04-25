// Proceso MYSQLVERSION        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
     LOCAL cName :="query_cache_size"
     LOCAL uValue:=EJECUTAR("MYSQLQUERYCACHE",cName)

     IF !oDp:lPanel
       EJECUTAR("MYSQLVAROPTIMIZ")
       RETURN .F.
     ENDIF 
     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=0          // Monto a Publicar
     oErp:nColor :=1          // Color a Mostrar

     IF Empty(uValue)
       oErp:cDescri:="Versión de MySQL "+oDp:cMySQLVersion+" Optimización Recomendada"
     ELSE
       oErp:cDescri:="Versión de MySQL "+oDp:cMySQLVersion+" "+cName+"="+CTOO(uValue,"C")
     ENDIF

     oErp:lPanel :=.T.        // Publicar en el Panel


RETURN .T.
// EOF
