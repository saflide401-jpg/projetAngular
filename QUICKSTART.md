# 🚀 Démarrage Rapide PharmaTrack

## Installation Express (5 minutes)

### 1. Prérequis
- ✅ Node.js 18+ installé
- ✅ npm disponible

### 2. Installation Automatique

**Linux/Mac :**
```bash
./install.sh
```

**Windows :**
```powershell
.\install.ps1
```

### 3. Démarrage

**Linux/Mac :**
```bash
./start_pharmatrack.sh
```

**Windows :**
```batch
start_pharmatrack.bat
```

### 4. Accès
- 🌐 **Application** : http://localhost:4200
- 🔌 **API** : http://localhost:3001

## 👥 Comptes de Test

| Rôle | Utilisateur | Mot de passe | Accès |
|------|-------------|--------------|-------|
| 👨‍💼 Admin | `admin` | `admin123` | Complet |
| 👩‍💼 Vendeur | `vendeur1` | `vendeur123` | Ventes |
| 👨‍💼 Vendeur | `vendeur2` | `vendeur123` | Ventes |

## 🎯 Test Rapide

1. **Connexion** : Utilisez `admin` / `admin123`
2. **Dashboard** : Consultez les statistiques
3. **Alertes** : Vérifiez les médicaments en rupture
4. **Navigation** : Testez le menu responsive

## 📱 Fonctionnalités Disponibles

- ✅ **Authentification** sécurisée
- ✅ **Dashboard** avec statistiques
- ✅ **Alertes** de stock automatiques
- ✅ **Navigation** adaptée aux rôles
- ✅ **Interface** responsive

## 🔧 Commandes Utiles

```bash
# Démarrage séparé
npm run api          # API seulement
npm start            # Angular seulement
npm run dev          # Les deux ensemble

# Build
npm run build        # Production

# Nettoyage
rm -rf node_modules  # Nettoyer
npm install          # Réinstaller
```

## 🐛 Problèmes Courants

**Port occupé :**
```bash
# Changer le port Angular
ng serve --port 4201

# Changer le port API  
json-server --watch db.json --port 3002
```

**Erreur de compilation :**
```bash
rm -rf node_modules package-lock.json
npm install
```

## 📚 Documentation Complète

- 📖 **README.md** - Guide complet
- 🔧 **INSTALLATION.md** - Installation détaillée  
- 🏗️ **ARCHITECTURE.md** - Architecture technique

---

**Prêt en 5 minutes ! 🎉**

