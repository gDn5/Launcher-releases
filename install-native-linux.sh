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
    echo "Instalando dependencias (vlc + plugins, xdotool, ydotool, wine)..."
    if command -v dnf >/dev/null 2>&1; then
        # vlc-libs por si solo NO alcanza: es unicamente libvlc.so/libvlccore.so, sin ningun
        # plugin de decodificacion (confirmado contra el .spec real de Fedora - vlc-plugins-base
        # es un subpaquete separado que vlc-libs no arrastra como dependencia). Sin el, libvlc
        # carga bien pero no hay nada que decodifique audio/video - silencio total, sin error.
        # vlc-plugins-base tampoco alcanza del todo: el video de fondo es H.264 (mp4), y ese
        # decoder especificamente vive en vlc-plugin-ffmpeg (otro subpaquete mas, separado de
        # base por licenciamiento de patentes - confirmado: la musica sonaba con solo
        # plugins-base instalado, pero el video seguia sin funcionar). vlc-plugins-all instala
        # todos los subpaquetes de una vez y evita seguir adivinando cual falta.
        sudo dnf install -y vlc-libs vlc-plugins-all xdotool ydotool wine
    elif command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu no separan tan finamente como Fedora, pero por las dudas se suma el
        # paquete "vlc" completo tambien, en vez de asumir que vlc-plugin-base alcanza.
        sudo apt install -y vlc vlc-plugin-base libvlc5 xdotool ydotool wine
    elif command -v pacman >/dev/null 2>&1; then
        # A diferencia de Fedora/Debian, Arch no separa un paquete de "solo plugins" - libvlc por
        # si solo (confirmado contra su propio depends: solo dbus/glibc/libgcc, sin plugins) no
        # alcanza; hace falta el paquete "vlc" completo, que es el que trae los plugins reales
        # (incluido el decoder H.264, ya compilado adentro del mismo paquete en Arch).
        sudo pacman -S --needed --noconfirm vlc xdotool ydotool wine
    else
        echo "No reconozco tu gestor de paquetes. Instala manualmente: vlc (paquete completo, no solo la libreria), xdotool, ydotool y wine."
        exit 1
    fi
}

missing=()
command -v xdotool >/dev/null 2>&1 || missing+=("xdotool")
command -v ydotool >/dev/null 2>&1 || missing+=("ydotool")
command -v wine >/dev/null 2>&1 || missing+=("wine")
# No hay un binario "vlc-libs" en si - se chequea buscando la libreria compartida real.
ldconfig -p 2>/dev/null | grep -q "libvlc\.so" || missing+=("vlc-libs")
# La libreria puede estar presente sin sus plugins, y con SOLO los plugins basicos sin el
# decoder de video (ver comentario en install_deps - confirmado con un caso real: sonaba la
# musica pero no habia video, con vlc-plugins-base instalado y vlc-plugins-all/vlc-plugin-ffmpeg
# faltando). Se busca el plugin de avcodec especificamente (el que decodifica el H.264 del video
# de fondo), no solo "algun" archivo en la carpeta de plugins - asi una instalacion parcial
# vieja tambien se detecta como incompleta en vez de leerse como "ya esta todo instalado".
find /usr/lib* -ipath "*/vlc/plugins/*avcodec*" 2>/dev/null | grep -q . || missing+=("vlc-plugins")

if [ ${#missing[@]} -gt 0 ]; then
    echo "Faltan: ${missing[*]}"
    install_deps
else
    echo "Todas las dependencias ya estan instaladas."
fi

# ydotool necesita permiso sobre /dev/uinput y un daemon (ydotoold) corriendo - el paquete de
# ydotool por si solo no alcanza en todas las distros (Fedora, por ejemplo, no trae la regla udev
# que si trae Arch). Se configura una vez de forma idempotente: regla udev propia (grupo "input"
# sobre /dev/uinput), el usuario agregado a ese grupo, y un servicio de usuario propio para
# ydotoold - no se depende del unit que cada distro empaqueta (Fedora lo hace a nivel sistema
# corriendo como root con el socket 0600 solo-root por default, Arch a nivel usuario; en vez de
# pelear con esa diferencia, se define un unit propio que siempre corre como el usuario actual).
echo "Configurando ydotool (para el login automatico sin el dialogo de Wayland)..."

UDEV_RULE_PATH="/etc/udev/rules.d/90-wowpatagonia-uinput.rules"
if [ ! -f "$UDEV_RULE_PATH" ]; then
    echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' | sudo tee "$UDEV_RULE_PATH" >/dev/null
    sudo udevadm control --reload-rules
    sudo udevadm trigger --name-match=uinput 2>/dev/null || true
fi

NEEDS_RELOGIN=0
if ! id -nG "$USER" | grep -qw input; then
    sudo usermod -aG input "$USER"
    NEEDS_RELOGIN=1
fi

YDOTOOL_BIN="$(command -v ydotoold || true)"
if [ -n "$YDOTOOL_BIN" ]; then
    mkdir -p "$HOME/.config/systemd/user"
    cat > "$HOME/.config/systemd/user/ydotool.service" <<EOF
[Unit]
Description=ydotoold (WoW Patagonia Launcher)

[Service]
ExecStart=$YDOTOOL_BIN
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable ydotool

    if [ "$NEEDS_RELOGIN" -eq 0 ]; then
        systemctl --user restart ydotool
    fi
fi

if [ "$NEEDS_RELOGIN" -eq 1 ]; then
    echo ""
    echo "IMPORTANTE: se te agrego al grupo 'input' recien ahora - tenes que CERRAR SESION Y VOLVER"
    echo "A ENTRAR (no alcanza con reabrir la terminal) para que el login automatico del launcher"
    echo "funcione. El resto de la instalacion sigue igual mientras tanto."
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
