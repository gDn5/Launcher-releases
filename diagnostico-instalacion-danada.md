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
