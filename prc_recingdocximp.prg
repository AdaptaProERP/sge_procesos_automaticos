// Proceso BRRECINGDOCXIMP     
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
      LOCAL cWhere:=GetWhereAnd("DOC_FECHA",oDp:dFchInicio,oDp:dFchCierre)
      LOCAL nCant :=0,nCuantos:=0,cWhere2

      IF !oDp:lPanel 
         EJECUTAR("BRRECINGDOCXIMP",NIL,10)
         RETURN .F.
      ENDIF

      cWhere2:=[ INNER JOIN DPTIPDOCCLI ON TDC_TIPO =DOC_TIPDOC  ]+;
               [ WHERE DOC_TIPDOC<>"ANT" AND DOC_TIPTRA="D" AND DOC_DOCORG="R" AND DOC_TIPAFE<>""  AND ]+cWhere+[ AND DOC_IMPRES=0 ]

      nCant  :=COUNT("DPDOCCLI",cWhere2)

      cWhere2:=[ INNER JOIN DPTIPDOCCLI ON TDC_TIPO =DOC_TIPDOC  ]+;
               [ WHERE DOC_TIPDOC<>"ANT" AND DOC_TIPTRA="D" AND DOC_DOCORG="R" AND DOC_TIPAFE<>""  AND ]+cWhere+[ ]
 
      nCuantos:=COUNT("DPDOCCLI",cWhere2)
  
      oErp:dFecha :=oDp:dFecha // Fecha
      oErp:nMonto :=0          // Monto a Publicar
      oErp:nColor :=IF(nCant>0,2,3)          // Color a Mostrar
      oErp:nColor :=IF(nCant>0 .AND. nCant=nCuantos,3,oErp:nColor)

      //IF nCant<nCuantos
        oErp:nColor :=4
      // ENDIF

      oErp:cDescri:=LSTR(nCant)+" de "+LSTR(nCuantos)+" ("+LSTR(RATA(nCant,nCuantos))+"%) Documentos Fiscales por Imprimir"
      oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
