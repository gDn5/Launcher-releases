# Diagnóstico: video/música no funcionan en Linux

1. Revisar si ya quedó algo logueado (no hace falta reinstalar nada para este paso):

```bash
cat ~/.local/share/WowLauncher/crash.log
```

2. Actualizar a la última build (ahora si LibVLC falla al cargar el video/música, queda logueado ahí mismo, no depende de que el recolector de basura lo detecte):

```bash
curl -sL https://raw.githubusercontent.com/gDn5/Launcher-releases/main/install-native-linux.sh | bash
```

3. Abrir el launcher de nuevo y, si video/música siguen sin andar, volver a mirar el log:

```bash
cat ~/.local/share/WowLauncher/crash.log
```

Pegar acá (o en un archivo nuevo en este repo) lo que devuelva el paso 1 y/o el 3.
