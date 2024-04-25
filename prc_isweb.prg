// Proceso ISSENIAT            
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
       LOCAL cIp:="",lOk


       oErp:dFecha :=oDp:dFecha // Fecha
       oErp:nMonto :=0          // Monto a Publicar
       oErp:nColor :=1          // Color a Mostrar
       oErp:cDescri:="No tiene Página Web"
       oErp:lPanel :=.T.        // Publicar en el Panel

       IF Empty(oDp:cWeb)
          RETURN .T.
       ENDIF

       cIp:=GETHOSTBYNAME(ALLTRIM(oDp:cWeb))

       lOk:=!("0.0.0.0"$cIp)

       IF !lOk 
         oErp:cDescri:=ALLTRIM(oDp:cWeb)+" No está Disponible"
         oErp:nColor :=4         // Color a Mostrar
       ELSE
         oErp:nColor :=3          // Color a Mostrar
         oErp:cDescri:=ALLTRIM(oDp:cWeb)+" Disponible, IP:"+ cIp
       ENDIF

       
RETURN .T.
// EOF
