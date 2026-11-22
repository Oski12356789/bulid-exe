$ErrorActionPreference = "Stop"

function Step([string]$text) {
    Write-Host "`n=== $text ===" -ForegroundColor Cyan
}

try {
    Write-Host "AI Offline Instalator - wymaga internetu do pobrania komponentow." -ForegroundColor Green

    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw "Brak winget. Zainstaluj lub zaktualizuj App Installer w Microsoft Store i uruchom instalator ponownie."
    }

    Step "1/4 Instalowanie Visual Studio Code"
    winget install --id Microsoft.VisualStudioCode --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { Write-Warning "Instalacja VS Code zwrocila kod $LASTEXITCODE." }

    Step "2/4 Instalowanie Ollama"
    winget install --id Ollama.Ollama --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { Write-Warning "Instalacja Ollama zwrocila kod $LASTEXITCODE." }

    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

    $code = Get-Command code.cmd -ErrorAction SilentlyContinue
    if (-not $code) {
        $paths = @("$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd", "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd")
        foreach ($p in $paths) { if (Test-Path $p) { $code = [pscustomobject]@{ Source = $p }; break } }
    }
    if (-not $code) { throw "Nie znaleziono polecenia code. Uruchom ponownie komputer i kliknij skrót konfiguracji na pulpicie." }

    Step "3/4 Instalowanie rozszerzenia Cline"
    & $code.Source --install-extension cline.cline --force
    if ($LASTEXITCODE -ne 0) { Write-Warning "Nie udalo sie zainstalowac Cline automatycznie. W VS Code wyszukaj rozszerzenie Cline." }

    $ollamaCmd = Get-Command ollama.exe -ErrorAction SilentlyContinue
    $ollama = if ($ollamaCmd) { $ollamaCmd.Source } else { $null }
    if (-not $ollama) {
        $paths = @("$env:LOCALAPPDATA\Programs\Ollama\ollama.exe", "$env:ProgramFiles\Ollama\ollama.exe")
        foreach ($p in $paths) { if (Test-Path $p) { $ollama = $p; break } }
    }
    if (-not $ollama) { throw "Nie znaleziono ollama.exe. Uruchom ponownie komputer i ponownie uruchom konfiguracje." }

    Step "4/4 Uruchamianie Ollama i pobieranie modelu"
    try { Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 3 | Out-Null }
    catch { Start-Process -FilePath $ollama -ArgumentList "serve" -WindowStyle Hidden; Start-Sleep -Seconds 8 }

    & $ollama pull qwen2.5-coder:7b
    if ($LASTEXITCODE -ne 0) { throw "Pobieranie modelu nie powiodlo sie. Sprawdz internet i uruchom konfiguracje ponownie." }

    Write-Host "`nGOTOWE! W VS Code otworz Cline i ustaw:" -ForegroundColor Green
    Write-Host "Provider: Ollama"
    Write-Host "Base URL: http://localhost:11434"
    Write-Host "Model: qwen2.5-coder:7b"
    Read-Host "Nacisnij Enter, aby zamknac"
}
catch {
    Write-Host "`nBLAD: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Nacisnij Enter, aby zamknac"
    exit 1
}
