// Proceso DOCPROCTA_ATVXREG   
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL cWhere:=NIL,nTotal,nCantid
    LOCAL oDb:=OpenOdbc(oDp:cDsnData)

    IF !oDp:lPanel 
       EJECUTAR("BRATVCXP",cWhere)
       RETURN NIL
    ENDIF

   oDb:EXECUTE([UPDATE DPDOCPRO SET DOC_FCHDEC=DOC_FECHA WHERE DOC_FCHDEC]+GetWhere("=",CTOD(""))+[ AND DOC_TIPTRA="D"])

   
    cWhere:=[ INNER JOIN DPPROVEEDOR ON DOC_CODIGO=PRO_CODIGO ]+;
            [ INNER JOIN DPDOCPROCTA ON CCD_CODSUC=DOC_CODSUC AND CCD_TIPDOC=DOC_TIPDOC AND CCD_CODIGO=DOC_CODIGO AND CCD_NUMERO=DOC_NUMERO AND CCD_TIPTRA=DOC_TIPTRA AND CCD_ACT=1 ]+;
            [ INNER JOIN DPCTA       ON CCD_CTAMOD=CTA_CODMOD AND CCD_CODCTA=CTA_CODIGO AND CTA_PROPIE="Planta y Equipos" ]+;
            [ LEFT JOIN dpactivos    ON ATV_CODSUC=CCD_CODSUC AND ATV_TIPDOC=CCD_TIPDOC AND ATV_CODPRO=CCD_CODIGO AND ATV_NUMDOC=CCD_NUMERO AND ATV_ITEM  =CCD_ITEM ]+;
            [ WHERE DOC_ACT=1 ]

     nTotal:=COUNT("DPDOCPRO",cWhere)

     nCantid:=COUNT("DPDOCPRO",cWhere+" AND ATV_CODSUC IS NULL")

     oErp:dFecha :=oDp:dFecha // Fecha
     oErp:nMonto :=nTotal     // Monto a Publicar
     oErp:nColor :=1          // Color a Mostrar
     oErp:nColor :=IF(nTotal=nCantid .AND. nTotal>0,4,oErp:nColor)
     oErp:nColor :=IF(nTotal>nCantid .AND. nTotal>0,2,oErp:nColor)
     oErp:cDescri:="Cuentas Contables "+LSTR(nCantid)+"/"+LSTR(nTotal)+" ("+LSTR(RATA(nCantid,nTotal))+"%) Activos sin Registrar Comprados desde CxP"
     oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
