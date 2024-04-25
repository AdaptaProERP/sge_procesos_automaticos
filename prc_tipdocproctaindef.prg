// Proceso TIPDOCPROCTAINDEF   
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
      LOCAL aTipDoc,cSqlA,cSqlT
      LOCAL nTodos:=0,cWhere:=NIL

      cSqlA:=[ SELECT ]+;
             [ TDC_TIPO ]+;
             [ FROM DPTIPDOCPRO ]+;
             [ INNER JOIN dpdocpro ON TDC_TIPO=DOC_TIPDOC AND DOC_TIPTRA="D" AND DOC_ACT=1 ]+;
             [ INNER JOIN dptipdocpro_CTA ON CIC_CODIGO=TDC_TIPO ]+;
             [ WHERE TDC_TIPO<>"OPA" AND TDC_CONTAB=1 AND (CIC_CUENTA="Indefinida" OR CIC_CUENTA IS NULL) ]+;
             [ GROUP BY TDC_TIPO ]

      IF !oDp:lPanel

         aTipDoc:=ASQL(cSqlA)

         IF !Empty(aTipDoc)
            AEVAL(aTipDoc,{|a,n| aTipDoc[n]:=a[1]})
            cWhere :=GetWhereOr("TDC_TIPO",aTipDoc)
         ENDIF

         EJECUTAR("BRTIPDOCPROCTA",cWhere)

         RETURN NIL

      ENDIF

      cSqlT:=[ SELECT ]+;
             [ TDC_TIPO ]+;
             [ FROM DPTIPDOCPRO ]+;
             [ INNER JOIN dpdocpro ON TDC_TIPO=DOC_TIPDOC AND DOC_TIPTRA="D" AND DOC_ACT=1 ]+;
             [ INNER JOIN dptipdocpro_CTA ON CIC_CODIGO=TDC_TIPO ]+;
             [ WHERE TDC_TIPO<>"OPA" AND TDC_CONTAB=1 ]+;
             [ GROUP BY TDC_TIPO ]

      nTodos:=LEN(ASQL(cSqlT))

      aTipDoc:=ASQL(cSqlA)

      oErp:dFecha :=oDp:dFecha    // Fecha
      oErp:nMonto :=LEN(aTipDoc) // Monto a Publicar
      oErp:nColor :=1            // Color a Mostrar
      oErp:nColor :=IF(oErp:nMonto>0,2,oErp:nColor)
      oErp:cDescri:=LSTR(oErp:nMonto)+"/"+LSTR(nTodos)+" Tipo de Documentos del proveedor"+CRLF+"sin Integración Contable"
      oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
