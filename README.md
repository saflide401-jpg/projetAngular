# PharmaTrack - Système de Gestion Pharmaceutique

![PharmaTrack Logo](https://img.shields.io/badge/PharmaTrack-v1.0-blue?style=for-the-badge&logo=angular)

## 📋 Description

PharmaTrack est une application web moderne développée avec Angular pour la gestion des pharmacies et dépôts pharmaceutiques au Burkina Faso. Elle permet de gérer efficacement les stocks de médicaments, les ventes quotidiennes, et de générer des alertes automatiques de rupture de stock.

## 🎯 Objectifs

- **Gestion des stocks** : Suivi en temps réel des médicaments disponibles
- **Ventes quotidiennes** : Enregistrement et suivi des transactions
- **Alertes automatiques** : Notifications de rupture de stock
- **Statistiques** : Tableaux de bord et rapports pour les gestionnaires
- **Accessibilité** : Interface simple accessible depuis un navigateur

## 🌍 Contexte

Conçue spécifiquement pour les petites pharmacies et dépôts pharmaceutiques des zones rurales du Burkina Faso, cette application répond au besoin d'outils numériques simples et efficaces pour :
- Éviter les ruptures de médicaments essentiels
- Centraliser l'historique des ventes
- Faciliter la gestion quotidienne des stocks

## ✨ Fonctionnalités

### 🔐 Authentification
- Système de connexion sécurisé
- Gestion des rôles (Administrateur / Vendeur)
- Persistance des sessions
- Guards de protection des routes

### 💊 Gestion des Médicaments
- Liste complète des médicaments avec filtres
- Ajout, modification, suppression (CRUD complet)
- Alertes automatiques quand stock < seuil défini
- Catégorisation et recherche avancée
- Suivi des dates d'expiration

### 🛒 Système de Ventes
- Enregistrement rapide des ventes
- Décrémentation automatique du stock
- Calcul automatique des totaux
- Historique complet des transactions
- Statistiques de vente par période

### 📊 Dashboard et Statistiques
- Vue d'ensemble des médicaments en rupture
- Chiffre d'affaires du jour en temps réel
- Nombre de ventes quotidiennes
- Graphiques des ventes par semaine/mois
- Top des médicaments les plus vendus

### 📱 Interface Utilisateur
- Design responsive (mobile, tablette, desktop)
- Interface intuitive adaptée au contexte local
- Thème pharmaceutique avec couleurs appropriées
- Navigation simplifiée selon les rôles

## 🛠️ Technologies Utilisées

### Frontend
- **Angular 20** - Framework principal
- **TypeScript** - Langage de développement
- **Bootstrap 5** - Framework CSS responsive
- **FontAwesome** - Icônes
- **Chart.js** - Graphiques et visualisations
- **RxJS** - Programmation réactive

### Backend (Mock)
- **JSON Server** - API REST simulée
- **Node.js** - Environnement d'exécution

### Outils de Développement
- **Angular CLI** - Outils de développement
- **npm** - Gestionnaire de packages
- **Git** - Contrôle de version

## 📦 Installation et Configuration

### Prérequis
- Node.js (version 18 ou supérieure)
- npm (version 8 ou supérieure)
- Git

### Installation

1. **Cloner le projet**
   ```bash
   git clone <url-du-repository>
   cd pharma-track
   ```

2. **Installer les dépendances**
   ```bash
   npm install
   ```

3. **Configuration de l'API**
   - Le fichier `db.json` contient les données de démonstration
   - L'API mock utilise le port 3001 par défaut

4. **Démarrer l'application**
   
   **Option 1 : Démarrage complet (recommandé)**
   ```bash
   npm run dev
   ```
   Cette commande démarre simultanément :
   - L'API mock (port 3001)
   - L'application Angular (port 4200)

   **Option 2 : Démarrage séparé**
   ```bash
   # Terminal 1 - API
   npm run api
   
   # Terminal 2 - Frontend
   npm start
   ```

5. **Accéder à l'application**
   - URL : http://localhost:4200
   - API : http://localhost:3001

## 👥 Comptes de Démonstration

### Administrateur
- **Nom d'utilisateur** : `admin`
- **Mot de passe** : `admin123`
- **Privilèges** : Accès complet (gestion des médicaments, ventes, statistiques)

### Vendeurs
- **Vendeur 1** : `vendeur1` / `vendeur123`
- **Vendeur 2** : `vendeur2` / `vendeur123`
- **Privilèges** : Ventes et consultation des stocks

## 📁 Structure du Projet

```
pharma-track/
├── src/
│   ├── app/
│   │   ├── components/          # Composants réutilisables
│   │   │   └── navbar/          # Barre de navigation
│   │   ├── guards/              # Guards de sécurité
│   │   │   ├── auth.guard.ts    # Protection authentification
│   │   │   └── admin.guard.ts   # Protection admin
│   │   ├── interceptors/        # Intercepteurs HTTP
│   │   │   └── auth.interceptor.ts
│   │   ├── models/              # Modèles de données
│   │   │   ├── medicine.model.ts
│   │   │   ├── sale.model.ts
│   │   │   └── user.model.ts
│   │   ├── pages/               # Pages de l'application
│   │   │   ├── login/           # Page de connexion
│   │   │   ├── dashboard/       # Tableau de bord
│   │   │   ├── medicines/       # Liste des médicaments
│   │   │   ├── medicine-form/   # Formulaire médicament
│   │   │   ├── sales/           # Historique des ventes
│   │   │   └── sale-form/       # Formulaire de vente
│   │   └── services/            # Services métier
│   │       ├── auth.service.ts  # Authentification
│   │       ├── medicine.service.ts # Gestion médicaments
│   │       └── sale.service.ts  # Gestion ventes
│   ├── styles.css               # Styles globaux
│   └── index.html               # Page principale
├── db.json                      # Base de données mock
├── package.json                 # Configuration npm
└── README.md                    # Documentation
```

## 🔧 Scripts Disponibles

```bash
# Développement
npm start                # Démarrer Angular (port 4200)
npm run api             # Démarrer l'API mock (port 3001)
npm run dev             # Démarrer API + Angular simultanément

# Build et déploiement
npm run build           # Compiler pour la production
npm run build:prod      # Build optimisé pour production

# Tests et qualité
npm test                # Lancer les tests unitaires
npm run lint            # Vérifier la qualité du code
```

## 🎨 Personnalisation

### Thème et Couleurs
Les couleurs principales sont définies dans `src/styles.css` :
```css
:root {
  --primary-color: #2c5aa0;    /* Bleu principal */
  --secondary-color: #28a745;  /* Vert succès */
  --danger-color: #dc3545;     /* Rouge danger */
  --warning-color: #ffc107;    /* Jaune alerte */
}
```

### Configuration API
Pour changer l'URL de l'API, modifier les constantes dans les services :
```typescript
// src/app/services/*.service.ts
private readonly API_URL = 'http://localhost:3001/endpoint';
```

## 📊 Données de Démonstration

Le fichier `db.json` contient :
- **5 médicaments** avec stocks variés (certains en alerte)
- **5 ventes** d'exemple avec historique
- **3 utilisateurs** (1 admin + 2 vendeurs)

### Médicaments Inclus
1. Paracétamol 500mg (Stock: 150)
2. Amoxicilline 250mg (Stock: 8 - ⚠️ Alerte)
3. Aspirine 100mg (Stock: 75)
4. Oméprazole 20mg (Stock: 5 - ⚠️ Alerte)
5. Vitamine C 1000mg (Stock: 200)

## 🚀 Déploiement

### Développement Local
L'application est prête à fonctionner localement avec les commandes d'installation ci-dessus.

### Production
Pour un déploiement en production :

1. **Build de production**
   ```bash
   npm run build
   ```

2. **Serveur web**
   - Servir les fichiers du dossier `dist/`
   - Configurer un vrai backend API
   - Implémenter une vraie authentification JWT

3. **Base de données**
   - Remplacer JSON Server par une vraie base de données
   - Configurer les connexions sécurisées

## 🔒 Sécurité

### Authentification Actuelle (Démonstration)
- Tokens JWT simulés pour la démonstration
- Validation côté client uniquement
- Données stockées dans localStorage

### Recommandations pour la Production
- Implémenter une vraie authentification JWT côté serveur
- Utiliser HTTPS obligatoirement
- Hacher les mots de passe avec bcrypt
- Implémenter la validation côté serveur
- Configurer CORS correctement
- Utiliser des variables d'environnement pour les secrets

## 🐛 Dépannage

### Problèmes Courants

**Port déjà utilisé**
```bash
# Changer le port Angular
ng serve --port 4201

# Changer le port API
json-server --watch db.json --port 3002
```

**Erreurs de compilation**
```bash
# Nettoyer et réinstaller
rm -rf node_modules package-lock.json
npm install
```

**API non accessible**
- Vérifier que json-server fonctionne sur le port 3001
- Contrôler les URLs dans les services Angular

## 📈 Évolutions Futures

### Fonctionnalités Prévues
- [ ] Gestion des fournisseurs
- [ ] Commandes automatiques
- [ ] Rapports PDF exportables
- [ ] Notifications push
- [ ] Mode hors ligne
- [ ] Synchronisation multi-sites

### Améliorations Techniques
- [ ] Tests unitaires complets
- [ ] Tests end-to-end
- [ ] PWA (Progressive Web App)
- [ ] Internationalisation (i18n)
- [ ] Optimisation des performances

## 🤝 Contribution

### Comment Contribuer
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commiter les changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

### Standards de Code
- Utiliser TypeScript strict
- Suivre les conventions Angular
- Documenter les fonctions importantes
- Tester les nouvelles fonctionnalités

## 📞 Support

### Ressources
- **Documentation Angular** : https://angular.dev
- **Bootstrap** : https://getbootstrap.com
- **FontAwesome** : https://fontawesome.com

### Contact
Pour toute question ou suggestion concernant PharmaTrack, n'hésitez pas à ouvrir une issue sur le repository.

## 📄 Licence

Ce projet est développé dans un cadre éducatif et de démonstration. Voir le fichier LICENSE pour plus de détails.

---

**PharmaTrack v1.0** - Système de Gestion Pharmaceutique pour le Burkina Faso  
Développé avec ❤️ pour améliorer l'accès aux médicaments essentiels.

#   p r o j e t A n g u l a r  
 