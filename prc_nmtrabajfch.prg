// Proceso NMTRABAJFCH         
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
       oErp:nColor :=2          // Color a Mostrar
       oErp:cDescri:="Fechas de los Trabajadores        "         // Descripción
       oErp:lPanel :=.T.        // Publicar en el Panel

       EJECUTAR("NMTRABAJFCH")

RETURN .T.
// EOF
