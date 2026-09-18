#!/usr/bin/env bash
# Instala las dependencias, baja y deja listo para correr el build NATIVO de Linux del launcher
# (no usa Wine/Lutris para el launcher en si - Wine solo se invoca despues, adentro del propio
# launcher, para lanzar el WoW).
set -euo pipefail

# TODO: esto es un build de prueba con su propio tag fijo, no "latest" - una vez que el build
# nativo de Linux se integre al pipeline de releases normal, esto deberia apuntar a
# releases/latest/download/... como ya hace el launcher de Windows.
RELEASE_TAG="linux-native-test-1"
ASSET_URL="https://github.com/gDn5/Launcher-releases/releases/download/${RELEASE_TAG}/linux-native-test.tar.gz"
INSTALL_DIR="$HOME/WowPatagoniaLauncher"

echo "== Instalador del build nativo de Linux del WoW Patagonia Launcher =="

install_deps() {
    echo "Instalando dependencias (vlc-libs, xdotool, wine)..."
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y vlc-libs xdotool wine
    elif command -v apt >/dev/null 2>&1; then
        sudo apt install -y vlc-plugin-base libvlc5 xdotool wine
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm libvlc xdotool wine
    else
        echo "No reconozco tu gestor de paquetes. Instala manualmente: libvlc/vlc, xdotool y wine."
        exit 1
    fi
}

missing=()
command -v xdotool >/dev/null 2>&1 || missing+=("xdotool")
command -v wine >/dev/null 2>&1 || missing+=("wine")
# No hay un binario "vlc-libs" en si - se chequea buscando la libreria compartida real.
ldconfig -p 2>/dev/null | grep -q "libvlc\.so" || missing+=("vlc-libs")

if [ ${#missing[@]} -gt 0 ]; then
    echo "Faltan: ${missing[*]}"
    install_deps
else
    echo "Todas las dependencias ya estan instaladas."
fi

echo "Descargando el launcher..."
mkdir -p "$INSTALL_DIR"
curl -sL "$ASSET_URL" -o "$INSTALL_DIR/launcher.tar.gz"

echo "Descomprimiendo en $INSTALL_DIR..."
tar -xzf "$INSTALL_DIR/launcher.tar.gz" -C "$INSTALL_DIR"
rm -f "$INSTALL_DIR/launcher.tar.gz"

# La tar no siempre preserva el bit de ejecutable (se empaqueto desde Windows) - lo forzamos.
chmod +x "$INSTALL_DIR/WowLauncher"

echo ""
echo "== Listo =="
echo "Para abrir el launcher:"
echo "  $INSTALL_DIR/WowLauncher"
