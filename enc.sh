#!/bin/bash

# Función para encriptar archivo
encriptar() {
    local archivo_encriptado="$1"
    local archivo_desencriptado="$2"
    local llave_archivo="$3"
    local vector_archivo="$4"

    openssl enc -aes-256-cbc -K "$(cat "$llave_archivo")" -iv "$(cat "$vector_archivo")" -e -in "$archivo_encriptado" -out "$archivo_desencriptado"
}

# Función para desencriptar archivo
desencriptar() {
    local archivo_encriptado="$1"
    local archivo_desencriptado="$2"
    local llave_archivo="$3"
    local vector_archivo="$4"

    openssl enc -aes-256-cbc -K "$(cat "$llave_archivo")" -iv "$(cat "$vector_archivo")" -d -in "$archivo_encriptado" -out "$archivo_desencriptado"
}

# Menú principal
menu() {
    clear
    echo "------------------- DDAYWAVE ---------------------"
    echo "-------------------- ENC/DES ---------------------"
    echo "Bienvenido al encriptador/desencriptador con OpenSSL"
    echo "Seleccione la acción que desea realizar:"
    echo "1. Encriptar archivo"
    echo "2. Desencriptar archivo"
    echo "3. Salir"
    read -p "Opción: " opcion

    case $opcion in
        1)
            read -p "Ingrese el nombre del archivo a encriptar: " archivo_original
            read -p "Ingrese el nombre del archivo donde guardar la llave: " llave_archivo
            read -p "Ingrese el nombre del archivo donde guardar el vector: " vector_archivo
            generar_llave_vector "$llave_archivo" "$vector_archivo"
            read -p "Ingrese el nombre del archivo encriptado de salida: " archivo_encriptado
            encriptar "$archivo_original" "$archivo_encriptado" "$llave_archivo" "$vector_archivo"
            echo "Archivo encriptado correctamente."
            # Preguntar al usuario si desea eliminar el archivo original
            read -p "¿Desea eliminar el archivo original? (S/n): " eliminar
            if [[ "$eliminar" == "S" || "$eliminar" == "s" ]]; then
                rm "$archivo_original"
                echo "Archivo original eliminado."
            fi
            ;;
        2)
            submenu_desencriptar
            ;;
        3)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Por favor, seleccione una opción del menú."
            ;;
    esac

    read -n1 -r -p "Presione cualquier tecla para continuar..."
    menu
}

# Submenú para desencriptar
submenu_desencriptar() {
    clear
    echo "Menú de desencriptación"
    echo "Seleccione una opción:"
    echo "1. Ingresar llaves desde archivo"
    echo "2. Volver al menú principal"
    read -p "Opción: " opcion

    case $opcion in
        1)
            read -p "Ingrese el nombre del archivo encriptado: " archivo_encriptado
            read -p "Ingrese el nombre del archivo desencriptado de salida: " archivo_desencriptado
            read -p "Ingrese el nombre del archivo que contiene la llave: " llave_archivo
            read -p "Ingrese el nombre del archivo que contiene el vector: " vector_archivo
            desencriptar "$archivo_encriptado" "$archivo_desencriptado" "$llave_archivo" "$vector_archivo"
            echo "Archivo desencriptado correctamente."
            ;;
        2)
            return
            ;;
        *)
            echo "Opción no válida. Por favor, seleccione una opción del menú."
            ;;
    esac

    read -n1 -r -p "Presione cualquier tecla para continuar..."
    submenu_desencriptar
}

# Función para generar la llave y el vector
generar_llave_vector() {
    openssl rand -hex 32 > "$1"
    openssl rand -hex 16 > "$2"
}

# Ejecutar el menú principal
menu
