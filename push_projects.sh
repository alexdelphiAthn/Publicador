#!/bin/bash

# Directorio base donde están tus proyectos
BASE_DIR="/mnt/c/DISCO DURO/proyectos"

# Rutas de tus tres proyectos
PROJECTS=(
    "publicador/Publicador"
    "subocasoft/subocasoft"
    "factuzam/Factuzam"
)

echo "Grabando automáticamente cambios de proyectos..."

# Función para commit y push automático
auto_push_project() {
    local project_path="$BASE_DIR/$1"
    local project_name=$(basename "$1")
    local folder_name=$(dirname "$1")
    
    if [ -d "$project_path" ]; then
        echo "=== $folder_name/$project_name ==="
        cd "$project_path"
        
        current_branch=$(git branch --show-current)
        
        if [[ -n $(git status --porcelain) ]]; then
            echo "📝 Cambios encontrados, procesando..."
            
            # Add, commit y push automático
            git add .
            commit_message="Auto-update $(date '+%Y-%m-%d %H:%M:%S')"
            git commit -m "$commit_message"
            git push origin "$current_branch"
            
            echo "✅ $project_name actualizado y subido"
        else
            echo "ℹ️  Sin cambios en $project_name"
        fi
        echo "---"
    fi
}

# Procesar cada proyecto
for project in "${PROJECTS[@]}"; do
    auto_push_project "$project"
done

echo "¡Grabado automático completado!"
