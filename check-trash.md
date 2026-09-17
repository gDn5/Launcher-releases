# Revisar si el cliente sigue completo en la papelera

Encontramos `Wow.exe` en `/home/gonzalo/.local/share/Trash/files/test.0/drive_c/Wow.exe` - de un intento
anterior que se borro. Antes de descargar todo de nuevo, veamos si sigue completo ahi adentro:

```bash
ls -la "/home/gonzalo/.local/share/Trash/files/test.0/drive_c/"
```

Buscamos especificamente que esten `Data` y `WTF` (o al menos `Data`, que es la parte pesada):

```bash
du -sh "/home/gonzalo/.local/share/Trash/files/test.0/drive_c/Data" 2>/dev/null
du -sh "/home/gonzalo/.local/share/Trash/files/test.0/drive_c/WTF" 2>/dev/null
```

Si `Data` pesa varios GB (deberia rondar los 8-16 GB segun el idioma/parches), esta completo. Si existe,
lo sacamos de la papelera a una carpeta normal, por ejemplo:

```bash
mkdir -p ~/Games/WoWPatagonia
mv "/home/gonzalo/.local/share/Trash/files/test.0/drive_c/"* ~/Games/WoWPatagonia/
```

Esa carpeta (`~/Games/WoWPatagonia` en este ejemplo) es la que despues traducis a formato Windows para
que el launcher la reconozca: si el prefix que usa Lutris para este juego mapea tu carpeta de Linux
como una unidad (revisa la configuracion del prefix en Lutris, seccion "Unidades" / "Drives"), o
simplemente copiala DENTRO del prefix directamente:

```bash
mkdir -p "<prefix>/drive_c/WoWPatagonia"
mv ~/Games/WoWPatagonia/* "<prefix>/drive_c/WoWPatagonia/"
```

Y en el selector de carpetas del launcher elegis `C:\WoWPatagonia`.

Pegame el resultado del primer `ls` antes de mover nada, para confirmar que esta todo ahi.
