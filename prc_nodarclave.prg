// Proceso NODARCLAVE          
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL nCant:=EJECUTAR("NODARCLAVE",.F.)


    oErp:dFecha :=oDp:dFecha // Fecha
    oErp:nMonto :=nCant          // Monto a Publicar
    oErp:nColor :=1          // Color a Mostrar
    oErp:cDescri:=LSTR(nCant)+" Clientes con NO DAR CLAVES"         // Descripción
    oErp:lPanel :=.T.        // Publicar en el Panel



RETURN .T.
// EOF
