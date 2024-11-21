
# Jooka Store Application

## 🚀 Introduction
**Jooka Store** est une application de commerce électronique développée avec Flutter et GetX. Elle permet aux utilisateurs de parcourir des produits, de les ajouter à leur panier, et de simuler un processus d'achat.

---

## 📋 Instructions de configuration

### Prérequis
1. **Flutter** : Installez Flutter sur votre machine. [Guide d'installation](https://flutter.dev/docs/get-started/install)
2. **Node.js (optionnel)** : Pour configurer une API simulée si nécessaire.

### Étapes :
1. Clonez le dépôt :
   ```bash
   git clone https://github.com/rochnel/JOOKA-STORE.git
   cd jooka-store
   ```
2. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```
3. Exécutez l'application sur un simulateur ou un appareil physique :
   ```bash
   flutter run
   ```
4. Pour exécuter les tests :
   ```bash
   flutter test
   ```

---

## 📱 Téléchargement de l'APK

L'APK généré est disponible à la racine du projet :  
[📥 Télécharger Jooka Store APK](./jooka_store.apk)

---

## 🏗️ Vue d’ensemble de l’architecture

### Architecture
Le projet suit une architecture **MVC (Model-View-Controller)** avec **GetX** pour la gestion de l'état.

1. **Model** :
   - Contient les modèles de données comme `Product` et `Rating`.
2. **View** :
   - Définit les interfaces utilisateur (`ProductPage`, `AddToCartPage`, etc.).
3. **Controller** :
   - Gère les interactions utilisateur et la logique métier (`CartController`, `ProductController`).

### Flux de données
1. **Appel API** :
   - Les données sont récupérées via un dépôt (`GetProductRepository`) qui utilise le package `dio` pour effectuer des requêtes HTTP.
2. **Persistance locale** :
   - `GetStorage` est utilisé pour stocker les données du panier de manière persistante.
3. **Gestion de l'état** :
   - `GetX` permet d'observer les modifications de données et met à jour la vue en temps réel.

---

## 🛠️ Packages tiers utilisés

- [`dio`](https://pub.dev/packages/dio) : Pour effectuer des requêtes HTTP.
- [`get`](https://pub.dev/packages/get) : Gestion de l'état et navigation.
- [`get_storage`](https://pub.dev/packages/get_storage) : Persistance locale des données.
- [`shimmer`](https://pub.dev/packages/shimmer) : Effets de chargement visuels.
- [`badges`](https://pub.dev/packages/badges) : Badges dynamiques pour le panier.

---

## 🧪 Instructions pour les tests

### Exécuter tous les tests
```bash
flutter test
```

### Tester un fichier spécifique
```bash
flutter test test/controller/product_controller_test.dart
```

---

## 🎥 Démo vidéo

Une démonstration des fonctionnalités est disponible :  
[📹 jooka-store-demo.mp4](./jooka-store-demo.mp4)

---

## 🤔 Hypothèses faites

1. Les données de l'API respectent un format standard JSON.
2. Chaque produit inclut les champs suivants : `id`, `title`, `price`, `description`, `category`, `image`, `rating`.
3. Les données sauvegardées en mémoire locale sont en format JSON.
4. L'utilisateur ne modifie pas directement les données stockées localement.

---
