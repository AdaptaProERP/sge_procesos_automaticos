// Proceso CBLAPLPENALIZACION  
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL cCodInv,cWhere:=NIL,cTipDoc:="CUO",dFecha:=oDp:dFecha,nCant

   EJECUTAR("CLBLOAD")

   IF Empty(oDp:dFchIniCLB)

      oErp:dFecha :=oDp:dFecha // Fecha
      oErp:nMonto :=0          // Monto a Publicar
      oErp:nColor :=1          // Color a Mostrar
      oErp:cDescri:="Requiere Definición de Fecha de Inicio para Generar Cuotas"
      oErp:lPanel :=.T.        // Publicar en el Panel

    EJECUTAR("CLBCONFIG")
    RETURN .T.

  ENDIF

    IF !oDp:lPanel

     EJECUTAR("BRDPDOCCLICXC",cWhere,oDp:cSucursal,oDp:nMensual,FCHINIMES(dFecha),FCHFINMES(dFecha),NIL,cTipDoc)
     RETURN NIL

   ENDIF

  IF oDp:dFecha<oDp:dFchIniCLB


      oErp:dFecha :=oDp:dFecha // Fecha
      oErp:nMonto :=0          // Monto a Publicar
      oErp:nColor :=1          // Color a Mostrar
      oErp:cDescri:="Cuotas Seran Generadas Automáticamente a partir del  "+DTOC(oDp:dFchIniCLB)
      oErp:lPanel :=.T.        // Publicar en el Panel

    RETURN .T.

  ENDIF

   cWhere:=[ INNER JOIN DPINV             ON DPG_CODINV=INV_CODIGO  ]+;
           [ LEFT  JOIN VIEW_DPINVPRECIOS ON DPINV.INV_CODIGO=PRE_CODIGO  ]+;
           [ WHERE PRE_UNDMED="MENSUAL" AND DPG_TIPDES='CUO' AND INV_UTILIZ='Afiliación'  ]+;
           [ GROUP BY DPG_CODINV ]

    cCodInv:=ALLTRIM(SQLGET("DPCLIENTEPROG","DPG_CODINV",cWhere))

    EJECUTAR("CLBGENCUOAUTO")

    cWhere:="MOV_CODSUC"+GetWhere("=",oDp:cSucursal)+" AND MOV_TIPDOC"+GetWhere("=",cTipDoc)+;
            " AND YEAR(MOV_FECHA) "+GetWhere("=",YEAR(dFecha))+;
            " AND MONTH(MOV_FECHA)"+GetWhere("=",MONTH(dFecha))+" AND MOV_INVACT=1"

    nCant :=COUNT("DPMOVINV",cWhere)

     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=0          // Monto a Publicar
     oErp:nColor :=1          // Color a Mostrar
     oErp:cDescri:="Código:"+cCodInv+" ("+LSTR(nCant)+") Cuotas Generadas, Año="+LSTR(YEAR(dFecha))+" Mes="+CMES(dFecha)
     oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
