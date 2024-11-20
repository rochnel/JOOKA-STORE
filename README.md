
# Jooka Store Application

## 🚀 Introduction
Jooka Store est une application de commerce électronique développée avec Flutter et GetX. Elle permet aux utilisateurs de parcourir des produits, de les ajouter à leur panier, et de simuler un processus d'achat.

---

## 📋 Instructions de configuration

### Prérequis :
1. **Flutter** : Assurez-vous d'avoir Flutter installé sur votre machine. [Guide d'installation](https://flutter.dev/docs/get-started/install)
2. **Get Storage** : Le package `get_storage` est utilisé pour la persistance des données.
3. **Node.js (optionnel)** : Pour configurer une API simulée si nécessaire.

### Étapes :
1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre-repository/jooka-store.git
   cd jooka-store
   ```
2. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```
3. Exécutez l'application :
   ```bash
   flutter run
   ```
4. Pour exécuter les tests :
   ```bash
   flutter test
   ```

---

## 🏗️ Vue d’ensemble de l’architecture

### Architecture
Le projet suit l'architecture **MVC (Model-View-Controller)** avec **GetX** pour la gestion de l'état.

1. **Model** :
   - Contient les modèles de données, par exemple `Product`, `Rating`.
2. **View** :
   - Contient les interfaces utilisateur telles que `ProductPage`, `AddToCartPage`, et les widgets personnalisés.
3. **Controller** :
   - Gère les interactions utilisateur et les mises à jour des données (par exemple, `CartController`, `ProductController`).

### Flux de données
1. **Appel API** : Les données sont récupérées via un dépôt (`GetProductRepository`).
2. **Persistance locale** : `GetStorage` est utilisé pour sauvegarder les données localement.
3. **Gestion de l'état** : `GetX` observe les modifications et met à jour la vue automatiquement.

---

## 🛠️ Packages tiers utilisés

Voici les packages principaux utilisés :
- [`get`](https://pub.dev/packages/get) : Gestion d'état et navigation.
- [`get_storage`](https://pub.dev/packages/get_storage) : Persistance des données.
- [`shimmer`](https://pub.dev/packages/shimmer) : Effet visuel pour les loaders.
- [`badges`](https://pub.dev/packages/badges) : Badges pour le panier.
- [`flutter_test`](https://pub.dev/packages/flutter_test) : Framework de test intégré.

---

## 🧪 Instructions pour les tests

### Exécuter tous les tests :
```bash
flutter test
```

### Tester un fichier spécifique :
```bash
flutter test test/view/product_page_test.dart
```

---

## 🎥 Démo vidéo

Une démo rapide des fonctionnalités est disponible dans le fichier :  
[📹 jooka-store-demo.mp4](./assets/demo/jooka-store-demo.mp4)  

---

## 🤔 Hypothèses faites

1. L'API utilise un format de réponse standard JSON.
2. Les produits contiennent les champs suivants : `id`, `title`, `price`, `description`, `category`, `image`, et `rating`.
3. Le stockage local utilise uniquement le format JSON pour simplifier l'implémentation.
4. L'utilisateur ne modifie pas les données persistées directement en dehors de l'application.

---

## 🙌 Contributions
Pour toute contribution, créez une pull request ou ouvrez une issue.
