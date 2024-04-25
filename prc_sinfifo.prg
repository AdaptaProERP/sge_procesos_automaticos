// Proceso SINFIFO             
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
   LOCAL nCant:=EJECUTAR("SINFIFO",NIL,!oDp:lPanel)

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=nCant      // Monto a Publicar
   oErp:nColor :=IF(nCant>0,2,1)  // Color a Mostrar
   oErp:cDescri:="("+LSTR(nCant)+") Productos que Requiere Método de Costo FIFO"         // Descripción
   oErp:lPanel :=.T.        // Publicar en el Panel



RETURN .T.
// EOF
