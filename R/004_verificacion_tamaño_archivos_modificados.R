library(knitr)

# Obtener archivos modificados no añadidos
files_modified <- system2("git", args = c("diff", "--name-only"), stdout = TRUE)

# Obtener archivos en el área de preparación
files_staged <- system2("git", args = c("diff", "--cached", "--name-only"), stdout = TRUE)

# Combinar todos los archivos modificados
all_files <- unique(c(files_modified, files_staged))

# Crear un data frame para almacenar los tamaños de los archivos
file_sizes <- data.frame(File = character(), Size_MB = numeric(), stringsAsFactors = FALSE)

# Obtener el tamaño de cada archivo
for (file in all_files) {
  # Verificar si el archivo existe
  if (file.exists(file)) {
    # Obtener el tamaño del archivo en bytes
    file_size <- file.info(file)$size
    # Convertir el tamaño a megabytes
    file_size_mb <- file_size / (1024 * 1024)
    # Añadir al data frame
    file_sizes <- rbind(file_sizes, data.frame(File = file, Size_MB = file_size_mb))
  } else {
    # Añadir al data frame si el archivo no existe
    file_sizes <- rbind(file_sizes, data.frame(File = file, Size_MB = NA))
  }
}

# Filtrar archivos que superan los 90 MB
limit <- 90
large_files <- file_sizes[ file_sizes$Size_MB > limit , ]

# Imprimir los tamaños de los archivos como una tabla
kable(file_sizes, caption = "Tamaño de Archivos Modificados")

non_na_files <- large_files[!is.na(large_files$Size_MB), ]

# Imprimir los archivos con Size_MB no NA
if (nrow(non_na_files) > 0) {
  cat("\nArchivos con tamaño de archivo disponible:\n")
  kable(non_na_files, caption = "Archivos con tamaño disponible")
} else {
  cat( paste0("\nNo hay archivos de tamaño mayor a ", limit, " MB disponible.\n"))
}
#