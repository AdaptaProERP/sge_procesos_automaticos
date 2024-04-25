// Proceso DOCCLIXCONTAB       
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
  LOCAL cSql,oTable
  LOCAL dDesde,dHasta
  LOCAL cWhere,cCodSuc,nPeriodo:=11,dDesde,dHasta,cTitle,nCant:=0

  IF !oDp:lPanel 
     EJECUTAR("BRSERFISMOCINDF",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle)
     RETURN NIL
  ENDIF

  cWhere:="  INNER JOIN DPDOCCLI ON MOC_CODSUC=DOC_CODSUC AND DOC_TIPDOC=MOC_TIPO AND DOC_NUMERO=MOC_DOCUME AND DOC_TIPTRA=MOC_TIPTRA  "+;
          "  LEFT  JOIN DPSERIEFISCAL     ON DOC_SERFIS=SFI_LETRA "+;
          "  INNER JOIN DPSERIEFISCAL_CTA ON DOC_SERFIS=CIC_CODIGO "+;
          "  WHERE MOC_CUENTA='Indefinida' AND MOC_ORIGEN='VTA'  "+;
          "  GROUP BY SFI_MODELO,DOC_SERFIS,CIC_CUENTA,DOC_TIPDOC,DOC_NUMERO,DOC_FECHA"
 
  cSql  :="SELECT MOC_DOCUME FROM DPASIENTOS "+cWhere


  oTable:=OpenTable(cSql,.T.)
  nCant:= oTable:RecCount()
  oTable:End()

  oErp:nMonto :=nCant
  oErp:nColor :=IF(oErp:nMonto>0,2,1)

  oErp:cDescri:=LTRAN(oErp:nMonto)+" Documentos con Series Fiscales "+CRLF+"con Cuentas Indefinidas"
  oErp:cSPEAK :=oErp:cDescri
      
  oErp:lPanel :=.T.             // Publicar en el Panel


RETURN .T.
// EOF

