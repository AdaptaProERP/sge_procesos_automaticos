// Proceso PANELERPAUTOGRABAR  
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
       oErp:nColor :=3          // Color a Mostrar
       oErp:cDescri:="Contenido del Panel ERP ha sido Almacenado"         // Descripción
       oErp:lPanel :=.T.        // Publicar en el Panel

       oDp:lPanelErpSave:=.T.

RETURN .T.
// EOF
