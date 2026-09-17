# Diagnostico Linux - ronda 2 (pantalla negra en Proton, juego que no abre, ejecutable en Lutris)

## 1. Ruta del ejecutable para configurar en Lutris (arreglo directo, no hace falta correr nada)

En la configuracion del juego en Lutris, campo "Executable" (o "Ejecutable"), apunta directo a:

```
current\WowLauncher.exe
```

dentro de la carpeta `AppData\Local\WowPatagoniaLauncher` del prefix que estes usando. Ejemplos segun donde
este el prefix:

```
<prefix>/drive_c/users/<usuario>/AppData/Local/WowPatagoniaLauncher/current/WowLauncher.exe
```

Para encontrar la ruta exacta sin adivinar:

```bash
find ~ -ipath "*WowPatagoniaLauncher/current/WowLauncher.exe" 2>/dev/null
```

Pegame el resultado y confirmamos que es esa. Una vez configurado ahi, Lutris deberia poder relanzarlo
sin reinstalar nada.

## 2. Pantalla negra con borde blanco (corrida con Proton)

Repetir la prueba con Proton (la que dio pantalla negra) y despues correr esto - busca el crash.log del
launcher en CUALQUIER prefix, no solo uno especifico:

```bash
find ~ -iname "crash.log" 2>/dev/null -exec echo "=== {} ===" \; -exec cat {} \;
```

Si eso no muestra nada relacionado a la corrida mas reciente (o el archivo no existe / esta vacio),
el problema es mas probable que sea de renderizado (no una excepcion de C#) y necesito la salida de Wine
en vivo. Para eso, en vez de lanzar desde la UI de Lutris, abrir una terminal y correr manualmente
(ajustar WINEPREFIX y la ruta al proton/wine real que usa Lutris para ese juego - Lutris muestra el
comando exacto en su menu contextual "Abrir terminal" o en los logs de la corrida):

```bash
WINEPREFIX=/ruta/al/prefix wine "C:\ruta\completa\a\WowLauncher.exe" 2>&1 | tee ~/wine_launcher_v2.txt
```

Pegame el contenido completo de `~/wine_launcher_v2.txt` despues de reproducir la pantalla negra.

## 3. El juego (WoW.exe) nunca abre con Wine plano (falla el autologin)

Esto confirmaria si WoW.exe efectivamente arranca el proceso pero nunca crea ventana. Con el launcher
ya abierto (Wine plano, sin Proton), justo despues de apretar JUGAR y ver el error de autologin, correr:

```bash
ps aux | grep -i "wow" | grep -v grep
```

Si aparece un proceso `Wow.exe` corriendo (aunque sin ventana visible), confirma que el problema es de
renderizado D3D9 bajo wined3d, no que el proceso no arranca. Si no aparece nada, el proceso murio antes
de tiempo y conviene mirar la salida de Wine directamente:

```bash
WINEPREFIX=/ruta/al/prefix wine "C:\ruta\a\la\carpeta\del\juego\Wow.exe" 2>&1 | tee ~/wow_launch_v2.txt
```

(la ruta real del Wow.exe es la carpeta que elegiste para instalar el cliente, no la del launcher)

## 4. Musica que se corta al mutear/desmutear

Si vuelve a pasar, contame en que momento puntual se corta (¿al abrir? ¿al volver de jugar? ¿al
mutear una vez y no se recupera nunca mas?) - con eso alcanza, no hace falta correr nada para esto todavia.
