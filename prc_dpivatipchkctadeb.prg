// Proceso DPIVATIPCHKCTACRE   
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
      LOCAL nMonto:=0,cSql,nCant,cWhere:=[ TIP_ACTIVO=1 AND (CTA_CODIGO IS NULL OR CTA_CODIGO="" OR CTA_CODIGO]+GetWhere("=",oDp:cCtaIndef)+[)]
      LOCAL aCuentas:={},cTitle

      IF !oDp:lPanel

         aCuentas:=ATABLE([ SELECT TIP_CTADEB FROM DPIVATIP LEFT JOIN dpcta ON TIP_CTADEB=CTA_CODIGO WHERE ]+cWhere)
         cWhere  :=GetWhereOr("TIP_CTADEB",aCuentas)
         
         cWhere  :=cWhere+IF(Empty(cWhere),""," AND ")+[(TIP_ACTIVO=1 OR (TIP_CTADEB IS NULL OR TIP_CTADEB="" OR TIP_CTADEB]+GetWhere("=",oDp:cCtaIndef)+[))]
         cTitle  :=oDp:DPIVATIP+[ sin Vinculo Contable ]
 
         DPLBX("DPIVATIP.LBX",cTitle,cWhere)

         RETURN .F.
      ENDIF

      nMonto      :=COUNT("DPIVATIP",[LEFT JOIN dpcta ON TIP_CTADEB=CTA_CODIGO WHERE ]+cWhere)
      nCant       :=COUNT("DPIVATIP",[TIP_ACTIVO=1])
  
      oErp:dFecha :=oDp:dFecha // Fecha
      oErp:nMonto :=nMonto   // Monto a Publicar
      oErp:nColor :=IF(nMonto>0,4,3)          // Color a Mostrar

      IF nMonto=0
         oErp:cDescri:="Todas "+LSTR(nCant)+"  de Cuentas Cuentas Contables tienen Vinculo Contable"+CRLF+"con la Columna Ventas en Alícuotas de IVA"
      ELSE
         oErp:cDescri:="Cantidad "+LSTR(nMonto)+"/"+LSTR(nCant)+" ("+LSTR(RATA(nMonto,nCant))+"%) de Cuentas Contables Sin Integración"+CRLF+"Columna [IVA VENTAS] en la Tabla "+oDp:DPIVATIP
      ENDIF

      oErp:cSPEAK:="AQUI"

      oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
