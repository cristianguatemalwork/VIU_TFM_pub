# Creación estructura reporte ----------------------------------------------------------------------
if ( dir.exists( parametros$resultado_nombre ) ) {
  unlink( parametros$resultado_tablas, recursive = TRUE, force = TRUE )
  unlink( parametros$resultado_graficos, recursive = TRUE, force = TRUE )
  unlink( parametros$resultado_nombre, recursive = TRUE, force = TRUE )
} 
dir.create( parametros$resultado_nombre )
dir.create( parametros$resultado_tablas )
dir.create( parametros$resultado_graficos )