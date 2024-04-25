// Proceso RESPALDO            
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)

   LOCAL oForm

   EJECUTAR("MYSQLBACKUP")

   IF TYPE("oMySqlB")="O"
     oMySqlB:lAutoClose:=.T.
     Eval(oMySqlB:oBtnRun:bAction)
   ENDIF

RETURN .T.
// EOF
