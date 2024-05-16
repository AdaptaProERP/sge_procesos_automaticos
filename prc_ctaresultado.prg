// Proceso CTARESULTADO        
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
  LOCAL cCtaUtil:=SQLGET("DPCTAUSO","CUT_CODIGO","CUT_CTAMOD"+GetWhere("=",oDp:cCtaMod)+" AND "+;
                                                 "CUT_CODUSO"+GetWhere("=","U4"))
  LOCAL cDescri:=""

  IF !oDp:lPanel
    EJECUTAR("DPCTAUSO")
    RETURN .T.
  ENDIF
 
  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=2          // Color a Mostrar
  oErp:cDescri:="Cuenta de Resultado del Ejercicio"+CRLF+"No esta Registrada en el Plan de Cuentas "     
  oErp:lPanel :=.T.        // Publicar en el Panel

  IF !Empty(cCtaUtil)

    cDescri:=ALLTRIM(SQLGET("DPCTA","CTA_DESCRI","CTA_CODIGO"+GetWhere("=",cCtaUtil)))
    cDescri:=IF(Empty(cDescri),"Cuenta no Existe",cDescri)

    IF Empty(cDescri)
      oErp:nColor :=2     
    ENDIF
  
    cDescri:=IF(Empty(cDescri)," Cuenta de Resultado",cDescri)

    oErp:nMonto :=0          // Monto a Publicar     oErp:nColor :=3          // Color a Mostrar
    oErp:cDescri:=cCtaUtil+" "+cDescri

  ENDIF

RETURN .T.
// EOF
