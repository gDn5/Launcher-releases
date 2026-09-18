# Diagnóstico: "Instalación dañada" en Linux

El launcher marca la instalación como dañada si no encuentra, con el **nombre y
mayúsculas/minúsculas exactos**, `Wow.exe` (o `Wow-HD.exe`) y una carpeta `Data`
con archivos `.mpq` dentro. En Windows esto no importa (NTFS no distingue
mayúsculas de minúsculas), pero en Linux (ext4, btrfs, etc.) sí distingue -
sospecho que el archivo comprimido del servidor trae otro casing y por eso el
launcher "no lo ve" aunque vos sí lo veas listado.

Reemplazá `RUTA_INSTALACION` por la carpeta real donde el launcher descargó el
juego (la que elegiste en el selector de carpetas) y corré estos comandos uno
por uno. Pegá TODO el output tal cual, sin resumir.

```bash
RUTA_INSTALACION="/ruta/a/tu/instalacion"

echo "--- 1. Listado de la raíz de instalación ---"
ls -la "$RUTA_INSTALACION"

echo "--- 2. Búsqueda del ejecutable (sensible a mayúsculas) ---"
find "$RUTA_INSTALACION" -maxdepth 1 -name "Wow.exe" -o -maxdepth 1 -name "Wow-HD.exe"

echo "--- 3. Búsqueda del ejecutable (SIN distinguir mayúsculas) ---"
find "$RUTA_INSTALACION" -maxdepth 1 -iname "wow*.exe"

echo "--- 4. Carpeta Data (sensible a mayúsculas) ---"
ls -la "$RUTA_INSTALACION/Data" 2>&1 | head -20

echo "--- 5. Carpeta Data (SIN distinguir mayúsculas, por si se llama distinto) ---"
find "$RUTA_INSTALACION" -maxdepth 1 -iname "data"

echo "--- 6. Cantidad de .mpq (sensible a mayúsculas) ---"
find "$RUTA_INSTALACION/Data" -name "*.mpq" 2>&1 | wc -l

echo "--- 7. Cantidad de .mpq (SIN distinguir mayúsculas) ---"
find "$RUTA_INSTALACION" -iname "*.mpq" 2>&1 | wc -l

echo "--- 8. Tamaño y primeros bytes del ejecutable (si find del paso 3 encontró algo) ---"
EXE=$(find "$RUTA_INSTALACION" -maxdepth 1 -iname "wow*.exe" | head -1)
echo "Ejecutable encontrado: $EXE"
ls -la "$EXE"
xxd -l 16 "$EXE"

echo "--- 9. Espacio usado total ---"
du -sh "$RUTA_INSTALACION"
```

Con eso puedo confirmar si es un problema de mayúsculas/minúsculas en el
nombre (fix simple y seguro en el código) o si de verdad falta/está corrupto
algún archivo (problema real de descarga/extracción, requiere mirar más a
fondo).


output

gonzalo@fedora:~/Documents$ ./script.sh 
--- 1. Listado de la raíz de instalación ---
total 26764
drwxr-xr-x. 4 gonzalo gonzalo     4096 Sep 18 00:37 .
drwxr-xr-x. 3 gonzalo gonzalo     4096 Sep 18 09:33 ..
-rw-r--r--. 1 gonzalo gonzalo 15588224 Sep 17 23:34 Battle.net.dll
drwxr-xr-x. 3 gonzalo gonzalo     4096 Sep 17 23:36 Data
-rw-r--r--. 1 gonzalo gonzalo  1039728 Sep 17 23:37 dbghelp.dll
-rw-r--r--. 1 gonzalo gonzalo   413696 Sep 17 23:37 DivxDecoder.dll
drwxr-xr-x. 2 gonzalo gonzalo     4096 Sep 18 00:37 .download
-rw-r--r--. 1 gonzalo gonzalo   372736 Sep 17 23:37 ijl15.dll
-rw-r--r--. 1 gonzalo gonzalo     1870 Sep 17 23:37 Microsoft.VC80.CRT.manifest
-rw-r--r--. 1 gonzalo gonzalo   632656 Sep 17 23:37 msvcr80.dll
-rw-r--r--. 1 gonzalo gonzalo   975512 Sep 17 23:37 Repair.exe
-rw-r--r--. 1 gonzalo gonzalo    49924 Sep 17 23:37 Scan.dll
-rw-r--r--. 1 gonzalo gonzalo   245408 Sep 17 23:37 unicows.dll
-rw-r--r--. 1 gonzalo gonzalo   350360 Sep 17 23:37 WowError.exe
-rw-r--r--. 1 gonzalo gonzalo  7704216 Sep 17 23:37 Wow.exe
--- 2. Búsqueda del ejecutable (sensible a mayúsculas) ---
find: warning: you have specified the global option -maxdepth after the argument -name, but global options are not positional, i.e., -maxdepth affects tests specified before it as well as those specified after it.  Please specify global options before other arguments.
/home/gonzalo/Documents/Test/Wow.exe
--- 3. Búsqueda del ejecutable (SIN distinguir mayúsculas) ---
/home/gonzalo/Documents/Test/Wow.exe
/home/gonzalo/Documents/Test/WowError.exe
--- 4. Carpeta Data (sensible a mayúsculas) ---
total 14860032
drwxr-xr-x. 3 gonzalo gonzalo       4096 Sep 17 23:36 .
drwxr-xr-x. 4 gonzalo gonzalo       4096 Sep 18 00:37 ..
-rw-r--r--. 1 gonzalo gonzalo 1814307386 Sep 17 23:34 common-2.MPQ
-rw-r--r--. 1 gonzalo gonzalo 2884765579 Sep 17 23:35 common.MPQ
drwxr-xr-x. 4 gonzalo gonzalo       4096 Sep 17 23:35 esMX
-rw-r--r--. 1 gonzalo gonzalo 1923425302 Sep 17 23:36 expansion.MPQ
-rw-r--r--. 1 gonzalo gonzalo 2581185615 Sep 17 23:36 lichking.MPQ
-rw-r--r--. 1 gonzalo gonzalo 1403129115 Sep 17 23:36 patch-2.MPQ
-rw-r--r--. 1 gonzalo gonzalo  605089137 Sep 17 23:36 patch-3.MPQ
-rw-r--r--. 1 gonzalo gonzalo 4004713057 Sep 17 23:37 patch.MPQ
--- 5. Carpeta Data (SIN distinguir mayúsculas, por si se llama distinto) ---
/home/gonzalo/Documents/Test/Data
--- 6. Cantidad de .mpq (sensible a mayúsculas) ---
0
--- 7. Cantidad de .mpq (SIN distinguir mayúsculas) ---
18
--- 8. Tamaño y primeros bytes del ejecutable (si find del paso 3 encontró algo) ---
Ejecutable encontrado: /home/gonzalo/Documents/Test/Wow.exe
-rw-r--r--. 1 gonzalo gonzalo 7704216 Sep 17 23:37 /home/gonzalo/Documents/Test/Wow.exe
./script.sh: line 28: xxd: command not found
--- 9. Espacio usado total ---
17G	/home/gonzalo/Documents/Test
gonzalo@fedora:~/Documents$ 
