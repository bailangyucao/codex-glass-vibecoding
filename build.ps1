$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'src'
$app = Join-Path $PSScriptRoot 'app'
$framework = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319'
if (-not (Test-Path -LiteralPath (Join-Path $framework 'csc.exe'))) { throw 'Windows x64 with .NET Framework is required.' }
New-Item -ItemType Directory -Path $app -Force | Out-Null
$refs = @('System.dll','System.Core.dll','System.Web.Extensions.dll','System.Drawing.dll','System.Windows.Forms.dll','WPF\WindowsBase.dll','WPF\PresentationCore.dll','WPF\PresentationFramework.dll','System.Xaml.dll') | ForEach-Object { '/reference:' + (Join-Path $framework $_) }
& (Join-Path $source 'compile-shaders.ps1') -OutputDirectory $app
$sources = @('CodexGlass.cs','LiquidGlass.cs','Themes.cs','Dashboard.cs','Inspector.cs') | ForEach-Object { Join-Path $source $_ }
& (Join-Path $framework 'csc.exe') /nologo /target:winexe /platform:x64 /optimize+ /utf8output ('/win32manifest:' + (Join-Path $source 'app.manifest')) ('/win32icon:' + (Join-Path $source 'App.ico')) ('/out:' + (Join-Path $app 'codex-glass-vibecoding.exe')) @refs @sources
if ($LASTEXITCODE -ne 0) { throw 'Build failed. Close the running floating window before rebuilding.' }
Copy-Item -LiteralPath (Join-Path $source 'Glass.xaml') -Destination $app -Force
foreach ($name in @('README.md','LICENSE','NOTICE','LiquidGlass.NOTICE','LiquidGlass.LICENSE','一键启动.vbs')) { Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination $app -Force }
New-Item -ItemType Directory -Path (Join-Path $app 'docs') -Force | Out-Null
foreach ($name in @('preview.png','details.png')) { Copy-Item -LiteralPath (Join-Path $PSScriptRoot ('docs\' + $name)) -Destination (Join-Path $app 'docs') -Force }
Write-Output ('Built: ' + (Join-Path $app 'codex-glass-vibecoding.exe'))
