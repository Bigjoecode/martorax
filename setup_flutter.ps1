# Flutter Setup Script for Windows
# Run this in PowerShell as Administrator

$ErrorActionPreference = "Stop"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Flutter Development Environment Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# --- Config ---
$FlutterInstallDir = "C:\src"
$FlutterDir        = "$FlutterInstallDir\flutter"
$FlutterZipUrl     = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.32.1-stable.zip"
$FlutterZip        = "$env:TEMP\flutter_stable.zip"
$AndroidSdkPath    = "$env:LOCALAPPDATA\Android\Sdk"

# --- Step 1: Create install directory ---
Write-Host "[1/6] Creating install directory at $FlutterInstallDir..." -ForegroundColor Yellow
if (-not (Test-Path $FlutterInstallDir)) {
    New-Item -ItemType Directory -Force -Path $FlutterInstallDir | Out-Null
}
Write-Host "      Done." -ForegroundColor Green

# --- Step 2: Download Flutter SDK ---
if (Test-Path $FlutterDir) {
    Write-Host "[2/6] Flutter SDK already found at $FlutterDir. Skipping download." -ForegroundColor Green
} else {
    Write-Host "[2/6] Downloading Flutter SDK (~700MB). This may take a few minutes..." -ForegroundColor Yellow
    Write-Host "      Source: $FlutterZipUrl" -ForegroundColor DarkGray
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'  # speeds up Invoke-WebRequest significantly
    Invoke-WebRequest -Uri $FlutterZipUrl -OutFile $FlutterZip -UseBasicParsing
    $ProgressPreference = 'Continue'
    Write-Host "      Download complete." -ForegroundColor Green

    # --- Step 3: Extract Flutter SDK ---
    Write-Host "[3/6] Extracting Flutter SDK to $FlutterInstallDir..." -ForegroundColor Yellow
    Expand-Archive -Path $FlutterZip -DestinationPath $FlutterInstallDir -Force
    Remove-Item $FlutterZip -Force
    Write-Host "      Extraction complete." -ForegroundColor Green
}

# --- Step 4: Set environment variables (User scope — no Admin needed) ---
Write-Host "[4/6] Configuring environment variables..." -ForegroundColor Yellow

$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
$flutterBin  = "$FlutterDir\bin"

if ($currentPath -notlike "*$flutterBin*") {
    [System.Environment]::SetEnvironmentVariable("PATH", "$flutterBin;$currentPath", "User")
    Write-Host "      Added Flutter\bin to user PATH." -ForegroundColor Green
} else {
    Write-Host "      Flutter\bin already in PATH." -ForegroundColor Green
}

if (-not [System.Environment]::GetEnvironmentVariable("ANDROID_HOME", "User")) {
    [System.Environment]::SetEnvironmentVariable("ANDROID_HOME", $AndroidSdkPath, "User")
    Write-Host "      Set ANDROID_HOME = $AndroidSdkPath" -ForegroundColor Green
} else {
    Write-Host "      ANDROID_HOME already set." -ForegroundColor Green
}

# Refresh current session PATH so flutter commands work immediately
$env:PATH = "$flutterBin;$env:PATH"
$env:ANDROID_HOME = $AndroidSdkPath

Write-Host "      Done." -ForegroundColor Green

# --- Step 5: Accept Android licenses ---
Write-Host "[5/6] Accepting Android SDK licenses..." -ForegroundColor Yellow
Write-Host "      (You may need to press 'y' and Enter several times)" -ForegroundColor DarkGray
try {
    & "$FlutterDir\bin\flutter.bat" doctor --android-licenses
} catch {
    Write-Host "      Could not auto-accept licenses. Run manually: flutter doctor --android-licenses" -ForegroundColor Red
}

# --- Step 6: Run flutter doctor ---
Write-Host "`n[6/6] Running flutter doctor..." -ForegroundColor Yellow
& "$FlutterDir\bin\flutter.bat" doctor

# --- Done ---
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host @"

Next steps:
  1. RESTART your terminal / VSCode so the new PATH takes effect
  2. Install VSCode extensions (run these in a new terminal):
       code --install-extension Dart-Code.flutter
       code --install-extension Dart-Code.dart-code
  3. Create your first project (in this folder):
       flutter create my_app
       cd my_app
       flutter run

  Run 'flutter doctor' anytime to check your setup status.
"@ -ForegroundColor White