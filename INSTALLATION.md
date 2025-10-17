# Guide d'Installation PharmaTrack

## 📋 Prérequis Système

### Logiciels Requis

1. **Node.js** (version 18.0 ou supérieure)
   - Télécharger depuis : https://nodejs.org/
   - Vérifier l'installation : `node --version`

2. **npm** (inclus avec Node.js)
   - Vérifier l'installation : `npm --version`

3. **Git** (optionnel, pour le clonage)
   - Télécharger depuis : https://git-scm.com/

### Configuration Système Recommandée

- **RAM** : 4 GB minimum, 8 GB recommandé
- **Espace disque** : 500 MB pour le projet + dépendances
- **Navigateur** : Chrome, Firefox, Safari, Edge (versions récentes)

## 🚀 Installation Rapide

### Étape 1 : Télécharger le Projet

**Option A : Téléchargement direct**
1. Télécharger l'archive ZIP du projet
2. Extraire dans le dossier de votre choix
3. Ouvrir un terminal dans le dossier `pharma-track`

**Option B : Clonage Git**
```bash
git clone <url-du-repository>
cd pharma-track
```

### Étape 2 : Installation des Dépendances

```bash
# Installer toutes les dépendances
npm install
```

Cette commande va installer :
- Angular CLI et framework
- Bootstrap pour le design
- FontAwesome pour les icônes
- Chart.js pour les graphiques
- JSON Server pour l'API mock
- Toutes les autres dépendances

### Étape 3 : Démarrage de l'Application

**Méthode recommandée (tout en un) :**
```bash
npm run dev
```

**Méthode alternative (séparée) :**
```bash
# Terminal 1 - API Backend
npm run api

# Terminal 2 - Frontend Angular
npm start
```

### Étape 4 : Accès à l'Application

1. Ouvrir votre navigateur
2. Aller à : http://localhost:4200
3. Utiliser les comptes de test (voir section Comptes)

## 🔧 Configuration Détaillée

### Ports Utilisés

- **Frontend Angular** : 4200
- **API JSON Server** : 3001

### Modification des Ports

Si les ports par défaut sont occupés :

**Changer le port Angular :**
```bash
ng serve --port 4201
```

**Changer le port API :**
```bash
json-server --watch db.json --port 3002
```

Puis modifier les URLs dans les services Angular :
```typescript
// src/app/services/*.service.ts
private readonly API_URL = 'http://localhost:3002/endpoint';
```

### Variables d'Environnement

Créer un fichier `.env` (optionnel) :
```env
API_URL=http://localhost:3001
APP_PORT=4200
```

## 👥 Comptes de Test

### Administrateur
- **Utilisateur** : `admin`
- **Mot de passe** : `admin123`
- **Accès** : Toutes les fonctionnalités

### Vendeurs
- **Utilisateur** : `vendeur1` ou `vendeur2`
- **Mot de passe** : `vendeur123`
- **Accès** : Ventes et consultation

## 🗂️ Structure des Données

### Base de Données Mock (db.json)

Le fichier `db.json` contient les données de démonstration :

```json
{
  "medicines": [...],  // 5 médicaments
  "sales": [...],      // 5 ventes d'exemple
  "users": [...]       // 3 utilisateurs
}
```

### Réinitialisation des Données

Pour restaurer les données d'origine :
```bash
git checkout db.json
```

Ou remplacer le contenu de `db.json` avec les données initiales.

## 🛠️ Commandes Utiles

### Développement
```bash
npm start           # Démarrer Angular
npm run api         # Démarrer l'API
npm run dev         # Démarrer tout
```

### Build et Production
```bash
npm run build       # Build de développement
npm run build:prod  # Build de production
```

### Maintenance
```bash
npm install         # Installer/mettre à jour les dépendances
npm update          # Mettre à jour les packages
npm audit fix       # Corriger les vulnérabilités
```

### Nettoyage
```bash
# Nettoyer complètement
rm -rf node_modules package-lock.json
npm install
```

## 🐛 Résolution de Problèmes

### Problème : "Port already in use"

**Solution :**
```bash
# Trouver le processus utilisant le port
lsof -i :4200
# ou
netstat -tulpn | grep :4200

# Tuer le processus
kill -9 <PID>

# Ou utiliser un autre port
ng serve --port 4201
```

### Problème : "Cannot find module"

**Solution :**
```bash
# Réinstaller les dépendances
rm -rf node_modules
npm install
```

### Problème : "API not responding"

**Vérifications :**
1. JSON Server est-il démarré ?
   ```bash
   curl http://localhost:3001/medicines
   ```

2. Le port est-il correct dans les services ?
3. Y a-t-il des erreurs dans la console ?

### Problème : "Build failed"

**Solutions :**
1. Vérifier la version de Node.js
2. Nettoyer le cache npm :
   ```bash
   npm cache clean --force
   ```
3. Réinstaller Angular CLI :
   ```bash
   npm uninstall -g @angular/cli
   npm install -g @angular/cli@latest
   ```

## 🔒 Configuration de Sécurité

### Développement Local

L'application utilise :
- Authentification simulée (tokens factices)
- Données stockées en localStorage
- API mock sans authentification

### Préparation Production

Pour un déploiement en production :

1. **Backend réel** : Remplacer JSON Server
2. **Base de données** : PostgreSQL, MySQL, MongoDB
3. **Authentification** : JWT avec serveur sécurisé
4. **HTTPS** : Certificats SSL obligatoires
5. **Variables d'environnement** : Secrets sécurisés

## 📱 Test sur Différents Appareils

### Desktop
- Chrome, Firefox, Safari, Edge
- Résolution minimum : 1024x768

### Mobile
- iOS Safari, Android Chrome
- Test responsive : F12 > Mode mobile

### Tablette
- iPad, Android tablets
- Orientation portrait et paysage

## 🚀 Déploiement

### Build de Production
```bash
npm run build
```

Les fichiers sont générés dans `dist/pharma-track/`

### Serveur Web
Servir les fichiers statiques avec :
- Apache
- Nginx  
- Node.js (Express)
- Services cloud (Netlify, Vercel)

### Configuration Serveur
```nginx
# Exemple Nginx
server {
    listen 80;
    server_name pharmatrack.local;
    root /path/to/dist/pharma-track;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

## 📞 Support Technique

### Logs et Débogage

**Console navigateur :**
- F12 > Console pour voir les erreurs JavaScript

**Logs Angular :**
```bash
ng serve --verbose
```

**Logs API :**
Les requêtes sont visibles dans la console JSON Server

### Ressources d'Aide

- **Documentation Angular** : https://angular.dev
- **Bootstrap** : https://getbootstrap.com/docs
- **JSON Server** : https://github.com/typicode/json-server

### Contact

Pour une assistance technique :
1. Vérifier cette documentation
2. Consulter les logs d'erreur
3. Rechercher dans la documentation officielle
4. Ouvrir une issue sur le repository

---

**Installation réussie ?** 🎉  
Vous devriez maintenant pouvoir accéder à PharmaTrack sur http://localhost:4200

