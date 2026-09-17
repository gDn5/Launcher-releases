# Encontrar la carpeta real del cliente ya descargado

El launcher guarda la carpeta que elegiste (en formato Windows, ej. `C:\Users\...\WoWPatagonia - esMX`)
dentro de `settings.json`, en `%AppData%\WowLauncher\settings.json` (Roaming, no Local - distinto de
donde vive crash.log). Para encontrarla y leerla en un solo paso:

```bash
find ~ -ipath "*AppData/Roaming/WowLauncher/settings.json" 2>/dev/null -exec grep -o "\"InstallPath\":[^,]*" {} \;
```

Eso te va a mostrar algo como:

```
"InstallPath": "C:\\Users\\tuusuario\\Downloads\\esMX\\WoWPatagonia - esMX"
```

## Traducir esa ruta de Windows a la ruta real en Linux

Una vez que tengas ese valor, la traduccion depende de que letra de unidad use:

- Si empieza con `C:\` -> es dentro del prefix: `<prefix>/drive_c/<resto de la ruta con / en vez de \>`
  Ejemplo: `C:\Users\tuusuario\Downloads\esMX\WoWPatagonia - esMX` ->
  `<prefix>/drive_c/users/tuusuario/Downloads/esMX/WoWPatagonia - esMX`

- Si empieza con `Z:\` -> es tu filesystem real de Linux completo, mapeado como si fuera una unidad:
  `Z:\home\tuusuario\Descargas\...` -> `/home/tuusuario/Descargas/...` (le sacas la `Z:` y cambias `\` por `/`)

Una vez ahi, deberias encontrar `Wow.exe` (o `Wow-HD.exe`), la carpeta `Data\` y la carpeta `WTF\` directo
adentro - ahi es donde vive todo lo que ya descargaste. Para confirmar rapido que es la carpeta correcta:

```bash
find ~ -iname "Wow.exe" -o -iname "Wow-HD.exe" 2>/dev/null
```

Una vez ubicada, en el launcher (nueva instalacion, sin descargar nada) elegis esa misma carpeta como
carpeta de instalacion - el launcher va a detectar que el cliente ya esta ahi sin volver a descargar.



los comandos me devolvieron esto gonzalo@fedora:~/Downloads$ find ~ -ipath "*AppData/Roaming/WowLauncher/settings.json" 2>/dev/null -exec grep -o "\"InstallPath\":[^,]*" {} \;
"InstallPath": "C:\\"
"InstallPath": "C:\\"
"InstallPath": "C:\\openxr"
gonzalo@fedora:~/Downloads$ find ~ -iname "Wow.exe" -o -iname "Wow-HD.exe" 2>/dev/null
/home/gonzalo/.local/share/Trash/files/test.0/drive_c/Wow.exe
gonzalo@fedora:~/Downloads$ 
pero en el selector de carpetas si apreto c: abre y nada y no veo ninguna carpeta y tampoco reconoce la instalacion
