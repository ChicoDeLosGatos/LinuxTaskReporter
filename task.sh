#!/bin/bash

route="tasks/$(date +'%B%y')"
folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
mkdir -p $folder

case $1 in
init)
    if [ -z "$2" ]; then
        printf "Es necesario especificar donde quieres tener el archivo tasks, por ejemplo\n\n\ttask init /home/user/work \n\n"
    else
        rm -rf .task_config
        touch .task_config
        echo "TASK_FILE_DIRECTORY=\"$2\"" >>.task_config
        cd $2
        folder=$2
        touch tasks
        if [ -z "$3" ]; then
            printf "Modo de uso:\ntask view -> Muestra las tareas en consola.\ntask show -> Muestra las tareas en kate.\ntask start -> Genera el registro de tareas de hoy.\ntask add  \"tarea\" etiqueta -> Genera una tarea para hoy.\ntask done identificador_unico -> Finaliza la tarea del identificador_unico.\ntask end -> Finaliza el registro de tareas de hoy.\ntask report -> Registra una subida del reporte al log de reportes.\ntask help -> Muestra este texto.\ntask test -> Muestra un ejemplo de uso de task add y de task done (no lo escribirá en tasks, solo lo mostrará en pantalla).\n\n"
        fi
    fi
    ;;
forget)
    rm -rf .task_config
    ;;
current)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    echo $folder
    ;;
help)
    printf "Modo de uso:\ntask init -> Crea una nueva instancia del archivo tasks en otra ubicación. La primera vez se puede ejecutar sin ejecutar nada previamente, pero si ya tienes un archivo tasks, es necesario ejecutar antes task forget.\ntask forget -> Elimina la instancia de la dirección del archivo tasks, necesario utilizar antes de task init si ya tienes un archivo tasks. NO elimina el archivo tasks, solo elimina su ruta de esta aplicación.\ntask view -> Muestra las tareas en consola.\ntask view mesaño-> Muestra las tareas en consola del mes del año por ejemplo task view abril21.\ntask show -> Muestra las tareas en kate.\ntask start -> Genera el registro de tareas de hoy.\ntask add  \"tarea\" etiqueta -> Genera una tarea para hoy.\ntask done identificador_unico -> Finaliza la tarea del identificador_unico.\ntask end -> Finaliza el registro de tareas de hoy.\ntask report -> Registra una subida del reporte al log de reportes.\ntask help -> Muestra este texto.\ntask test -> Muestra un ejemplo de uso de task add y de task done (no lo escribirá en tasks, solo lo mostrará en pantalla).\ntask current -> Muestra donde está el archivo tasks que estás utilizando.\n\n"
    ;;
test)
    printf "Ejemplo de uso de task add:\n\n\ttask add \"Tarea de prueba.\" tdp13\n\nEsto añadirá al archivo tasks la siguiente cadena de texto:\n\n- Tarea de prueba. -tdp13\n\nEs importante que la etiqueta no tenga espacios, y si debe de tenerlos, habrá que considerar poner la etiqueta entre comillas dobles.\nEjemplo de uso de task done:\n\n\ttask done tdp13\n\nEsto editará la tarea que hemos creado, quedando en el archivo tasks esta cadena de texto:\n\n- Tarea de prueba. [OK]\n\nPodemos utilizar task view para ver los identificadores de cada tarea de forma rápida, es conveniente que sean mínimamente descriptivos. Podemos crear tantas tareas como queramos y finalizarlas cuando las terminos, independientemente del orden de finalización de las mismas, con la funcion de task done.\n\nPara ver más funciones disponibles usa task help.\n\n"
    ;;
view)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi

    if [ ! -z "$2" ]; then
        echo "$(cat ../$2/tasks)"
    else
        cat tasks
    fi
    ;;
show)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi
    kate tasks
    ;;
add)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi
    if [ -z "$3" ]; then
        echo "ERROR DE SINTAXIS. EJECUTA task add \"tarea\" etiqueta"
    else
        echo "- $2 -$3 " >>tasks
        echo "AÑADIDO."
    fi
    ;;
done)

    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi
    if [ -z "$2" ]; then
        echo "ERROR DE SINTAXIS. EJECUTA task done  etiqueta"
    else
        if cat tasks | grep $2; then
            sed -i "s/-$2/[OK]/g" tasks
            echo "Tarea $2 finalizada."
        else
            echo "No se ha encontrado la etiqueta -$2. Comprueba haberla escrito bien o si existe en tasks."
        fi
    fi
    ;;
start)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi
    echo "REGISTRO DE TAREAS ACTIVADO. ¡BUENA SUERTE!"
    now="$(date +'%d/%m/%y')"
    echo "---------------------------------------------------------------------------------------------------------------" >>tasks
    echo "[TAREAS $now]" >>tasks
    echo "" >>tasks
    ;;
report)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi
    now="$(date +'%d/%m/%y')"
    echo "---------------------------------------------------------------------------------------------------------------" >>tasks
    echo "                             [REPORTE REALIZADO] [$now]" >>tasks
    echo "REPORTE REALIZADO."
    ;;
end)
    folder="$(cat .task_config | grep TASK_FILE_DIRECTORY | grep -oP '[^\"]*\"\K[^\"]*')/$route"
    cd $folder
    touch tasks
    if [ ! -s tasks ]; then
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        echo "                              [TAREAS DE $(date +%^B)]" >>tasks
        echo "---------------------------------------------------------------------------------------------------------------" >>tasks
        printf "\n" >>tasks
    fi
    echo "" >>tasks
    echo "REGISTRO DE TAREAS FINALIZADO. ¡HASTA MAÑANA!"
    ;;
esac
