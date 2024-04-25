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

       EJECUTAR("MYSQLVERSION")

       oErp:dFecha :=oDp:dFecha // Fecha
       oErp:nMonto :=0          // Monto a Publicar
       oErp:nColor :=1          // Color a Mostrar
       oErp:cDescri:="Version de MySQL "+oDp:cMySQLVersion
       oErp:lPanel :=.T.        // Publicar en el Panel


RETURN .T.
// EOF
