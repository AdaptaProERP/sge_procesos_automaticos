// Proceso PRESTDSERVSINPLA    
#INCLUDE "DPXBASE.CH"

/*
Colores
1=Mensaje
2=Tarea por Hacer
3=Trabajo Realizado
4=No se Hizo
*/


PROCE MAIN(uPar)
    LOCAL nCantid,nSinPla,nConPla,cWhere

  
    IF !oDp:lPanel 
        DPLBX("dpproveedor_prestador_de_servicios.lbx")
        RETURN NIL
    ENDIF


    cWhere :=" LEFT JOIN dpproveedorprog ON PGC_CODIGO=PRO_CODIGO "+;
             " WHERE LEFT(PRO_SITUAC,1)"+GetWhere("=","A")+" AND PRO_TIPO"+GetWhere("=","Prestador de Servicios")

    nCantid:=SQLGET("dpproveedor","COUNT(*) ,SUM(IF(PGC_CODIGO IS NULL,1,0)) AS SINPLA,COUNT(*)-SUM(IF(PGC_CODIGO IS NULL,1,0)) AS CONPLA ",cWhere)
                  
    nSinPla:=DPSQLROW(2)
    nConPla:=DPSQLROW(3)

    oErp:dFecha :=oDp:dFecha // Fecha
    oErp:nMonto :=0          // Monto a Publicar
    oErp:nColor :=IF(nSinPla>0,4,2)          // Color a Mostrar
    oErp:nColor :=IF(nSinPla>0 .AND. nSinPla=nConPla,3,oErp:nColor )          // Color a Mostrar
    oErp:cDescri:=LSTR(nSinPla)+"/"+LSTR(nCantid)+" ("+LSTR(RATA(nSinPla,nCantid))+"%) Prestadores de Servicios sin Planificación " 
    oErp:lPanel :=.T.        // Publicar en el Panel

RETURN .T.
// EOF
