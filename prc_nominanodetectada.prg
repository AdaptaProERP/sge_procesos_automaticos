// Proceso NOMINANODETECTADA   
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
  LOCAL cData

  DEFAULT oDp:lNomina:=.F.

  IF !oDp:lNomina .AND. !oDp:lPanel .AND. MsgYesNo("Desea Activar N�mina","Seleccione Activar")

    SQLUPDATE("DPPROCESOS","PRC_ACTIVO",1,"PRC_CODIGO"+GetWhere("=","NOMINA"))

    oDp:lNomina:=.T.

    // Refrescar ERP
    EJECUTAR("DPRUNPROCAUTO",NIL,NIL,.T.)
    RETURN NIL

  ENDIF

  IF !oDp:lNomina

//     RETURN {"N�mina no Detectada",0,4}

     cData:="N�mina no Detectada"

     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=0          // Monto a Publicar
     oErp:nColor :=4          // Color a Mostrar
     oErp:cDescri:=cData      // Descripci�n
     oErp:lPanel :=.T.        // Publicar en el Panel

  ENDIF


RETURN .T.
// EOF
