#!/bin/bash

BASE_DIR="/mnt/c/DISCO_DURO/proyectos"

PROJECTS=(
    "Publicador"
    "subocasoft"
    "Factuzam"
    "OdaVeriFactu"
    "dbcomparer"
)

echo "Grabando automáticamente cambios de proyectos..."

auto_push_project() {
    local project_path="$BASE_DIR/$1"
    local project_name=$(basename "$1")
    local folder_name=$(dirname "$1")
    
    # === AQUÍ ESTÁ EL DETECTOR ===
    if [ -d "$project_path" ]; then
        echo "=== $folder_name/$project_name ==="
        cd "$project_path"
        
        current_branch=$(git branch --show-current)
        
        if [[ -n $(git status --porcelain) ]]; then
            echo "📝 Cambios encontrados, procesando..."
            git add .
            commit_message="Auto-update $(date '+%Y-%m-%d %H:%M:%S')"
            git commit -m "$commit_message"
            git push origin "$current_branch"
            echo "✅ $project_name actualizado y subido"
        else
            echo "ℹ️  Sin cambios en $project_name"
        fi
        echo "---"
    else
        # Si falla, nos dirá exactamente qué ruta intentó leer
        echo "❌ ERROR: Bash no encuentra la ruta -> [$project_path]"
    fi
}

for project in "${PROJECTS[@]}"; do
    auto_push_project "$project"
done

echo "¡Grabado automático completado!"