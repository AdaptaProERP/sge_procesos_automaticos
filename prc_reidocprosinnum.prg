// Proceso REIDOCPROSINNUM     
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
   LOCAL nCantid,cWhere
   LOCAL cCodSuc,nPeriodo,dDesde,dHasta,cTitle

   IF !oDp:lPanel
       EJECUTAR("BRREIDOCSINNUM",cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
       RETURN .T.
   ENDIF
    
   cWhere:=" INNER JOIN DPTIPDOCPRO ON CCD_DOCTIP=TDC_TIPO AND TDC_LIBCOM=1 "+;
           " INNER JOIN DPPROVEEDOR ON CCD_CODIGO=PRO_CODIGO  "+;
           " WHERE CCD_CODSUC"+GetWhere("=",oDp:cSucursal)+;
           " AND CCD_TIPDOC='REI' "+;
           " AND (CCD_FACTUR='' OR CCD_NUMFIS='' OR CCD_RIF='') AND CCD_ACT=1 "

   nCantid:=COUNT("DPDOCPROCTA",cWhere)

   oErp:dFecha :=oDp:dFecha        // Fecha
   oErp:nMonto :=nCantid           // Monto a Publicar
   oErp:nColor :=IF(nCantid>1,4,1) // Color a Mostrar
   oErp:cDescri:=LSTR(nCantid)+" Documento(s) sin Numero de Control "+CRLF+"o sin RIF"  
   oErp:lPanel :=.T.               // Publicar en el Panel

RETURN .T.
// EOF
