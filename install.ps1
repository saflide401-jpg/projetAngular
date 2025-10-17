# Script d'installation PowerShell pour PharmaTrack
# Usage: .\install.ps1

param(
    [switch]$SkipPrerequisites = $false
)

# Configuration des couleurs
$Host.UI.RawUI.ForegroundColor = "White"

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Test-Prerequisites {
    Write-Status "Vérification des prérequis..."
    
    # Vérifier Node.js
    try {
        $nodeVersion = node --version
        $versionNumber = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
        
        if ($versionNumber -lt 18) {
            Write-Error "Node.js version 18+ requis. Version actuelle: $nodeVersion"
            Write-Host "Téléchargez Node.js depuis: https://nodejs.org/" -ForegroundColor Cyan
            exit 1
        }
        
        Write-Success "Node.js $nodeVersion détecté"
    }
    catch {
        Write-Error "Node.js n'est pas installé ou non accessible"
        Write-Host "Téléchargez Node.js depuis: https://nodejs.org/" -ForegroundColor Cyan
        exit 1
    }
    
    # Vérifier npm
    try {
        $npmVersion = npm --version
        Write-Success "npm $npmVersion détecté"
    }
    catch {
        Write-Error "npm n'est pas installé ou non accessible"
        exit 1
    }
}

function Install-Dependencies {
    Write-Status "Installation des dépendances npm..."
    
    try {
        if (Test-Path "package-lock.json") {
            npm ci
        } else {
            npm install
        }
        Write-Success "Dépendances installées avec succès"
    }
    catch {
        Write-Error "Erreur lors de l'installation des dépendances"
        exit 1
    }
}

function Test-Configuration {
    Write-Status "Vérification de la configuration..."
    
    # Vérifier db.json
    if (-not (Test-Path "db.json")) {
        Write-Error "Fichier db.json manquant"
        exit 1
    }
    
    # Vérifier les ports (Windows)
    $port4200 = Get-NetTCPConnection -LocalPort 4200 -ErrorAction SilentlyContinue
    if ($port4200) {
        Write-Warning "Port 4200 déjà utilisé. L'application utilisera un autre port."
    }
    
    $port3001 = Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue
    if ($port3001) {
        Write-Warning "Port 3001 déjà utilisé. L'API utilisera un autre port."
    }
    
    Write-Success "Configuration vérifiée"
}

function New-StartupScript {
    Write-Status "Création du script de démarrage..."
    
    $startScript = @'
@echo off
echo 🚀 Démarrage de PharmaTrack...
echo.

echo Démarrage de l'API (port 3001)...
start /B npx json-server --watch db.json --port 3001 > api.log 2>&1

timeout /t 3 /nobreak > nul

echo Démarrage d'Angular (port 4200)...
start /B ng serve --host 0.0.0.0 --port 4200 > angular.log 2>&1

echo.
echo ✅ Services démarrés !
echo 📱 Application: http://localhost:4200
echo 🔌 API: http://localhost:3001
echo.
echo 👥 Comptes de test:
echo    Admin: admin / admin123
echo    Vendeur: vendeur1 / vendeur123
echo.
echo Appuyez sur une touche pour arrêter les services...
pause > nul

echo Arrêt des services...
taskkill /F /IM node.exe > nul 2>&1
echo Services arrêtés.
'@

    $startScript | Out-File -FilePath "start_pharmatrack.bat" -Encoding ASCII
    
    Write-Success "Script de démarrage créé: start_pharmatrack.bat"
}

function Show-FinalInfo {
    Write-Host ""
    Write-Host "🎉 Installation terminée avec succès !" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Prochaines étapes:" -ForegroundColor Cyan
    Write-Host "  1. Démarrer l'application: .\start_pharmatrack.bat" -ForegroundColor White
    Write-Host "  2. Ouvrir http://localhost:4200 dans votre navigateur" -ForegroundColor White
    Write-Host "  3. Se connecter avec les comptes de test" -ForegroundColor White
    Write-Host ""
    Write-Host "👥 Comptes disponibles:" -ForegroundColor Cyan
    Write-Host "  🔑 Administrateur: admin / admin123" -ForegroundColor White
    Write-Host "  👤 Vendeur 1: vendeur1 / vendeur123" -ForegroundColor White
    Write-Host "  👤 Vendeur 2: vendeur2 / vendeur123" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 Documentation:" -ForegroundColor Cyan
    Write-Host "  📖 README.md - Guide complet" -ForegroundColor White
    Write-Host "  🔧 INSTALLATION.md - Guide d'installation détaillé" -ForegroundColor White
    Write-Host "  🏗️ ARCHITECTURE.md - Architecture technique" -ForegroundColor White
    Write-Host ""
    Write-Host "🆘 En cas de problème:" -ForegroundColor Cyan
    Write-Host "  - Consulter les logs: api.log et angular.log" -ForegroundColor White
    Write-Host "  - Vérifier les ports disponibles" -ForegroundColor White
    Write-Host "  - Relancer: .\install.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "Bon développement avec PharmaTrack ! 🚀" -ForegroundColor Green
}

# Fonction principale
function Main {
    Write-Host ""
    Write-Host "🚀 Installation de PharmaTrack - Système de Gestion Pharmaceutique" -ForegroundColor Green
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host ""
    
    Write-Status "Début de l'installation..."
    
    if (-not $SkipPrerequisites) {
        Test-Prerequisites
    }
    
    Install-Dependencies
    Test-Configuration
    New-StartupScript
    Show-FinalInfo
}

# Gestion des erreurs
trap {
    Write-Error "Erreur lors de l'installation: $_"
    Write-Host "Consultez les logs pour plus de détails." -ForegroundColor Yellow
    exit 1
}

# Exécution
try {
    Main
}
catch {
    Write-Error "Erreur fatale: $_"
    exit 1
}

