// Proceso RECOMPILADPXBASE    
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)

    LOCAL oData:=DATACONFIG("DPXBASE","ALL")

    // Ultima Fecha de Programación DpXbase General
    oDp:cDpXbaseAct:=oData:Get("DPXBASE",oDp:cDpXbaseAct)
    oData:End(.F.)

    // Compara con la Ultima Fecha de Compilacion Local
    oData:=DATACONFIG("DPXBASE","USER")

    oDp:cDpXbaseUs:=oData:Get("DPXBASE",DTOC(oDp:dFecha)+" / "+TIME())
    oData:End(.F.)

    IF Empty(oDp:cDpXbaseUs) .OR. oDp:cDpXbaseAct<>oDp:cDpXbaseUs
       EJECUTAR("DPXBASERECOMP",oDp:cDpXbaseAct,oDp:cDpXbaseUs)
    ENDIF

RETURN .T.
// EOF
