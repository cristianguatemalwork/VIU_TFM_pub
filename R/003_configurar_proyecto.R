# Parámetros globales R ----------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tConfiguración global de R' )

options( scipen = 99 )
setNumericRounding( 2 )
options( stringsAsFactors = FALSE )

# Parámetros ---------------------------------------------------------------------------------------
message( '\tCreando entorno de parámetros' )

# Entorno con parámetros
parametros <- new.env()

# User name
#parametros$user <- Sys.getenv( 'USER' )

parametros$fec_eje <- Sys.Date()

# Operating system name
parametros$opsys <- Sys.info()[[1]]

# Hostname
parametros$hostname <- Sys.info()[[4]]

# Directorio de trabajo
parametros$work_dir <- paste0( getwd(), '/' )

# Setting Time Zone
parametros$time_zone <- "America/Guayaquil"

# Colores IESS
parametros$iess_blue <- rgb( 0, 63, 138, maxColorValue = 255 )
parametros$iess_green <- rgb( 0, 116, 53, maxColorValue = 255 )

# Direcciones globables  ---------------------------------------------------------------------------
message( '\tEstableciendo directorios globales' )
parametros$empresa <- 'VIU'

# Nombre de la actividad
message( '\tConfiguración General' )
message( '\tLas opciones de materias son:')
message( '\t\tTrabajo Fin de Máster \t abreviado \t TFM')

parametros$materia <- readline( prompt = '\tIngrese la materia: ' )
if ( !( parametros$materia %in% c( 'TFM') ) ) {
  stop( 'La materia ingresada no está entre las opciones' )
}


parametros$fec_pub <- Sys.Date()

parametros$reportes <- paste0( parametros$work_dir, 'Reportes/' )
parametros$resultados <- paste0( parametros$work_dir, 'Resultados/' )
parametros$reporte_proyecto <- paste0( parametros$work_dir, 'Reportes/','Reporte_',parametros$empresa ,'_', 
                                       parametros$materia, '/')

parametros$reporte_genera <- paste0( parametros$work_dir, 'R/',parametros$materia,'/'
                                     ,'600_reporte_latex_', tolower(parametros$materia),'.R' )

parametros$reporte_script <- paste0( parametros$reporte_proyecto, 'reporte.R' )
parametros$reporte_nombre <- paste0( parametros$empresa,'_',parametros$materia )
parametros$reporte_latex <- paste0( parametros$reporte_nombre, '.tex' )
parametros$resultado_nombre <- paste0( parametros$resultados, parametros$reporte_nombre, '_',
                                       format( parametros$fec_eje, '%Y_%m_%d' ), '/' )
parametros$resultado_tablas <- paste0( parametros$resultados, parametros$reporte_nombre, '_',
                                       format( parametros$fec_eje, '%Y_%m_%d' ), '/tablas/' )
parametros$resultado_graficos <- paste0( parametros$resultados, parametros$reporte_nombre, '_',
                                         format( parametros$fec_eje, '%Y_%m_%d' ), '/graficos/' )

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()
