// Proceso NOMINA              
#INCLUDE "DPXBASE.CH"
PROCE MAIN(uPar)
 LOCAL cNombre,cData

 // Esta variable indica que el sistema de nómina, utiliza la misma DB que el SPGE
 // Necesario para determinar las obligaciones Oficiales
 // Crear la Empresa en Nómina con el nombre de la base de datos asi: DPADMWIN 

 oDp:lNomina:=.T.

 EJECUTAR("TABLASNOMINA") // Agrega al Diccionario la tabla de Nómina

 IF !EJECUTAR("DBISTABLE",oDp:cDsnData,"NMTRABAJADOR")
    oErp:cDescri:="Tabla NMTRABAJADOR no Existe "+oDp:cDsnData
    oDp:lNomina:=.F.
    RETURN NIL
 ENDIF
 
 oDp:cSql:=""
 cNombre:=SQLGET("NMTRABAJADOR","CODIGO","1=1")

 IF Empty(oDp:cSql)
   oDp:lNomina:=.F.
   MensajeErr("Es necesario Crear la DB de nómina con este Nombre: "+oDp:cDsnData)
 ENDIF

 cData:="DB de Nómina Detectada"

 oErp:dFecha :=oDp:dFecha // Fecha
 oErp:nMonto :=0          // Monto a Publicar
 oErp:nColor :=1          // Color a Mostrar
 oErp:cDescri:="BD Nómina Reconocida"         // Descripción
 oErp:lPanel :=.T.        // Publicar en el Panel

RETURN NIL
// {"DB de Nómina Detectada",0}
// EOF
