$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 4172
$python = Get-Command py -ErrorAction SilentlyContinue
if ($python) {
    $pythonArgs = @('-3', '-m', 'http.server', "$port", '--directory', $root)
    $server = Start-Process -FilePath $python.Source -ArgumentList $pythonArgs -WorkingDirectory $root -PassThru
} else {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python) { throw 'Python 3 is required. Install Python from python.org and run this file again.' }
    $server = Start-Process -FilePath $python.Source -ArgumentList @('-m', 'http.server', "$port", '--directory', $root) -WorkingDirectory $root -PassThru
}

try {
    Start-Sleep -Milliseconds 500
    Start-Process "http://127.0.0.1:$port/"
    Write-Host "RealExecutor Frontend 2.7.2: http://127.0.0.1:$port/"
    Write-Host 'Press Ctrl+C to stop the local server.'
    Wait-Process -Id $server.Id
} finally {
    if ($server -and -not $server.HasExited) { Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue }
}
