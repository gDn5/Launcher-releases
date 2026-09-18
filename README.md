# Launcher de WoW Patagonia

[![Última versión](https://img.shields.io/github/v/release/gDn5/Launcher-releases?label=%C3%BAltima%20versi%C3%B3n&color=E3B341)](https://github.com/gDn5/Launcher-releases/releases/latest)

Launcher oficial para jugar en **WoW Patagonia**: descarga e instala el cliente, mantiene todo actualizado solo, y te deja en el juego con un click.

## Descarga

### Windows

**[⬇ Descargar la última versión](https://github.com/gDn5/Launcher-releases/releases/latest)** — bajá `WowPatagoniaLauncher-win-Setup.exe` y ejecutalo. No hay asistentes ni pasos intermedios: se instala solo y abre el launcher apenas termina.

> **¿Aparece un aviso de Windows ("Windows protegió tu PC")?** Es esperable: el launcher todavía no tiene firma digital (un trámite pago que no cambia la seguridad real de la app, solo evita ese aviso en instaladores nuevos). Hacé click en **"Más información"** y después en **"Ejecutar de todas formas"** para continuar.

### Linux (beta)

El launcher también corre **nativo en Linux** — no hace falta Lutris, Proton ni configurar nada a mano. Wine se usa únicamente por detrás para el cliente de WoW en sí (que es un ejecutable de Windows sin alternativa nativa); el launcher lo instala solo si no lo tenés.

Instalación con un solo comando (te va a pedir tu contraseña para instalar dependencias que falten — `wine`, `xdotool`, `vlc-libs` — vía tu gestor de paquetes: dnf, apt o pacman):

```bash
curl -sL https://raw.githubusercontent.com/gDn5/Launcher-releases/main/install-native-linux.sh | bash
```

Esto deja todo instalado en `~/WowPatagoniaLauncher`. Para abrir el launcher después:

```bash
~/WowPatagoniaLauncher/WowLauncher
```

> Es un build en etapa temprana — si algo falla, contanos en el Discord con el mayor detalle posible (distro, y si podés, lo que aparece en la terminal al abrirlo).

## Qué hace

- **Instalación en un click.** Sin pasos manuales, sin configuración previa: instalás y jugás.
- **Se actualiza solo.** Cada nueva versión se aplica sola la próxima vez que abrís el launcher — nunca más hay que buscar ni descargar nada a mano.
- **Descarga el cliente completo.** Elegís carpeta e idioma (Español México, Español España o Inglés) y el launcher se encarga de bajar, verificar y extraer todo.
- **Inicio de sesión automático.** Guardá tu cuenta una vez — la contraseña queda cifrada en tu equipo — y el launcher te loguea solo al entrar al juego.
- **Parches de gráficos HD opcionales.** Versión completa o liviana (Lite), instalables y desinstalables desde el launcher sin tocar un solo archivo a mano.
- **Explorador de addons integrado.** Buscá, instalá y actualizá addons de WotLK sin salir del launcher.
- **Perfiles de gráficos según tu hardware.** Detecta tu PC y sugiere una configuración de gráficos acorde, aplicable con un click.
- **Noticias y estado de los realms** a la vista apenas abrís el launcher.

## Requisitos

| | |
|---|---|
| Sistema operativo | Windows 10 u 11 (64 bits), o Linux (64 bits, beta) |
| Espacio en disco | ~20 GB libres (cliente base, con margen para parches opcionales) |
| Conexión a internet | Necesaria para la descarga inicial y las actualizaciones |

## Privacidad

La contraseña de tu cuenta se guarda **cifrada** en tu propia PC y solo se usa para loguearte automáticamente en el juego — nunca se envía a ningún otro lado.

## Bajo el capó

Para quien tenga curiosidad: el launcher está hecho en **.NET / Avalonia UI** (multiplataforma por diseño) y se distribuye como aplicación autocontenida — no necesita tener .NET instalado aparte. Las actualizaciones usan **paquetes delta**: cada nueva versión descarga únicamente lo que cambió respecto a la anterior, no el instalador completo de nuevo.

## Soporte

¿Encontraste un problema o tenés una sugerencia? Contanos en el Discord del servidor.

---

*Este repositorio publica únicamente los binarios del launcher — no contiene código fuente.*
