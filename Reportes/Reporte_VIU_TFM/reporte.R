#Script generado para compilar el informe
message( paste( rep( '-', 100 ), collapse = '' ) )

# Carga información --------------------------------------------------------------------------------
message('\tCargando información' )
setwd( parametros$work_dir )

# Control ------------------------------------------------------------------------------------------
REP_copy_final <- FALSE
REP_knit_quiet <- TRUE
REP_hacer_graficos <- TRUE
REP_hacer_tablas <- TRUE
REP_latex_clean <- TRUE
REP_latex_aux_clean <- FALSE
REP_latex_quiet <- TRUE

# Parámetros ---------------------------------------------------------------------------------------
message('\tEstableciendo parámetros')
REP_rep_nom <- parametros$reporte_nombre
REP_empresa <- parametros$empresa
REP_rep_dir <- parametros$resultado_nombre
REP_rep_tab <- parametros$resultado_tablas
REP_rep_gra <- parametros$resultado_graficos
REP_rep_latex <- parametros$reporte_latex
REP_style <- 'style.tex'
REP_bib_ley <- 'Bibliografia_TFT.bib'

REP_fec_pub <- paste0( format( parametros$fec_pub, '%d' ), ' de '
                       ,toupper(substr(format( parametros$fec_pub, '%B' ),1,1))
                       ,substr(format( parametros$fec_pub, '%B' ),2
                               ,nchar(format( parametros$fec_pub, '%B' )))
                       ,' de '
                       , format( parametros$fec_pub, '%Y' ))

# REP_tit <- 'Nombre del Proyecto'
# REP_num<- parametros$num
REP_watermark <- paste0( 'Borrador ', parametros$fec_eje, ' ', format( Sys.time(), '%H:%M:%S' ) )
# REP_version <- digest( paste0( 'IESSDAIE', format( Sys.time(), '%Y%m%d%H' ) ), algo = 'sha256', file = FALSE )

# Copia de resultados  -----------------------------------------------------------------------------
REP_file_latex_org <- c( paste( parametros$work_dir, 'Reportes/Bibliografia_TFT.bib', sep = '' ) ,
                         paste( parametros$work_dir, 'Reportes/style.tex', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/Picture_TitlePage.jpg', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/image3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/image5.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/image6.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/dbscan.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/jerarquico.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/kmeans.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/supervisados.png', sep = '' ),
                         
                         #CLuster jerarquico
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_271_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20889867_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_8804_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_3071_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20857054_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_10133_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20013447_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_3608_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_135752_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_154409_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_1908_2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20847366_2.png', sep = '' ),
                         
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_8804_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_3071_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20857054_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_10133_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20013447_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_3608_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_135752_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_154409_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_1908_3.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_cj_20847366_3.png', sep = '' ),
                         
                         #kmean
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_8804_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_3071_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_20857054_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_10133_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_20013447_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_3608_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_135752_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_154409_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_1908_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_km_20847366_1.png', sep = '' ),
                         
                         #DBSCAN
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_8804_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_3071_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_20857054_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_10133_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_20013447_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_3608_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_135752_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_154409_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_1908_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_20847366_1.png', sep = '' ),
                         
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_8804_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_3071_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_20857054_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_10133_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_20013447_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_3608_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_135752_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_154409_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_1908_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_db_ati_20847366_1.png', sep = '' ),
                         
                         # Sueldoso todo atipico
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_CJ_29231_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_CJ_9886_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_CJ_18457_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_CJ_18587_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_CJ_28952_1.png', sep = '' ),
                         
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_KM_32065_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_KM_77614_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_KM_82208_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_KM_91427_1.png', sep = '' ),
                         
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_6037_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_8851_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_9315_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_20856876_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_20878541_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_20889867_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algoritmo_ATI_DB_177653_1.png', sep = '' ),
                         
                         #Corrección de base de calculo
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_4382_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_26246_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_2141271_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_10351659_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_1844848_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_5287079_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_5414462_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_13290239_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_5579649_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_16132025_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_16445975_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_16508727_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_110456_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_172889_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_16135176_1.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/base_sin_ati_CJ_13161696_1.png', sep = '' ),
                         
                         #Selección características
                         paste( parametros$work_dir, 'Reportes/dendograma_sel_carac_cj.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/valor_epsilon_feacture_norm.png', sep = '' ),
                         
                         #KNN
                         paste( parametros$work_dir, 'Reportes/algortimo_knn_acp.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_knn_acp.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algortimo_knn_bal_acp.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_knn_bal_acp.png', sep = '' ),
                         
                         paste( parametros$work_dir, 'Reportes/algortimo_knn_ml.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_knn_ml.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algortimo_knn_bal_ml.jpeg', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_knn_bal_ml.png', sep = '' ),
                         
                         #Arbol simple 
                         paste( parametros$work_dir, 'Reportes/algortimo_arbol_simple.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_arbol_simple.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/algortimo_arbol_simple_bal.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_arbol_simple_bal.png', sep = '' ),
                         #Conjunto de modelos
                         #RandomForestClassifier
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_RandomForestClassifier_random_search.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_RandomForestClassifier_grid_search.png', sep = '' ),
                         #AdaBoostClassifier
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_AdaBoostClassifier_random_search.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_AdaBoostClassifier_grid_search.png', sep = '' ),
                         
                         #Gradient Boosting
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_GradientBoostingClassifier_random_search.png', sep = '' ),
                         
                         #XGBClassifier
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_XGBClassifier_random_search.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_XGBClassifier_grid_search.png', sep = '' ),
                         
                         #Redes
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_redes_grid_search.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/confusion_matrix_algoritmo_redes_bal_grid_search.png', sep = '' ),
                         
                         #Analisis
                         paste( parametros$work_dir, 'Reportes/fraude_por_sexo.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/fraude_por_edad_jubilacion.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/fraude_fecha_derecho_sexo.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/fraude_fecha_nacimiento_sexo.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/fraude_numero_imposiciones_sexo.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/pastel_sector_m.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/pastel_sector_n.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/fraude_por_tipo_pension.png', sep = '' ),
                         
                         #Computador
                         paste( parametros$work_dir, 'Reportes/caracteristicas_computador.jpeg', sep = '' ),
                         
                         #Github
                         paste( parametros$work_dir, 'Reportes/viu_plantilla_github.png', sep = '' )
                         
                        )


REP_file_latex_des <- c( paste( REP_rep_dir, 'Bibliografia_TFT.bib', sep = '' ),
                         paste( REP_rep_dir, 'style.tex', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'Picture_TitlePage.jpg', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'image3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'image5.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'image6.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'dbscan.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'jerarquico.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'kmeans.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'supervisados.png', sep = '' ),
                         
                         #CLuster jerarquico
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_271_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20889867_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_8804_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_3071_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20857054_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_10133_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20013447_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_3608_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_135752_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_154409_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_1908_2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20847366_2.png', sep = '' ),
                         
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_8804_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_3071_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20857054_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_10133_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20013447_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_3608_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_135752_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_154409_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_1908_3.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_cj_20847366_3.png', sep = '' ),
                         
                         #kmeans
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_8804_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_3071_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_20857054_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_10133_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_20013447_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_3608_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_135752_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_154409_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_1908_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_km_20847366_1.png', sep = '' ),
                         
                         #DBSCAN
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_8804_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_3071_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_20857054_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_10133_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_20013447_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_3608_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_135752_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_154409_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_1908_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_20847366_1.png', sep = '' ),
                         
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_8804_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_3071_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_20857054_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_10133_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_20013447_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_3608_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_135752_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_154409_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_1908_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_db_ati_20847366_1.png', sep = '' ),
                         
                         #Sueldos iguales
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_CJ_29231_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_CJ_9886_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_CJ_18457_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_CJ_18587_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_CJ_28952_1.png', sep = '' ),
                         
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_KM_32065_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_KM_77614_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_KM_82208_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_KM_91427_1.png', sep = '' ),
                         
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_6037_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_8851_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_9315_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_20856876_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_20878541_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_20889867_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algoritmo_ATI_DB_177653_1.png', sep = '' ),
                         
                         #Corrección de base de calculo
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_4382_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_26246_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_2141271_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_10351659_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_1844848_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_5287079_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_5414462_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_13290239_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_5579649_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_16132025_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_16445975_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_16508727_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_110456_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_172889_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_16135176_1.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'base_sin_ati_CJ_13161696_1.png', sep = '' ),
                         
                         #Selección características
                         paste( REP_rep_dir, 'graficos/', 'dendograma_sel_carac_cj.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'valor_epsilon_feacture_norm.png', sep = '' ), 
                         
                         #knn
                         paste( REP_rep_dir, 'graficos/', 'algortimo_knn_acp.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_knn_acp.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algortimo_knn_bal_acp.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_knn_bal_acp.png', sep = '' ),
                         
                         paste( REP_rep_dir, 'graficos/', 'algortimo_knn_ml.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_knn_ml.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algortimo_knn_bal_ml.jpeg', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_knn_bal_ml.png', sep = '' ),
                         
                         #Arbol simple 
                         paste( REP_rep_dir, 'graficos/', 'algortimo_arbol_simple.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_arbol_simple.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'algortimo_arbol_simple_bal.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_arbol_simple_bal.png', sep = '' ),
                         #Conjunto de modelos
                         #RandomForestClassifier
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_RandomForestClassifier_random_search.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_RandomForestClassifier_grid_search.png', sep = '' ),
                         #AdaBoostClassifier
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_AdaBoostClassifier_random_search.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_AdaBoostClassifier_grid_search.png', sep = '' ),
                         
                         #Gradient Boosting
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_GradientBoostingClassifier_random_search.png', sep = '' ),
                         
                         #XGBClassifier
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_XGBClassifier_random_search.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_XGBClassifier_grid_search.png', sep = '' ),
                         
                         #Redes neuronales
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_redes_grid_search.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'confusion_matrix_algoritmo_redes_bal_grid_search.png', sep = '' ),
                         
                         #Análisis
                         paste( REP_rep_dir, 'graficos/', 'fraude_por_sexo.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'fraude_por_edad_jubilacion.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'fraude_fecha_derecho_sexo.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'fraude_fecha_nacimiento_sexo.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'fraude_numero_imposiciones_sexo.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'pastel_sector_m.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'pastel_sector_n.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/', 'fraude_por_tipo_pension.png', sep = '' ),
                         
                         #Computador
                         paste( REP_rep_dir, 'graficos/', 'caracteristicas_computador.jpeg', sep = '' ),
                         
                         #Github
                         paste( REP_rep_dir, 'graficos/', 'viu_plantilla_github.png', sep = '' )
                        )

REP_file_latex_clean <- c( paste( REP_rep_dir, 'Bibliografia_TFT.bib', sep = '' ), 
                           paste( REP_rep_dir, 'style.tex', sep = '' ) )

file.copy( REP_file_latex_org, REP_file_latex_des, overwrite = TRUE  )

# Compilación reporte ------------------------------------------------------------------------------
message('\tInicio compilación')

# Genera información automática --------------------------------------------------------------------
#source( paste0( parametros$reporte_proyecto, 'auto_informacion.R' ), encoding = 'UTF-8', echo = FALSE )

# Kniting reporte ----------------------------------------------------------------------------------
setwd( parametros$reporte_proyecto ) 
knit( input = "reporte.Rnw", 
      output = paste0( REP_rep_dir, REP_rep_latex ),
      quiet = REP_knit_quiet, encoding = 'utf8' )

# Compilacion LaTeX --------------------------------------------------------------------------------
message( paste0( '\tInicio compilación LaTeX: ', Sys.time() ) )
setwd( REP_rep_dir )
tools::texi2pdf( REP_rep_latex, quiet = REP_latex_quiet, clean = REP_latex_clean )  
setwd( parametros$work_dir )
message( paste0( '\tFin compilación LaTeX: ', Sys.time() ) )

if( REP_latex_aux_clean ) {
  unlink( REP_file_latex_clean, recursive = TRUE )
}
####################################################################################################
message( paste( rep( '-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()