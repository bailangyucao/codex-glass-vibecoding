Set shell = CreateObject("WScript.Shell")
Set fs = CreateObject("Scripting.FileSystemObject")
folder = fs.GetParentFolderName(WScript.ScriptFullName)
If Not fs.FileExists(folder & "\codex-glass-vibecoding.exe") Then folder = folder & "\app"
If Not fs.FileExists(folder & "\codex-glass-vibecoding.exe") Then
  MsgBox "Please download and extract the Windows release ZIP first, or run build.ps1 to build from source.", 48, "codex-glass-vibecoding"
  WScript.Quit 1
End If
shell.CurrentDirectory = folder
shell.Run Chr(34) & folder & "\codex-glass-vibecoding.exe" & Chr(34), 1, False
