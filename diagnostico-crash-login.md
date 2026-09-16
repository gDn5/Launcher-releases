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


---------------------------------------------------------------------------------------------------
output
gonzalo@fedora:~$ find ~ -iname "crash.log" 2>/dev/null -exec echo "=== {} ===" \; -exec cat {} \;
=== /home/gonzalo/Games/launcher/drive_c/users/steamuser/AppData/Local/WowLauncher/crash.log ===
==== 2026-09-16T19:30:16.5854824-03:00 (AppDomain.UnhandledException, terminating=True) ====
System.ArgumentException: The path is empty. (Parameter 'path')
   at System.IO.Path.GetFullPath(String path)
   at Launcher.Core.Util.SafePath.Combine(String rootDirectory, String untrustedRelativePath) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.Core\Util\SafePath.cs:line 19
   at Launcher.Core.Services.OptionalPatchService.<>c__DisplayClass11_0.<VerifyInstalledAsync>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.Core\Services\OptionalPatchService.cs:line 125
   at System.Threading.Tasks.Task`1.InnerInvoke()
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Launcher.App.ViewModels.MainWindowViewModel.VerifyInstalledPatchesAsync() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 986
   at Launcher.App.ViewModels.MainWindowViewModel.RefreshPlayabilityAsync(CancellationToken cancellationToken) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 1828
   at Launcher.App.ViewModels.MainWindowViewModel.ConfirmLoginAsync() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 283
   at CommunityToolkit.Mvvm.Input.AsyncRelayCommand.AwaitAndThrowIfFailed(Task executionTask) in /_/src/CommunityToolkit.Mvvm/Input/AsyncRelayCommand.cs:line 351
   at System.Threading.Tasks.Task.<>c.<ThrowAsync>b__124_0(Object state)
   at Avalonia.Threading.SendOrPostCallbackDispatcherOperation.InvokeCore()
   at Avalonia.Threading.CulturePreservingExecutionContext.CallbackWrapper(Object obj)
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
   at Avalonia.Threading.DispatcherOperation.Execute()
   at Avalonia.Threading.Dispatcher.ExecuteJobsCore(Boolean fromExplicitBackgroundProcessingCallback)
   at Avalonia.Win32.Win32Platform.WndProc(IntPtr hWnd, UInt32 msg, IntPtr wParam, IntPtr lParam)
   at Avalonia.Win32.Interop.UnmanagedMethods.DispatchMessage(MSG& lpmsg)
   at Avalonia.Win32.Win32DispatcherImpl.RunLoop(CancellationToken cancellationToken)
   at Avalonia.Threading.DispatcherFrame.Run(IControlledDispatcherImpl impl)
   at Avalonia.Threading.Dispatcher.PushFrame(DispatcherFrame frame)
   at Avalonia.Threading.Dispatcher.MainLoop(CancellationToken cancellationToken)
   at Avalonia.Controls.ApplicationLifetimes.ClassicDesktopStyleApplicationLifetime.StartCore(String[] args)
   at Launcher.App.Program.Main(String[] args) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Program.cs:line 26

=== /home/gonzalo/.wine/drive_c/users/gonzalo/AppData/Local/WowLauncher/crash.log ===
==== 2026-09-16T19:16:50.2162477-03:00 (AppDomain.UnhandledException, terminating=True) ====
System.ArgumentException: The path is empty. (Parameter 'path')
   at System.IO.Path.GetFullPath(String path)
   at Launcher.Core.Util.SafePath.Combine(String rootDirectory, String untrustedRelativePath) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.Core\Util\SafePath.cs:line 19
   at Launcher.Core.Services.OptionalPatchService.<>c__DisplayClass11_0.<VerifyInstalledAsync>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.Core\Services\OptionalPatchService.cs:line 125
   at System.Threading.Tasks.Task`1.InnerInvoke()
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Launcher.App.ViewModels.MainWindowViewModel.VerifyInstalledPatchesAsync() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 986
   at Launcher.App.ViewModels.MainWindowViewModel.RefreshPlayabilityAsync(CancellationToken cancellationToken) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 1828
   at Launcher.App.ViewModels.MainWindowViewModel.ConfirmLoginAsync() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 283
   at CommunityToolkit.Mvvm.Input.AsyncRelayCommand.AwaitAndThrowIfFailed(Task executionTask) in /_/src/CommunityToolkit.Mvvm/Input/AsyncRelayCommand.cs:line 351
   at System.Threading.Tasks.Task.<>c.<ThrowAsync>b__124_0(Object state)
   at Avalonia.Threading.SendOrPostCallbackDispatcherOperation.InvokeCore()
   at Avalonia.Threading.CulturePreservingExecutionContext.CallbackWrapper(Object obj)
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
   at Avalonia.Threading.DispatcherOperation.Execute()
   at Avalonia.Threading.Dispatcher.ExecuteJobsCore(Boolean fromExplicitBackgroundProcessingCallback)
   at Avalonia.Win32.Win32Platform.WndProc(IntPtr hWnd, UInt32 msg, IntPtr wParam, IntPtr lParam)
   at Avalonia.Win32.Interop.UnmanagedMethods.DispatchMessage(MSG& lpmsg)
   at Avalonia.Win32.Win32DispatcherImpl.RunLoop(CancellationToken cancellationToken)
   at Avalonia.Threading.DispatcherFrame.Run(IControlledDispatcherImpl impl)
   at Avalonia.Threading.Dispatcher.PushFrame(DispatcherFrame frame)
   at Avalonia.Threading.Dispatcher.MainLoop(CancellationToken cancellationToken)
   at Avalonia.Controls.ApplicationLifetimes.ClassicDesktopStyleApplicationLifetime.StartCore(String[] args)
   at Launcher.App.Program.Main(String[] args) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Program.cs:line 26

==== 2026-09-16T19:18:58.8190025-03:00 (AppDomain.UnhandledException, terminating=True) ====
System.ArgumentException: The path is empty. (Parameter 'path')
   at System.IO.Path.GetFullPath(String path)
   at Launcher.Core.Util.SafePath.Combine(String rootDirectory, String untrustedRelativePath) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.Core\Util\SafePath.cs:line 19
   at Launcher.Core.Services.OptionalPatchService.<>c__DisplayClass11_0.<VerifyInstalledAsync>b__0() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.Core\Services\OptionalPatchService.cs:line 125
   at System.Threading.Tasks.Task`1.InnerInvoke()
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Launcher.App.ViewModels.MainWindowViewModel.VerifyInstalledPatchesAsync() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 986
   at Launcher.App.ViewModels.MainWindowViewModel.RefreshPlayabilityAsync(CancellationToken cancellationToken) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 1828
   at Launcher.App.ViewModels.MainWindowViewModel.ConfirmLoginAsync() in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\ViewModels\MainWindowViewModel.cs:line 283
   at CommunityToolkit.Mvvm.Input.AsyncRelayCommand.AwaitAndThrowIfFailed(Task executionTask) in /_/src/CommunityToolkit.Mvvm/Input/AsyncRelayCommand.cs:line 351
   at System.Threading.Tasks.Task.<>c.<ThrowAsync>b__124_0(Object state)
   at Avalonia.Threading.SendOrPostCallbackDispatcherOperation.InvokeCore()
   at Avalonia.Threading.CulturePreservingExecutionContext.CallbackWrapper(Object obj)
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
   at Avalonia.Threading.DispatcherOperation.Execute()
   at Avalonia.Threading.Dispatcher.ExecuteJobsCore(Boolean fromExplicitBackgroundProcessingCallback)
   at Avalonia.Win32.Win32Platform.WndProc(IntPtr hWnd, UInt32 msg, IntPtr wParam, IntPtr lParam)
   at Avalonia.Win32.Interop.UnmanagedMethods.DispatchMessage(MSG& lpmsg)
   at Avalonia.Win32.Win32DispatcherImpl.RunLoop(CancellationToken cancellationToken)
   at Avalonia.Threading.DispatcherFrame.Run(IControlledDispatcherImpl impl)
   at Avalonia.Threading.Dispatcher.PushFrame(DispatcherFrame frame)
   at Avalonia.Threading.Dispatcher.MainLoop(CancellationToken cancellationToken)
   at Avalonia.Controls.ApplicationLifetimes.ClassicDesktopStyleApplicationLifetime.StartCore(String[] args)
   at Launcher.App.Program.Main(String[] args) in C:\Users\Gonzalo\Documents\GitHub\Launcher\src\Launcher.App\Program.cs:line 26
