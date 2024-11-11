# Carga de paquetes --------------------------------------------------------------------------------
message( paste( rep( '-', 100 ), collapse = '' ) )
message( '\tCargando paquetes' )

suppressPackageStartupMessages( library( knitr ) )
suppressPackageStartupMessages( library( dtplyr ) )
suppressPackageStartupMessages( library( data.table ) )
suppressPackageStartupMessages( library( digest ) )


message( paste( rep( '-', 100 ), collapse = '' ) )