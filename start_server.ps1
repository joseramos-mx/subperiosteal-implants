# MONAI Label Server - Launcher
# Uso: .\start_server.ps1 [-Studies "ruta\a\imagenes"] [-Models "segmentation"] [-Port 8000]

param(
    [string]$Studies = "E:\imagenes-medicas",
    [string]$Models  = "segmentation",
    [int]$Port       = 8000
)

$PYTHON   = "E:\monailabel-env-310\Scripts\python.exe"
$APP      = "E:\monailabel-apps\radiology"
$LOGFILE  = "$PSScriptRoot\monailabel_server.log"

if (-not (Test-Path $Studies)) {
    Write-Host ""
    Write-Host "AVISO: La carpeta de imagenes no existe: $Studies"
    Write-Host "Creala o pasa la ruta correcta con -Studies 'C:\tu\ruta'"
    Write-Host ""
    $respuesta = Read-Host "Crear la carpeta ahora? (s/n)"
    if ($respuesta -eq "s") {
        New-Item -ItemType Directory -Force $Studies | Out-Null
        Write-Host "Carpeta creada: $Studies"
    } else {
        exit 1
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "  MONAI Label Server"
Write-Host "=========================================="
Write-Host "  App:        $APP"
Write-Host "  Imagenes:   $Studies"
Write-Host "  Modelos:    $Models"
Write-Host "  Puerto:     $Port"
Write-Host "  URL:        http://localhost:$Port"
Write-Host "  Log:        $LOGFILE"
Write-Host "=========================================="
Write-Host ""
Write-Host "Conecta 3D Slicer -> Extension MONAI Label -> Server: http://localhost:$Port"
Write-Host ""
Write-Host "Presiona Ctrl+C para detener el servidor."
Write-Host ""

$env:PIP_CACHE_DIR = "E:\pip-cache"
$env:TEMP          = "E:\tmp"
$env:TMP           = "E:\tmp"

& $PYTHON -m monailabel.main start_server `
    --app    $APP     `
    --studies $Studies `
    --conf   models $Models `
    --port   $Port `
    2>&1 | Tee-Object -FilePath $LOGFILE
