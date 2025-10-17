# Architecture Technique PharmaTrack

## 🏗️ Vue d'Ensemble de l'Architecture

PharmaTrack suit une architecture Angular moderne basée sur les composants standalone, les services injectables et la programmation réactive avec RxJS.

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND ANGULAR                         │
├─────────────────────────────────────────────────────────────┤
│  Components (UI)  │  Services (Logic)  │  Guards (Security) │
│  ├─ Pages         │  ├─ AuthService    │  ├─ AuthGuard     │
│  ├─ Navbar        │  ├─ MedicineService│  └─ AdminGuard    │
│  └─ Forms         │  └─ SaleService    │                   │
├─────────────────────────────────────────────────────────────┤
│                    HTTP INTERCEPTOR                         │
├─────────────────────────────────────────────────────────────┤
│                    API REST (JSON Server)                   │
├─────────────────────────────────────────────────────────────┤
│                    DATA LAYER (db.json)                     │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Structure Détaillée du Code

### 1. Modèles de Données (`src/app/models/`)

#### `medicine.model.ts`
```typescript
export interface Medicine {
  id: string;
  nom: string;
  categorie: string;
  prix: number;
  quantiteStock: number;
  dateExpiration: string;
  description?: string;
  fournisseur?: string;
  seuilAlerte?: number;
}
```

**Explication :**
- Interface TypeScript définissant la structure d'un médicament
- Propriétés obligatoires et optionnelles (avec `?`)
- Types stricts pour la validation compile-time
- `seuilAlerte` pour personnaliser le seuil d'alerte par médicament

#### `sale.model.ts`
```typescript
export interface Sale {
  id: string;
  medicamentId: string;
  medicamentNom: string;
  quantite: number;
  prixUnitaire: number;
  total: number;
  date: string;
  vendeurId: string;
  vendeurNom: string;
}

export interface SaleStatistics {
  chiffreAffairesJour: number;
  nombreVentesJour: number;
  topMedicaments: TopMedicament[];
}
```

**Explication :**
- `Sale` : Structure d'une vente avec références aux médicaments et vendeurs
- `SaleStatistics` : Interface pour les statistiques calculées
- Dénormalisation volontaire (`medicamentNom`, `vendeurNom`) pour optimiser l'affichage

#### `user.model.ts`
```typescript
export interface User {
  id: string;
  nom: string;
  prenom: string;
  email: string;
  motDePasse: string;
  role: 'admin' | 'user';
  dateCreation: string;
  actif: boolean;
}
```

**Explication :**
- Union type pour `role` : seulement 'admin' ou 'user' autorisés
- Propriété `actif` pour désactiver des comptes sans les supprimer
- Structure adaptée au contexte burkinabé (nom/prénom séparés)

### 2. Services Métier (`src/app/services/`)

#### `auth.service.ts` - Service d'Authentification

**Architecture du Service :**
```typescript
@Injectable({
  providedIn: 'root'  // Singleton global
})
export class AuthService {
  private readonly API_URL = 'http://localhost:3001/users';
  private readonly TOKEN_KEY = 'pharma_track_token';
  
  // État réactif avec BehaviorSubject
  private authStateSubject = new BehaviorSubject<AuthState>({
    isAuthenticated: false,
    user: null
  });
  
  // Observable public pour les composants
  public authState$ = this.authStateSubject.asObservable();
}
```

**Méthodes Principales :**

1. **`login(username: string, password: string)`**
   ```typescript
   login(username: string, password: string): Observable<boolean> {
     return this.http.get<User[]>(`${this.API_URL}?email=${username}`)
       .pipe(
         map(users => {
           const user = users.find(u => u.motDePasse === password);
           if (user && user.actif) {
             this.setAuthenticatedUser(user);
             return true;
           }
           return false;
         }),
         catchError(error => {
           console.error('Erreur de connexion:', error);
           return of(false);
         })
       );
   }
   ```

   **Explication :**
   - Recherche l'utilisateur par email dans l'API
   - Vérifie le mot de passe (en production : hash + salt)
   - Utilise RxJS `map` pour transformer la réponse
   - `catchError` pour gérer les erreurs réseau

2. **`setAuthenticatedUser(user: User)`**
   ```typescript
   private setAuthenticatedUser(user: User): void {
     const token = this.generateToken(user);
     
     localStorage.setItem(this.TOKEN_KEY, token);
     localStorage.setItem(this.USER_KEY, JSON.stringify(user));
     
     this.authStateSubject.next({
       isAuthenticated: true,
       user: user
     });
   }
   ```

   **Explication :**
   - Génère un token JWT simulé
   - Stocke dans localStorage pour persistance
   - Met à jour le BehaviorSubject pour notifier tous les abonnés

#### `medicine.service.ts` - Service des Médicaments

**Cache Local avec BehaviorSubject :**
```typescript
export class MedicineService {
  private medicinesSubject = new BehaviorSubject<Medicine[]>([]);
  public medicines$ = this.medicinesSubject.asObservable();
  
  private alertMedicinesSubject = new BehaviorSubject<Medicine[]>([]);
  public alertMedicines$ = this.alertMedicinesSubject.asObservable();
}
```

**Avantages du Cache :**
- Évite les appels API répétés
- Synchronisation automatique entre composants
- Performance améliorée
- État cohérent dans toute l'application

**Méthode CRUD Exemple :**
```typescript
addMedicine(medicine: Omit<Medicine, 'id'>): Observable<Medicine> {
  const newMedicine: Medicine = {
    ...medicine,
    id: this.generateId()
  };
  
  return this.http.post<Medicine>(this.API_URL, newMedicine)
    .pipe(
      tap(created => {
        // Mettre à jour le cache local
        const current = this.medicinesSubject.value;
        this.medicinesSubject.next([...current, created]);
        this.updateAlertMedicines();
      }),
      catchError(this.handleError<Medicine>('addMedicine'))
    );
}
```

**Explication :**
- `Omit<Medicine, 'id'>` : Type utilitaire excluant l'ID
- `tap` : Effet de bord pour mettre à jour le cache
- Spread operator `...` pour l'immutabilité
- Gestion d'erreur centralisée

#### `sale.service.ts` - Service des Ventes

**Logique Métier Complexe :**
```typescript
addSale(saleData: Omit<Sale, 'id' | 'total'>): Observable<Sale> {
  const total = saleData.quantite * saleData.prixUnitaire;
  const newSale: Sale = {
    ...saleData,
    id: this.generateId(),
    total: total
  };
  
  return this.http.post<Sale>(this.API_URL, newSale)
    .pipe(
      switchMap(createdSale => {
        // Décrémenter le stock automatiquement
        return this.medicineService.updateStock(
          saleData.medicamentId, 
          -saleData.quantite
        ).pipe(
          map(() => createdSale)
        );
      }),
      tap(sale => {
        // Mettre à jour le cache des ventes
        const current = this.salesSubject.value;
        this.salesSubject.next([...current, sale]);
      }),
      catchError(this.handleError<Sale>('addSale'))
    );
}
```

**Explication :**
- `switchMap` : Chaîne deux opérations asynchrones
- Transaction logique : vente + décrémentation stock
- Calcul automatique du total
- Mise à jour des caches multiples

### 3. Guards de Sécurité (`src/app/guards/`)

#### `auth.guard.ts` - Protection des Routes

```typescript
export const authGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);
  
  return authService.authState$.pipe(
    map(authState => {
      if (authState.isAuthenticated) {
        return true;
      } else {
        router.navigate(['/login'], { 
          queryParams: { returnUrl: state.url } 
        });
        return false;
      }
    })
  );
};
```

**Explication :**
- Guard fonctionnel (Angular 15+) au lieu de classe
- `inject()` pour l'injection de dépendances
- Redirection avec URL de retour
- Observable pour réactivité

#### `admin.guard.ts` - Protection Admin

```typescript
export const adminGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);
  
  return authService.authState$.pipe(
    map(authState => {
      if (authState.isAuthenticated && authState.user?.role === 'admin') {
        return true;
      } else {
        router.navigate(['/dashboard']);
        return false;
      }
    })
  );
};
```

### 4. Intercepteur HTTP (`src/app/interceptors/`)

#### `auth.interceptor.ts` - Authentification Automatique

```typescript
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const token = authService.getToken();
  
  if (token) {
    const authReq = req.clone({
      headers: req.headers.set('Authorization', `Bearer ${token}`)
    });
    return next(authReq);
  }
  
  return next(req);
};
```

**Explication :**
- Intercepteur fonctionnel moderne
- Clone la requête pour l'immutabilité
- Ajoute automatiquement le token à toutes les requêtes
- Transparent pour les services

### 5. Composants UI (`src/app/components/` et `src/app/pages/`)

#### `navbar.component.ts` - Navigation Réactive

```typescript
export class NavbarComponent implements OnInit, OnDestroy {
  private destroy$ = new Subject<void>();
  
  ngOnInit(): void {
    this.authService.authState$
      .pipe(takeUntil(this.destroy$))
      .subscribe(authState => {
        this.isAuthenticated = authState.isAuthenticated;
        this.currentUser = authState.user;
        this.isAdmin = this.authService.isAdmin();
      });
  }
  
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

**Pattern de Désabonnement :**
- `Subject` pour gérer les désabonnements
- `takeUntil` pour éviter les fuites mémoire
- Nettoyage automatique dans `ngOnDestroy`

#### `dashboard.component.ts` - Agrégation de Données

```typescript
private loadDashboardData(): void {
  // Chargement parallèle des données
  forkJoin({
    statistics: this.saleService.getSaleStatistics(),
    alertMedicines: this.medicineService.getMedicinesInAlert()
  }).pipe(
    takeUntil(this.destroy$)
  ).subscribe({
    next: ({ statistics, alertMedicines }) => {
      this.statistics = statistics;
      this.medicinesInAlert = alertMedicines;
      this.isLoading = false;
    },
    error: (error) => {
      this.error = 'Erreur lors du chargement';
      this.isLoading = false;
    }
  });
}
```

**Explication :**
- `forkJoin` : Combine plusieurs Observables
- Chargement parallèle pour optimiser les performances
- Gestion d'état (loading, error, success)

### 6. Configuration de l'Application (`src/app/app.config.ts`)

```typescript
export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(
      withInterceptors([authInterceptor])
    ),
    // Autres providers...
  ]
};
```

**Configuration Moderne :**
- Bootstrap de l'application sans module
- Injection des intercepteurs
- Configuration centralisée

## 🔄 Flux de Données

### 1. Authentification
```
User Input → LoginComponent → AuthService → HTTP → API
                ↓
LocalStorage ← AuthService ← HTTP Response
                ↓
BehaviorSubject → All Components (Reactive Update)
```

### 2. Gestion des Médicaments
```
Component → MedicineService → HTTP → JSON Server
              ↓
        BehaviorSubject (Cache)
              ↓
    All Subscribed Components
```

### 3. Ventes avec Stock
```
SaleForm → SaleService → Create Sale → Update Stock
             ↓              ↓            ↓
        Cache Update → Medicine Service → Stock Update
```

## 🎨 Patterns Utilisés

### 1. **Observer Pattern**
- BehaviorSubject pour l'état partagé
- Observables pour la communication composant-service

### 2. **Singleton Pattern**
- Services injectés avec `providedIn: 'root'`
- Instance unique partagée

### 3. **Facade Pattern**
- Services comme façades pour l'API
- Abstraction de la complexité HTTP

### 4. **Strategy Pattern**
- Guards différents selon les besoins de sécurité
- Intercepteurs modulaires

### 5. **Command Pattern**
- Actions utilisateur → méthodes de service
- Encapsulation des opérations métier

## 🔒 Sécurité et Validation

### 1. **Validation TypeScript**
```typescript
// Types stricts
interface Medicine {
  prix: number;  // Pas string
  quantiteStock: number;
}

// Validation runtime
if (medicine.quantiteStock < 0) {
  throw new Error('Stock ne peut pas être négatif');
}
```

### 2. **Guards de Route**
- Vérification avant navigation
- Redirection automatique
- Protection par rôle

### 3. **Gestion d'Erreurs**
```typescript
private handleError<T>(operation = 'operation', result?: T) {
  return (error: any): Observable<T> => {
    console.error(`${operation} failed:`, error);
    return of(result as T);
  };
}
```

## 📱 Responsive Design

### 1. **Bootstrap Grid**
```html
<div class="col-lg-3 col-md-6 col-sm-12">
  <!-- Contenu adaptatif -->
</div>
```

### 2. **CSS Media Queries**
```css
@media (max-width: 768px) {
  .dashboard-card {
    margin-bottom: 1rem;
  }
}
```

### 3. **Navigation Mobile**
- Menu hamburger
- Collapse automatique
- Touch-friendly

## 🚀 Optimisations

### 1. **Lazy Loading**
```typescript
{
  path: 'medicines',
  loadComponent: () => import('./pages/medicines/medicines.component')
    .then(m => m.MedicinesComponent)
}
```

### 2. **OnPush Strategy**
```typescript
@Component({
  changeDetection: ChangeDetectionStrategy.OnPush
})
```

### 3. **TrackBy Functions**
```typescript
trackByMedicineId(index: number, medicine: Medicine): string {
  return medicine.id;
}
```

## 🧪 Tests (Structure Prévue)

### 1. **Tests Unitaires**
```typescript
describe('MedicineService', () => {
  it('should add medicine to cache', () => {
    // Test du cache local
  });
});
```

### 2. **Tests d'Intégration**
```typescript
describe('Login Flow', () => {
  it('should redirect to dashboard after login', () => {
    // Test du flux complet
  });
});
```

---

Cette architecture garantit :
- **Maintenabilité** : Code modulaire et bien structuré
- **Scalabilité** : Ajout facile de nouvelles fonctionnalités
- **Performance** : Cache local et optimisations
- **Sécurité** : Guards et validation
- **UX** : Interface réactive et responsive

