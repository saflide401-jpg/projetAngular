#!/bin/bash

# Script d'installation automatique PharmaTrack
# Usage: ./install.sh

set -e  # Arrêter en cas d'erreur

echo "🚀 Installation de PharmaTrack - Système de Gestion Pharmaceutique"
echo "=================================================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage coloré
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérification des prérequis
check_prerequisites() {
    print_status "Vérification des prérequis..."
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js n'est pas installé. Veuillez l'installer depuis https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_error "Node.js version 18+ requis. Version actuelle: $(node --version)"
        exit 1
    fi
    
    print_success "Node.js $(node --version) détecté"
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        print_error "npm n'est pas installé"
        exit 1
    fi
    
    print_success "npm $(npm --version) détecté"
}

# Installation des dépendances
install_dependencies() {
    print_status "Installation des dépendances npm..."
    
    if [ -f "package-lock.json" ]; then
        npm ci
    else
        npm install
    fi
    
    print_success "Dépendances installées avec succès"
}

# Vérification de la configuration
check_configuration() {
    print_status "Vérification de la configuration..."
    
    # Vérifier que db.json existe
    if [ ! -f "db.json" ]; then
        print_error "Fichier db.json manquant"
        exit 1
    fi
    
    # Vérifier les ports disponibles
    if lsof -Pi :4200 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 4200 déjà utilisé. L'application utilisera un autre port."
    fi
    
    if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 3001 déjà utilisé. L'API utilisera un autre port."
    fi
    
    print_success "Configuration vérifiée"
}

# Démarrage des services
start_services() {
    print_status "Démarrage des services..."
    
    # Créer un script de démarrage temporaire
    cat > start_pharmatrack.sh << 'EOF'
#!/bin/bash

echo "🚀 Démarrage de PharmaTrack..."

# Fonction pour nettoyer les processus à l'arrêt
cleanup() {
    echo "Arrêt des services..."
    kill $API_PID $ANGULAR_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

# Démarrer l'API en arrière-plan
echo "Démarrage de l'API (port 3001)..."
npx json-server --watch db.json --port 3001 > api.log 2>&1 &
API_PID=$!

# Attendre que l'API soit prête
sleep 3

# Démarrer Angular en arrière-plan
echo "Démarrage d'Angular (port 4200)..."
ng serve --host 0.0.0.0 --port 4200 > angular.log 2>&1 &
ANGULAR_PID=$!

echo "✅ Services démarrés !"
echo "📱 Application: http://localhost:4200"
echo "🔌 API: http://localhost:3001"
echo ""
echo "👥 Comptes de test:"
echo "   Admin: admin / admin123"
echo "   Vendeur: vendeur1 / vendeur123"
echo ""
echo "Appuyez sur Ctrl+C pour arrêter les services"

# Attendre les processus
wait $API_PID $ANGULAR_PID
EOF

    chmod +x start_pharmatrack.sh
    
    print_success "Script de démarrage créé: ./start_pharmatrack.sh"
}

# Affichage des informations finales
show_final_info() {
    echo ""
    echo "🎉 Installation terminée avec succès !"
    echo "====================================="
    echo ""
    echo "📋 Prochaines étapes:"
    echo "  1. Démarrer l'application: ./start_pharmatrack.sh"
    echo "  2. Ouvrir http://localhost:4200 dans votre navigateur"
    echo "  3. Se connecter avec les comptes de test"
    echo ""
    echo "👥 Comptes disponibles:"
    echo "  🔑 Administrateur: admin / admin123"
    echo "  👤 Vendeur 1: vendeur1 / vendeur123"
    echo "  👤 Vendeur 2: vendeur2 / vendeur123"
    echo ""
    echo "📚 Documentation:"
    echo "  📖 README.md - Guide complet"
    echo "  🔧 INSTALLATION.md - Guide d'installation détaillé"
    echo "  🏗️ ARCHITECTURE.md - Architecture technique"
    echo ""
    echo "🆘 En cas de problème:"
    echo "  - Consulter les logs: api.log et angular.log"
    echo "  - Vérifier les ports disponibles"
    echo "  - Relancer: ./install.sh"
    echo ""
    echo "Bon développement avec PharmaTrack ! 🚀"
}

# Fonction principale
main() {
    echo ""
    print_status "Début de l'installation..."
    
    check_prerequisites
    install_dependencies
    check_configuration
    start_services
    show_final_info
}

# Gestion des erreurs
error_handler() {
    print_error "Erreur lors de l'installation à la ligne $1"
    echo "Consultez les logs pour plus de détails."
    exit 1
}

trap 'error_handler $LINENO' ERR

# Exécution
main "$@"

