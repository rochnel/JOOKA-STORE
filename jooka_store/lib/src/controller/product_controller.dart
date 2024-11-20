import 'package:get/get.dart';
import '../model/product_response_model.dart';
import '../repositories/get_product_repository.dart';

class ProductController extends GetxController {
  var isLoading = false.obs; // Indicateur de chargement
  var products = <Product>[].obs; // Liste de tous les produits
  var filteredProducts = <Product>[].obs; // Liste filtrée des produits
  var minPrice = 0.0.obs; // Prix minimum pour le filtre
  var maxPrice = 1000.0.obs; // Prix maximum pour le filtre

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchAllProducts(); // Charger les produits dès l'initialisation
  }

  /// Méthode pour récupérer tous les produits
  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true; // Activer le chargement
      minPrice.value = 0.0;
      maxPrice.value = 1000.0;
      final fetchedProducts =
          await GetProductRepository.getAllProducts(); // Récupérer les produits
      products.assignAll(fetchedProducts); // Mettre à jour la liste principale
      filteredProducts
          .assignAll(fetchedProducts); // Synchroniser la liste filtrée
    } finally {
      isLoading.value = false; // Désactiver le chargement
    }
  }

  /// Filtrer les produits par titre et prix
 void filterProducts(String query) {
  // Copier les produits dans une variable locale
  var result = products.toList();

  // Filtrer par titre
  if (query.isNotEmpty) {
    result = result.where((product) =>
        product.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Filtrer par plage de prix
  filteredProducts.assignAll(
    result.where((product) =>
        product.price >= minPrice.value && product.price <= maxPrice.value),
  );
}


  /// Mettre à jour le filtre de prix
  void updatePriceFilter(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    filterProducts(''); // Refiltrer les produits avec les nouveaux prix
  }
}
