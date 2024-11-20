import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jooka_store/src/controller/product_controller.dart';
import 'package:jooka_store/src/model/product_response_model.dart';

void main() {
  late ProductController productController;

  setUp(() {
    productController = ProductController();

    // Injecter des produits simulés dans la liste principale
    productController.products.assignAll([
      Product(
        id: 1,
        title: "Produit A",
        price: 500.0,
        description: "Description produit A",
        category: "Catégorie A",
        image: "https://example.com/imageA.jpg",
        quantity: 0,
        rating: Rating(rate: 4.5, count: 100),
      ),
      Product(
        id: 2,
        title: "Produit B",
        price: 1000.0,
        description: "Description produit B",
        category: "Catégorie B",
        image: "https://example.com/imageB.jpg",
        quantity: 0,
        rating: Rating(rate: 4.0, count: 50),
      ),
    ]);

    // Synchroniser la liste des produits filtrés manuellement
    productController.filteredProducts.assignAll(productController.products);
  });

  tearDown(() {
    // Nettoyer après chaque test
    productController.products.clear();
    productController.filteredProducts.clear();
  });

  test('Recherche de produits par titre', () {
    // Filtrer par titre contenant "A"
    productController.filterProducts("A");
    expect(productController.filteredProducts.length, 1);
    expect(productController.filteredProducts.first.title, "Produit A");

    // Filtrer par titre contenant "B"
    productController.filterProducts("B");
    expect(productController.filteredProducts.length, 1);
    expect(productController.filteredProducts.first.title, "Produit B");

    // Filtrer par titre inexistant
    productController.filterProducts("Z");
    expect(productController.filteredProducts.length, 0);
  });

  test('Filtrage par prix', () {
    // Appliquer un filtre de prix entre 0 et 600
    productController.updatePriceFilter(0, 600);
    expect(productController.filteredProducts.length, 1);
    expect(productController.filteredProducts.first.title, "Produit A");

    // Appliquer un filtre de prix entre 600 et 1200
    productController.updatePriceFilter(600, 1200);
    expect(productController.filteredProducts.length, 1);
    expect(productController.filteredProducts.first.title, "Produit B");

    // Appliquer un filtre de prix sans correspondance
    productController.updatePriceFilter(1200, 2000);
    expect(productController.filteredProducts.length, 0);
  });
}
