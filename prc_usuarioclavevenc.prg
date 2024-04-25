// Proceso USUARIOCLAVEVENC    
#INCLUDE "DPXBASE.CH"

PROCE MAIN(uPar)
   LOCAL nDias :=30
   LOCAL dFecha:=DPFECHA()-nDias

   IF COUNT("DPUSUARIOS","OPE_NUMERO"+GetWhere("= ",oDp:cUsuario)+" AND "+;
                         "OPE_FCHACT"+GetWhere(">=",dFecha))>0 
      MensajeErr("la Clave de Acceso ha concluido, es necesaria una nueva Clave")
      EJECUTAR("DPCAMBIOUS",.T.)
   ENDIF

RETURN .T.
// EOF
