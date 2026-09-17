#!/usr/bin/env bash
# Instala el WoW Patagonia Launcher en Lutris de forma automatica: crea el prefix, baja el
# launcher (build portable, no el instalador de Velopack - evitamos que Lutris pierda la
# referencia al ejecutable, como paso las primeras veces) y lo deja listo para jugar.
#
# Lo unico que queda manual despues de esto es abrir el launcher desde Lutris, elegir carpeta
# e idioma, y descargar el cliente del juego - eso no se puede automatizar desde afuera porque
# lo maneja el propio launcher.
set -euo pipefail

echo "== Instalador de WoW Patagonia Launcher para Lutris =="

if ! command -v lutris >/dev/null 2>&1; then
    echo "Lutris no esta instalado en este sistema."
    if command -v dnf >/dev/null 2>&1; then
        echo "Instalando con dnf (puede pedirte la contrasena de sudo)..."
        sudo dnf install -y lutris
    elif command -v apt >/dev/null 2>&1; then
        echo "Instalando con apt (puede pedirte la contrasena de sudo)..."
        sudo apt install -y lutris
    elif command -v pacman >/dev/null 2>&1; then
        echo "Instalando con pacman (puede pedirte la contrasena de sudo)..."
        sudo pacman -S --noconfirm lutris
    else
        echo "No reconozco tu gestor de paquetes. Instala Lutris a mano (https://lutris.net/downloads/) y volve a correr este script."
        exit 1
    fi
fi

YAML_PATH="$(mktemp --suffix=.yaml)"
cat > "$YAML_PATH" <<'EOF'
name: WoW Patagonia Launcher
game_slug: wow-patagonia-launcher
version: Instalador automatico
slug: wow-patagonia-launcher-installer
runner: wine

script:
  game:
    exe: $GAMEDIR/WowLauncher.exe
    prefix: $GAMEDIR
    arch: win64
    working_dir: $GAMEDIR

  files:
  - launcherzip: https://github.com/gDn5/Launcher-releases/releases/latest/download/WowPatagoniaLauncher-win-Portable.zip

  installer:
  - task:
      name: create_prefix
      arch: win64
      # El launcher es un .NET autocontenido - no necesita el Mono ni el Gecko que Wine
      # normalmente ofrece instalar para apps .NET/con controles web, asi que nos los saltamos.
      install_mono: false
      install_gecko: false
  - extract:
      file: launcherzip
      dst: $GAMEDIR

  wine:
    # DXVK desactivado a proposito para este prefix: es lo que garantiza que el LAUNCHER (una
    # app 2D, sin uso real de Direct3D) no se cruce con el problema de Vulkan que vimos antes.
    # Esto es una eleccion consciente: prioriza que el launcher abra siempre bien por sobre el
    # rendimiento del WoW en si (que se beneficiaria de DXVK al ser D3D9). Si mas adelante
    # queres probar el juego con DXVK activado, se cambia despues a mano en Lutris (Configurar
    # el juego -> pestana Runner -> DXVK), una vez que el launcher ya este andando bien.
    dxvk: false

  system:
    env:
      # Evita que Wine intente instalar/usar su propio runtime .NET (mscoree) o motor HTML
      # (mshtml) - el launcher no los necesita, trae su propio runtime empaquetado.
      WINEDLLOVERRIDES: "mscoree,mshtml="
EOF

echo "Lanzando el instalador de Lutris (se abre una ventana - ya esta todo configurado, solo confirma los pasos)..."
lutris -i "$YAML_PATH"

echo ""
echo "== Listo =="
echo "Una vez que el instalador termine: abri Lutris, buscá 'WoW Patagonia Launcher' y dale Play."
echo "Adentro del launcher: elegi carpeta e idioma y descarga el cliente del juego - eso es lo unico que falta a mano."
