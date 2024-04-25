// Proceso DOCPROCTA_SETPROP   
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
  LOCAL cSql,aCodCta:={},cWhereC:="",I,cCodCta:="",aNew:={}
  LOCAL aCtaBg:={oDp:cCtaBg1,oDp:cCtaBg2,oDp:cCtaBg3,oDp:cCtaBg4}
  LOCAL nTotal:=0,cWhere:=""
  LOCAL nCantid:=0

  ADEPURA(aCtaBg,{|a,n| Empty(a)})

  AEVAL(aCtaBg,{|a,n,nLen| nLen   :=LEN(a),;
                           cWhereC:=cWhereC+IF(Empty(cWhereC),[],[ OR ])+[LEFT(CTA_CODIGO,]+LSTR(nLen)+[)]+GetWhere("=",a)})

  CursorWait()
  SQLUPDATE("DPCTA","CTA_PROPIE","","CTA_PROPIE IS NULL")

  cSql:=[ SELECT CCD_CODCTA ]+;
        [ FROM dpdocprocta ]+;
        [ INNER JOIN dpdocpro ON CCD_CODSUC=DOC_CODSUC AND ]+;
        [ CCD_TIPDOC=DOC_TIPDOC AND ]+;
        [ CCD_CODIGO=DOC_CODIGO AND ]+;
        [ CCD_NUMERO=DOC_NUMERO AND ]+;
        [ DOC_TIPTRA="D" AND DOC_ACT=1 ]+;
        [ INNER JOIN dpcta ON CCD_CTAMOD=CTA_CODMOD AND CCD_CODCTA=CTA_CODIGO AND (]+cWhereC+[)]+;
        [ WHERE CTA_PROPIE="" ]+;	
        [ GROUP BY CCD_CODCTA ]

  aCodCta:=ATABLE(cSql)
  nCantid:=LEN(aCodCta)

  IF !oDp:lPanel 

     IF !Empty(aCodCta)

      // Buscar Nivel Inferior para asignar una sola propiedad
      FOR I=1 TO LEN(aCodCta)

        cCodCta:=ALLTRIM(aCodCta[I])

        WHILE !Empty(cCodCta)

           cCodCta:=LEFT(cCodCta,LEN(cCodCta)-1)

           IF ISSQLFIND("DPCTA","CTA_CODIGO"+GetWhere("=",cCodCta))

              AADD(aNew,cCodCta)

              WHILE !Empty(cCodCta)

                cCodCta:=LEFT(cCodCta,LEN(cCodCta)-1)

                IF ISSQLFIND("DPCTA","CTA_CODIGO"+GetWhere("=",cCodCta))
                  AADD(aNew,cCodCta)
                  EXIT
                ENDIF

              ENDDO

              EXIT
      
           ENDIF

         ENDDO

      NEXT I

      AEVAL(aNew,{|a,n| AADD(aCodCta,a)})

     ENDIF

     EJECUTAR("BRDPCTAPROP",NIL,NIL,NIL,NIL,NIL,NIL,aCodCta)


   ENDIF

   // Total Cuentas 
   cSql:=[ SELECT CCD_CODCTA ]+;
         [ FROM dpdocprocta ]+;
         [ INNER JOIN dpdocpro ON CCD_CODSUC=DOC_CODSUC AND ]+;
         [ CCD_TIPDOC=DOC_TIPDOC AND ]+;
         [ CCD_CODIGO=DOC_CODIGO AND ]+;
         [ CCD_NUMERO=DOC_NUMERO AND ]+;
         [ DOC_TIPTRA="D" AND DOC_ACT=1 ]+;
         [ INNER JOIN dpcta ON CCD_CTAMOD=CTA_CODMOD AND CCD_CODCTA=CTA_CODIGO AND (]+cWhereC+[)]+;
         [ WHERE CTA_PROPIE<>"" ]+;	
         [ GROUP BY CCD_CODCTA ]

   aCodCta:=ATABLE(cSql)
   nTotal :=LEN(aCodCta) // LEN(ATABLE(cSql))
   nTotal :=IF(nTotal=0,nCantid,nTotal)

   oErp:dFecha :=oDp:dFecha // Fecha
   oErp:nMonto :=0          // Monto a Publicar
   oErp:nColor :=1          // Color a Mostrar
   oErp:nColor :=IF(nTotal=nCantid .AND. nTotal>0,4,oErp:nColor)
   oErp:nColor :=IF(nTotal>nCantid .AND. nTotal>0,2,oErp:nColor)
   oErp:cDescri:="Cuentas Contables "+LSTR(nCantid)+"/"+LSTR(nTotal)+" ("+LSTR(RATA(nCantid,nTotal))+"%) en Documento de CxP"+CRLF+" sin Definición ni Propiedad Contable"
   oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
