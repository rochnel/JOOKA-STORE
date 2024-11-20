import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jooka_store/src/controller/cart_controller.dart';
import 'package:jooka_store/src/model/product_response_model.dart';
import 'package:jooka_store/src/view/widget/product_card.dart';

void main() {
  late CartController cartController;

  setUp(() {
    // Initialiser le contrôleur de panier
    cartController = CartController();
    Get.put(cartController);
  });

  tearDown(() {
    // Nettoyer le contrôleur après chaque test
    Get.delete<CartController>();
  });

  testWidgets('Vérification de l\'affichage du widget ProductCard',
      (WidgetTester tester) async {
    // Créer un produit simulé
    final product = Product(
      id: 1,
      title: "Produit A",
      price: 500.0,
      description: "Description produit A",
      category: "Catégorie A",
      image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      quantity: 0,
      rating: Rating(rate: 4.5, count: 100),
    );

    // Créer des fonctions fictives pour les callbacks
    final onAddToCart = () => cartController.addToCart(product);
    final onRemoveFromCart = () => cartController.removeFromCart(product);

    // Construire le widget
    await tester.pumpWidget(
      GetMaterialApp(
        home: ProductCard(
          product: product,
          onAddToCart: onAddToCart,
          onRemoveFromCart: onRemoveFromCart,
        ),
      ),
    );

    // Attendre le rendu complet
    await tester.pumpAndSettle();

    // Vérifier l'affichage des informations principales
    expect(find.text("Produit A"), findsOneWidget);
    expect(find.text("500.0 XAF"), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Vérifier que les étoiles de notation sont affichées
    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);

    // Vérifier que le bouton d'ajout au panier est initialement bleu
    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);

    // Simuler un clic sur le bouton d'ajout au panier
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Vérifier que le produit a été ajouté au panier
    expect(cartController.isProductInCart(product), isTrue);

    // Vérifier que le bouton est maintenant vert avec une icône de validation
    final checkButton = find.byIcon(Icons.check);
    expect(checkButton, findsOneWidget);

    // Simuler un clic pour retirer du panier
    await tester.tap(checkButton);
    await tester.pumpAndSettle();

    // Vérifier que le produit a été retiré du panier
    expect(cartController.isProductInCart(product), isFalse);
  });
}
