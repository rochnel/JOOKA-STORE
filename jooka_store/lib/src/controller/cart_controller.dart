import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/product_response_model.dart';

class CartController extends GetxController {
  var cart = <Product>[].obs; // Liste observable pour le panier
  var totalQuantity = 0.obs; // Quantité totale
  var totalPrice = 0.0.obs; // Prix total

  final storage = GetStorage(); // Instance de GetStorage
  final String storageKey = "cart_items"; // Clé de stockage

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage(); // Charger les données persistantes lors de l'initialisation
  }

// Charger les données sauvegardées depuis le stockage local
  void _loadCartFromStorage() {
    final storedCart = storage.read<List<dynamic>>(storageKey);
    if (storedCart != null) {
      cart.value = storedCart.map((item) {
        final product = Product.fromJson(item);
        // Vérifiez si la quantité existe, sinon initialisez-la
        product.quantity = product.quantity > 0 ? product.quantity : 1;
        return product;
      }).toList();

      _updateTotals();
    }
  }

  // Vérifie si un produit est déjà dans le panier
  bool isProductInCart(Product product) {
    return cart.any((p) => p.id == product.id);
  }

// Ajouter un produit au panier
  void addToCart(Product product) {
    final existingProduct = cart.firstWhere(
      (p) => p.id == product.id,
      orElse: () => Product(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        quantity: 0,
        rating: product.rating,
      ),
    );

    if (existingProduct.quantity == 0) {
      existingProduct.quantity = 1; // Initialiser la quantité
      cart.add(existingProduct);
    } else {
      existingProduct.quantity++;
    }

    _updateCartTotals(product.price, 1);
    _saveCartToStorage();
  }

// Augmenter la quantité
  void increment(Product product) {
    int index = cart.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      cart[index].quantity++;
      cart.refresh();
      _updateCartTotals(product.price, 1);
      _saveCartToStorage();
    }
  }

// Réduire la quantité
  void decrement(Product product) {
    int index = cart.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
        _updateCartTotals(-product.price, -1);
      } else {
        removeFromCart(cart[index]);
      }
      cart.refresh();
      _saveCartToStorage();
    }
  }

  // Supprimer un produit du panier
  void removeFromCart(Product product) {
    final existingProduct = cart.firstWhere((p) => p.id == product.id);
    _updateCartTotals(-(existingProduct.price * existingProduct.quantity),
        -existingProduct.quantity);
    cart.remove(existingProduct);

    _saveCartToStorage(); // Sauvegarder après modification
  }

  // Vider complètement le panier
  void clearCart() {
    cart.clear();
    totalQuantity.value = 0;
    totalPrice.value = 0.0;
    _saveCartToStorage(); // Sauvegarder après modification
  }

  // Mise à jour des totaux (prix et quantité)
  void _updateCartTotals(double priceChange, int quantityChange) {
    totalPrice.value += priceChange;
    totalQuantity.value += quantityChange;
  }

// Mise à jour des totaux depuis le stockage
  void _updateTotals() {
    totalQuantity.value = cart.fold(0, (sum, item) => sum + item.quantity);
    totalPrice.value =
        cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

// Sauvegarder les données dans le stockage local
  void _saveCartToStorage() {
    final cartData = cart.map((product) => product.toJson()).toList();
    storage.write(storageKey, cartData);
  }
}
