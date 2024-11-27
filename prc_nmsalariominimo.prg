// Proceso NMSALARIOMINIMO     
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
       LOCAL cMinimo:=SQLGET("NMCONSTANTES","CNS_VALOR,CNS_FECHA","CNS_CODIGO"+GetWhere("=","026"))
       LOCAL dFecha :=DPSQLROW(2)

       IF !oDp:lPanel 
          EJECUTAR("NMCONSTANTES",IF(Empty(cMinimo),1,3),"026")
          RETURN .F.
       ENDIF

       // nMinimo:=CTOO(nMinimo,"N")

       oErp:dFecha :=oDp:dFecha // Fecha
       oErp:nMonto :=0          // Monto a Publicar
       oErp:nColor :=1          // Color a Mostrar
       oErp:cDescri:=ALLTRIM(cMinimo)+" BsD"+" Salario Mínimo Urbano en Constante (26)"+CRLF+"Registrado el "+DTOC(dFecha)
       oErp:lPanel :=.T.        // Publicar en el Panel



RETURN .T.
// EOF
