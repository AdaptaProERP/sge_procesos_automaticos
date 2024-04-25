// Proceso RECTRIBSINREGFORMAL 
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
  LOCAL cWhere:=GetWhereOr("PRO_RIF",ASQL("SELECT ENT_RIF FROM DPENTESPUB WHERE ENT_REGFOR=1"))
  LOCAL nCant :=0

  IF Empty(cWhere)
     RETURN .F.
  ENDIF

  cWhere:="LEFT(PRO_SITUAC,1)='A' AND PRO_TIPO='Receptor Tributario'"+;
          "  AND PRO_NIT=''  AND "+cWhere

  nCant :=COUNT("DPPROVEEDOR",cWhere)

  IF !oDp:lPanel 
   EJECUTAR("BRRECTRIBSINREG")
   RETURN .F.
  ENDIF

  oErp:dFecha :=oDp:dFecha // Fecha
  oErp:nMonto :=0          // Monto a Publicar
  oErp:nColor :=IF(nCant>1,4,1)          // Color a Mostrar
  oErp:cDescri:=LSTR(nCant)+" Receptor(es) Tributario(s) sin Registro Formal "
  oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
