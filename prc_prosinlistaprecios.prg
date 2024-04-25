// Proceso PROSINLISTAPRECIOS  
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/

PROCE MAIN(uPar)
LOCAL cSql,cWhere:=" CPP_FECHA IS NOT NULL "
LOCAL nDias:=15,dDesde:=oDp:dFecha-nDias
LOCAL nTotal

 IF !oDp:lPanel
 
     cWhere:=" CRP_FCHMIN IS NOT NULL "
     EJECUTAR("BRACTPREFECHA",cWhere)
     RETURN 
 ENDIF

 cSql:=[ SELECT MOV_CODCTA  FROM VIEW_INVULTCOMPRASUC  ]+;
       [ INNER JOIN DPMOVINV         ON ULT_CODSUC=MOV_CODSUC AND MOV_CODIGO=ULT_CODIGO AND ULT_FECHA=MOV_FECHA AND ULT_HORA=MOV_HORA AND MOV_APLORG="C" ]+;
       [ LEFT  JOIN DPPROVCATPRECIO  ON MOV_CODCTA=CPP_CODIGO AND MOV_CODIGO=CPP_CODINV ]+;
       [ WHERE MOV_CODSUC]+GetWhere("=",oDp:cSucursal)+[ AND CPP_FECHA IS NOT NULL AND MOV_CODCTA<>"" IS NOT NULL AND DATEDIFF(NOW(), CPP_FECHA)]+GetWhere(">=",nDias)+;
       [ GROUP BY MOV_CODCTA ]

 nTotal:=LEN(ASQL(" SELECT CPP_CODIGO FROM DPPROVCATPRECIO GROUP BY CPP_CODIGO"))

 oErp:dFecha :=oDp:dFecha // Fecha
 oErp:nMonto :=LEN(ASQL(cSql))
 oErp:nColor :=IF(oErp:nMonto=0,3,4)          // Color a Mostrar
 oErp:cDescri:=LTRAN(oErp:nMonto)+ " Proveedor(es) de "+LTRAN(nTotal)+" sin lista de Precios Actualizados"+CRLF+" en "+LSTR(nDias)+" Dia(s), Desde "+DTOC(dDesde)+" "+DTOC(oDp:dFecha)
 oErp:lPanel :=.T.        // Publicar en el Panel 

RETURN .T.
// EOF
