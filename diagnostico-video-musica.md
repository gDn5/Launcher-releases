# Diagnóstico: video/música no funcionan en Linux

## Próximos pasos (ronda 2 - post fix de vlc-plugins-base + ydotool)

El log de abajo (ronda 1) confirmó que `libvlc.so` carga bien pero `libvlc_new()` falla en el
lado nativo - consistente con que falten los plugins reales de VLC (`vlc-plugins-base`), no solo
la librería core (`vlc-libs`). También se confirmó que el diálogo de "remote desktop" es GNOME/
Wayland interceptando las teclas simuladas por `xdotool`.

1. Correr el instalador actualizado (ahora instala `vlc-plugins-base` y configura `ydotool`):

```bash
curl -sL https://raw.githubusercontent.com/gDn5/Launcher-releases/main/install-native-linux.sh | bash
```

Si es la primera vez, puede pedir **cerrar sesión y volver a entrar** (no alcanza con reabrir la
terminal) para que el login automático funcione - lo va a avisar explícitamente si hace falta.

2. Confirmar que los plugins de VLC quedaron instalados de verdad:

```bash
rpm -q vlc-plugins-base
find /usr/lib64/vlc/plugins -maxdepth 1 -name "*.so" | wc -l
```

3. Abrir el launcher de nuevo, probar video/música y Jugar, y si algo sigue fallando volver a
   revisar el log:

```bash
cat ~/.local/share/WowLauncher/crash.log
```

Pegar acá (o en un archivo nuevo en este repo) el resultado de los pasos 2 y/o 3.

---

## Ronda 1 (ya resuelta / usada para diagnosticar lo de arriba)

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

output primer comando:
cat ~/.local/share/WowLauncher/crash.log
==== 2026-09-17T22:56:18.7547411-03:00 (AppDomain.UnhandledException, terminating=True) ====
System.DllNotFoundException: Unable to load shared library 'libvlc' or one of its dependencies. In order to help diagnose loading problems, consider using a tool like strace. If you're using glibc, consider setting the LD_DEBUG environment variable: 
/home/gonzalo/WowPatagoniaLauncher/libvlc.so: cannot open shared object file: No such file or directory
/home/gonzalo/WowPatagoniaLauncher/liblibvlc.so: cannot open shared object file: No such file or directory
/home/gonzalo/WowPatagoniaLauncher/libvlc: cannot open shared object file: No such file or directory
/home/gonzalo/WowPatagoniaLauncher/liblibvlc: cannot open shared object file: No such file or directory

   at LibVLCSharp.Shared.Core.EnsureVersionsMatch()
   at LibVLCSharp.Shared.Core.Initialize(String libvlcDirectoryPath)
   at Launcher.App.Program.Main(String[] args) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Program.cs:line 29

==== 2026-09-17T22:58:21.6643373-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

==== 2026-09-17T23:00:12.7091182-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

==== 2026-09-18T00:38:08.3689279-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

==== 2026-09-18T10:10:42.8404190-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

==== 2026-09-18T10:20:18.6807695-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

==== 2026-09-18T10:43:28.2836913-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

==== 2026-09-18T10:44:54.6245494-03:00 (TaskScheduler.UnobservedTaskException, terminating=False) ====
System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. (Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project)
 ---> LibVLCSharp.Shared.VLCException: Failed to perform instanciation on the native side. Make sure you installed the correct VideoLAN.LibVLC.[YourPlatform] package in your platform specific project
   at LibVLCSharp.Shared.Internal.OnNativeInstanciationError()
   at LibVLCSharp.Shared.Internal..ctor(Func`1 create, Action`1 release)
   at LibVLCSharp.Shared.LibVLC..ctor(String[] options)
   at Launcher.App.Views.MainWindow.<>c__DisplayClass19_0.<OnWindowOpened>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Views\MainWindow.axaml.cs:line 146
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
   --- End of inner exception stack trace ---

gonzalo@fedora:~/WowPatagoniaLauncher$ 

al abrir el launcher nuevo por terminal,jugar y cerrar el juego no dice nada mas que esto:
./WowLauncher
002c:fixme:winediag:loader_init wine-staging 11.0 is a testing version containing experimental patches.
002c:fixme:winediag:loader_init Please mention your exact version when filing bug reports on winehq.org.
0024:fixme:winediag:loader_init wine-staging 11.0 is a testing version containing experimental patches.
0024:fixme:winediag:loader_init Please mention your exact version when filing bug reports on winehq.org.
0128:fixme:ntdll:NtQuerySystemInformation info_class SYSTEM_PERFORMANCE_INFORMATION
0130:fixme:d3d:state_linepattern_w Setting line patterns is not supported in OpenGL core contexts.
0188:fixme:winediag:loader_init wine-staging 11.0 is a testing version containing experimental patches.
0188:fixme:winediag:loader_init Please mention your exact version when filing bug reports on winehq.org.
0194:fixme:winediag:loader_init wine-staging 11.0 is a testing version containing experimental patches.
0194:fixme:winediag:loader_init Please mention your exact version when filing bug reports on winehq.org.

VERIFICA PORQUE CUANDO LE DOY A JUGAR, me abre una ventana de permitir conexion de remote desktop y tiene un switch de 
"allow remote interaction"


