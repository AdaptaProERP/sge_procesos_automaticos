// Proceso CBLAPLPENALIZACION  
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)

       oErp:dFecha :=oDp:dFecha // Fecha
       oErp:nMonto :=0          // Monto a Publicar
       oErp:nColor :=1          // Color a Mostrar
       oErp:cDescri:="Aplicaci�n de Penalizaci�n de Cuotas"         // Descripci�n
       oErp:lPanel :=.T.        // Publicar en el Panel

       EJECUTAR("CLBAPLPENALIZA")

RETURN .T.
// EOF
