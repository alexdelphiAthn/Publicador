#!/bin/bash

# Directorio base donde están tus proyectos
BASE_DIR="/mnt/c/DISCO DURO/proyectos"

# Rutas de tus tres proyectos
PROJECTS=(
    "Publicador"
    "subocasoft"
    "Factuzam"
)

echo "Actualizando proyectos en $BASE_DIR..."

# Función para hacer pull en un proyecto
update_project() {
    local project_path="$BASE_DIR/$1"
    local project_name=$(basename "$1")
    local folder_name=$(dirname "$1")
    
    if [ -d "$project_path" ]; then
        echo "=== Actualizando $folder_name/$project_name ==="
        cd "$project_path"
        
        # Mostrar rama actual
        current_branch=$(git branch --show-current)
        echo "Rama actual: $current_branch"
        
        # Verificar si hay cambios sin commitear
        if [[ -n $(git status --porcelain) ]]; then
            echo "⚠️  Hay cambios sin commitear en $project_name"
            git status --short
            echo "Saltando pull para evitar conflictos..."
        else
            echo "Haciendo pull..."
            git pull origin main
            if [ $? -eq 0 ]; then
                echo "✓ $project_name actualizado correctamente"
            else
                echo "❌ Error al actualizar $project_name - verificando otras ramas..."
                # Intentar con la rama actual si main no existe
                git pull origin "$current_branch" 2>/dev/null || echo "No se pudo actualizar"
            fi
        fi
        echo "---"
    else
        echo "⚠️  No se encontró: $project_path"
    fi
}

# Actualizar cada proyecto
for project in "${PROJECTS[@]}"; do
    update_project "$project"
done

echo "¡Actualización de los 3 proyectos completada!"
echo "Proyectos actualizados:"
echo "  - Publicador"
echo "  - Subocasoft" 
echo "  - Factuzam"
