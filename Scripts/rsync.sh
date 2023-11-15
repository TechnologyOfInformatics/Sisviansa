#!/bin/bash


#Hice este script de manera apresurada y poco aplicada, con respeto se lo comento (jaja, porque estoy usando comentarios), confio en que deberia funcionar pero no tuvo 
# pruebas muy complejas, deberia funcionar en centos pero en alpine algunas cosas funcionan y otras no, no tengo los equipos en casa para probarlo con varias maquinas
echo "---------------Selecciona una opcion-----------------"
echo "1. Copiar archivo local a directorio remoto"
echo "2. Copiar directorio local a directorio remoto"
echo "3. Copiar archivos con cierto patron desde directorio remoto"
echo "0. Salir"

    read -p "Opcion seleccionada: " opcion
while true; do
case "$opcion" in
    1)
        read -p "Ingrese la ruta completa del archivo local: " local_file
        echo "Ingrese la direccion del servidor remoto (<Usuario>@<Host>): "
        read -p "La sintaxis ha de ser <Usuario>@<Host>" remote_address
        read -p "Ingrese la ruta completa del directorio remoto: " remote_directory

        # Ya seteado el asunto, puedo usar los datos para hacer las llamadas
        rsync -zvh "$local_file" "$remote_address:$remote_directory"
        ;;
    2)
        echo "Ingrese la ruta completa del directorio local: "
        read -r local_directory

        echo "Ingrese la direccion del servidor remoto: "
        read -p "La sintaxis ha de ser <Usuario>@<Host> " remote_address

        echo "Ingrese la ruta completa del directorio remoto: "
        read -r remote_directory

        rsync -avz "$local_directory" "$remote_address:$remote_directory"
        ;;
    3)
        echo "Ingrese la direccion del servidor remoto: "
        read -p "La sintaxis ha de ser <Usuario>@<Host> " remote_address

        echo "Ingrese la ruta completa del directorio remoto:"
        read -p remote_directory

        echo "Ingrese el patron de archivos a copiar: "
        read -p "La sintaxis debe ser'*.<Extension>' " file_pattern

        # Una forma mas avanzada del 
        rsync -avze "ssh" --include "$file_pattern" --exclude "*" "$remote_address:$remote_directory" .
        # NOTAS GENERADAS CON CHATGPT PORQUE ME RE CUESTA ENTENDER EL PDF:
        #-a (o --archive): Esta opcion es una abreviatura que activa varias opciones, incluyendo:
        #   -r (o --recursive): Copia de manera recursiva, es decir, incluye todos los subdirectorios y archivos.
        #   -l (o --links): Mantiene los enlaces simbolicos.
        #   -p (o --perms): Mantiene los permisos de los archivos.
        #   -t (o --times): Mantiene los tiempos de los archivos.
        #   -g (o --group): Mantiene el grupo de los archivos.
        #   -o (o --owner): Mantiene el propietario de los archivos.
        #   -D (o --devices): Mantiene los dispositivos (especialmente util para dispositivos de bloques y caracteres).
        #-v (o --verbose): Proporciona informacion detallada sobre el progreso del comando.
        #-z (o --compress): Comprime los datos del archivo durante la transferencia para 
        #-e (o --rsh): Especifica el comando de shell remoto que se utilizara. En este caso, el valor esperado despues de -e es "ssh", 
        # indicando que se utilizara el protocolo SSH para la comunicacion segura.
        ;;
    0)
        echo "Saliendo del menu"
        exit 0
        ;;
    *)
        echo "Opcion invalida"
        ;;
    esac
    read -n 1 dummy
done
