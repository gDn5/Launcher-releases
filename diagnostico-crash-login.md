# Diagnostico: crash al hacer login (Wine/Lutris)

El launcher crashea al hacer login tanto con Wine plano como con Lutris. El backtrace
(`backtrace.txt` en este mismo repo) muestra una excepcion real de .NET (0xe0434352) tirada
mientras se procesa el click de login, pero Wine no logra propagarla limpio y crashea el proceso
antes de que se vea el error real - y el backtrace no trae simbolos, asi que no dice cual excepcion
fue ni en que linea.

El launcher tiene un log propio de crashes (CrashLogger) que debería haber capturado la excepcion
real ANTES de que Wine explote. Correr estos comandos EN ORDEN en una terminal de Fedora y pegar
TODO el output (aunque diga "No such file or directory" en algunos):

## 1. Busqueda directa de crash.log en el home

```bash
find ~ -iname "crash.log" 2>/dev/null -exec echo "=== {} ===" \; -exec cat {} \;
```

## 2. Ubicaciones mas probables directamente

Wine plano (prefix por defecto):
```bash
cat ~/.wine/drive_c/users/$USER/AppData/Local/WowLauncher/crash.log 2>&1
```

Prefix que crea Lutris para este juego (visto en el log anterior: `/home/gonzalo/Games/launcher`):
```bash
cat ~/Games/launcher/drive_c/users/$USER/AppData/Local/WowLauncher/crash.log 2>&1
```

## 3. Si el paso 1 no encontro nada: buscar toda la carpeta WowLauncher (aunque no haya crash.log)

```bash
find ~ -ipath "*AppData/Local/WowLauncher*" 2>/dev/null
```

Esto deberia listar al menos `settings.json` si el launcher pudo escribir algo ahi. Si ni eso
aparece, el problema es de permisos/paths antes de siquiera llegar al codigo que loguea.

## 4. Busqueda mas amplia (todo el filesystem, mas lenta) por si el prefix esta en otro lado

```bash
find / -iname "crash.log" 2>/dev/null -exec echo "=== {} ===" \; -exec cat {} \;
```

## 5. Si nada de lo anterior encuentra nada: correr desde terminal para ver stdout/stderr en vivo

Ubicar primero donde esta el exe extraido y con que prefix corriste (ajustar la ruta si no es
`~/Downloads/WowLauncher-win-x64-wine`):

```bash
cd ~/Downloads/WowLauncher-win-x64-wine 2>/dev/null || cd ~ && find ~ -iname "WowLauncher.exe" 2>/dev/null
```

Con la ruta real del exe y, si usaste Lutris, agregando `WINEPREFIX=~/Games/launcher` adelante:

```bash
wine WowLauncher.exe 2>&1 | tee ~/wine_launcher_debug.txt
```

Reproducir el crash (login) y despues pegar el contenido de `~/wine_launcher_debug.txt` completo.
