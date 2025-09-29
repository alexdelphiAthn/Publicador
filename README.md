# Publisher Tool

Una herramienta ligera de publicación y despliegue para proyectos Delphi, diseñada para automatizar el proceso de compilación, empaquetado y distribución de aplicaciones.

## Descripción

Publisher Tool es una aplicación de escritorio desarrollada en Delphi que simplifica el flujo de trabajo de publicación de software. A diferencia de sistemas de CI/CD más complejos, esta herramienta está diseñada para ser simple, portable y basada en archivos de configuración INI, lo que la hace ideal para equipos pequeños o proyectos individuales.

## Características Principales

### 🔨 Compilación Automatizada
- Compilación directa desde el IDE mediante línea de comandos
- Actualización automática de versiones en el código fuente
- Soporte para múltiples configuraciones (Debug/Release)
- Detección automática de rutas de Delphi desde el registro
- Logs detallados del proceso de compilación con enlaces directos a archivos/líneas de error

### 📦 Empaquetado
- Compresión de archivos fuente con patrones personalizables (*.pas, *.dfm, etc.)
- Compresión de ejecutables con archivos complementarios
- Protección con contraseña opcional usando formato 7z
- Compresión de alta calidad (nivel 9, algoritmo LZMA)
- Preservación de estructura de directorios

### 🚀 Distribución
- Envío automático a servidores sFTP
- Integración opcional con VirusTotal para análisis de seguridad
- Verificación automática de resultados de análisis

### 👤 Sistema de Perfiles
- Gestión de múltiples configuraciones mediante perfiles
- Cambio rápido entre diferentes proyectos o entornos
- Perfiles guardados en archivos INI independientes
- Soporte para lanzamiento con perfil específico mediante parámetros

### 🛠️ Interfaz Intuitiva
- Pestañas organizadas por funcionalidad
- Menús contextuales inteligentes en logs (abrir en editor, explorador, URLs)
- Detección automática de rutas de archivos y URLs en mensajes de error
- Visualización completa del contenido de archivos 7z

## Dependencias

### Bibliotecas de Terceros
- **Clever Internet Suite v9**: Comunicación sFTP
- **JEDI Code Library (JCL)**: Utilidades del sistema y ejecución de procesos
- **JVCL/JCL (JEDI Visual Component Library)**: Componentes visuales y no visuales
- **SevenZip Library**: Compresión/descompresión 7z

### Componentes Delphi Estándar
- System.Net.HttpClient (integración VirusTotal)
- System.JSON (parseo de respuestas API)
- Vcl.Dialogs, Vcl.StdCtrls (interfaz de usuario)

## Requisitos

- Delphi 10.3 Rio o superior (probado con Delphi 10.3)
- Windows 7 o superior
- Notepad++ (opcional, para apertura de archivos en errores de compilación)
- Clever Internet Suite v9 instalado
- JEDI libraries (JCL y JVCL) instalados

## Instalación

1. Clonar el repositorio
2. Asegurarse de tener instaladas las dependencias (Clever Internet Suite v9 y JEDI)
3. Abrir el proyecto en Delphi
4. Compilar y ejecutar

La aplicación creará automáticamente sus archivos de configuración INI en la primera ejecución.

## Configuración

### Primer Uso

1. **Pestaña Compilación**: Configurar rutas base de Delphi
   - Delphi Base Path (ej: `C:\Program Files (x86)\Embarcadero\Studio\20.0`)
   - Common Path (ej: `C:\Users\Public\Documents\Embarcadero\Studio\20.0`)
   
2. **Pestaña Ficheros Código Fuente**: Definir patrones de archivos a incluir
   - Por defecto: `*.pas`, `*.dfm`, `*.dpr`, `*.dproj`, `*.sql`, etc.

3. **Pestaña Conexión sFTP**: Configurar servidor (opcional)
   - Servidor, puerto, usuario y contraseña
   - Carpeta remota de destino

4. **Pestaña Publicar Ejecutable**: Configurar VirusTotal (opcional)
   - API Key de VirusTotal

### Uso de Perfiles

Los perfiles permiten mantener configuraciones separadas para diferentes proyectos:

```
AppName.ini          # Perfil por defecto
AppName_Proyecto1.ini
AppName_Proyecto2.ini
```

Para lanzar con un perfil específico:
```
Publisher.exe Proyecto1
```

## Uso Típico

### Flujo Completo de Publicación

1. **Configurar versión y proyecto**
   - Ir a pestaña "Compilación"
   - Seleccionar archivo .dpr del proyecto
   - Establecer versión (o usar botón "Obtener Fecha y Hora")

2. **Compilar**
   - Click en "COMPILAR Y CONSTRUIR EXE RELEASE"
   - Revisar log de compilación
   - En caso de errores, hacer click derecho en log para abrir archivo/línea

3. **Empaquetar ejecutable**
   - Ir a pestaña "Publicar ejecutable"
   - Agregar archivos complementarios necesarios
   - Especificar carpeta destino
   - Click en "Comprimir"

4. **Distribuir**
   - (Opcional) Click en "ENVIAR A VIRUSTOTAL"
   - Click en "Enviar Fichero Destino" para subir por sFTP

### Empaquetar Código Fuente

1. Ir a pestaña "Ficheros Código Fuente"
2. Seleccionar carpeta origen
3. Especificar archivo destino (.7z)
4. (Opcional) Establecer contraseña
5. Click en "Comprimir"
6. (Opcional) Enviar por sFTP

## Estructura de Archivos

```
Publisher/
├── Publisher.exe
├── Publisher.ini              # Configuración por defecto
├── Publisher_Perfil1.ini      # Perfiles adicionales
├── 7z.dll                     # Extraído de recursos en runtime
\Users\Usuario\AppData\Local\Publicador\logs     # Logs de compilación (si se implementa)
```

## Diferencias con Otras Herramientas

A diferencia de sistemas CI/CD completos como Jenkins, GitHub Actions o Azure DevOps:

- ✅ **Simplicidad**: No requiere servidor dedicado ni infraestructura compleja
- ✅ **Portabilidad**: Archivos INI fáciles de versionar y compartir
- ✅ **Sin dependencias externas**: Todo en una aplicación standalone
- ✅ **Interactividad**: Interfaz gráfica amigable para operación manual
- ⚠️ **Alcance limitado**: Diseñado para proyectos Delphi específicamente

## Solución de Problemas

### Error: "7z.dll no encontrada"
La DLL se extrae automáticamente de los recursos. Si falla, verificar permisos de escritura en carpeta temporal.

### Error de compilación: "Unit not found"
Verificar que las rutas de Delphi estén correctamente configuradas y que todas las bibliotecas necesarias estén instaladas.

### Error de conexión sFTP
- Verificar credenciales
- Comprobar que el puerto 22 (o el configurado) esté abierto
- Verificar que el servidor soporte sFTP (no solo FTP)

## Contribuciones

Las contribuciones y modificaciones son bienvenidas. Puedes personalizar esta aplicación para tus distribuciones. :)

## Licencia

© 2025 Alejandro Laorden Hidalgo

## Contacto

alejandro.laorden@proton.me

---

**Nota**: Esta es una herramienta de productividad personal que ha crecido orgánicamente. No pretende reemplazar sistemas profesionales de CI/CD sino complementar el flujo de trabajo de desarrolladores Delphi con una solución ligera y práctica.
