param([switch]$NoBuild)
$ErrorActionPreference = 'Stop'
if (-not $NoBuild) { & (Join-Path $PSScriptRoot 'build.ps1') }
$version = ([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'VERSION'))).Trim()
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw 'VERSION must be a numeric major.minor.patch version.' }
$dist = Join-Path $PSScriptRoot 'dist'
New-Item -ItemType Directory -Path $dist -Force | Out-Null
$stage = Join-Path $dist ('.stage-' + [guid]::NewGuid().ToString('N'))
$bundle = Join-Path $stage 'codex-glass-vibecoding'
New-Item -ItemType Directory -Path $bundle -Force | Out-Null
try {
    $app = Join-Path $PSScriptRoot 'app'
    $files = @('codex-glass-vibecoding.exe','Glass.xaml','VibrancyBlur.ps','LiquidLens.ps','一键启动.vbs','README.md','LICENSE','NOTICE','LiquidGlass.NOTICE','LiquidGlass.LICENSE')
    foreach ($name in $files) { Copy-Item -LiteralPath (Join-Path $app $name) -Destination $bundle -Force }
    New-Item -ItemType Directory -Path (Join-Path $bundle 'docs') -Force | Out-Null
    foreach ($name in @('preview.png','details.png')) { Copy-Item -LiteralPath (Join-Path $app ('docs\' + $name)) -Destination (Join-Path $bundle 'docs') -Force }
    $zip = Join-Path $dist ('codex-glass-vibecoding-v' + $version + '-win-x64.zip')
    Compress-Archive -LiteralPath $bundle -DestinationPath $zip -Force
    $hash = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
    [IO.File]::WriteAllText((Join-Path $dist 'SHA256SUMS.txt'),$hash + '  ' + [IO.Path]::GetFileName($zip) + [Environment]::NewLine,(New-Object Text.UTF8Encoding $false))
    Write-Output ('Packaged: ' + $zip)
} finally {
    $resolvedStage = [IO.Path]::GetFullPath($stage)
    $resolvedDist = [IO.Path]::GetFullPath($dist).TrimEnd('\') + '\'
    if (-not $resolvedStage.StartsWith($resolvedDist,[StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected staging path; cleanup cancelled.' }
    Remove-Item -LiteralPath $resolvedStage -Recurse -Force
}
