import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';
import '../model/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';

class AddToCartPage extends StatelessWidget {
  AddToCartPage({
    Key? key,
    required this.productList,
  }) : super(key: key);

  final List<Product> productList;
  final productController = Get.put(ProductController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (cartController.cart.isEmpty) {
          return _buildEmptyCartMessage();
        }
        return _buildCartContent();
      }),
    );
  }

  // AppBar personnalisé
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      centerTitle: true,
      title: const Text(
        'Votre Panier',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Obx(() {
          if (cartController.cart.isNotEmpty) {
            return IconButton(
              onPressed: () => _showClearCartConfirmation(context),
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              tooltip: "Vider le panier",
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  // Message lorsque le panier est vide
  Widget _buildEmptyCartMessage() {
    return const Center(
      child: Text(
        "Votre panier est vide",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Contenu du panier
  Widget _buildCartContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartController.cart.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartController.cart[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (direction) {
                    cartController.removeFromCart(item);
                    _showSnackbar(context, "${item.title} retiré du panier.");
                  },
                  child: _buildCartItem(item),
                );
              },
            ),
          ),
          _buildTotalSummary(),
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  // Widget d'un article dans le panier
  Widget _buildCartItem(dynamic item) {
    final singleProductPrice = item.price * item.quantity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Image du produit
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Détails du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${singleProductPrice.toStringAsFixed(2)} XAF",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Contrôles de quantité
            Column(
              children: [
                IconButton(
                  onPressed: () => cartController.increment(item),
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => cartController.decrement(item),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Résumé des totaux
  Widget _buildTotalSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nombre total d'articles :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "${cartController.totalQuantity.value}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Prix total :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "${cartController.totalPrice.value.toStringAsFixed(2)} XAF",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bouton de validation
Widget _buildCheckoutButton() {
  return ElevatedButton.icon(
    onPressed: () {
      // Action pour passer à la caisse
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    icon: const Icon(
      Icons.payment_outlined,
      size: 24,
      color: Colors.white,
    ),
    label: const Text(
      "Passer à la caisse",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}


  // Confirmation pour vider le panier
  void _showClearCartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer"),
        content: const Text("Voulez-vous vraiment vider votre panier ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              cartController.clearCart();
              Navigator.pop(context);
              _showSnackbar(context, "Panier vidé.");
            },
            child: const Text("Vider le panier"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Affiche une notification contextuelle
  void _showSnackbar(BuildContext context, String message) {
    Get.snackbar(
      "Notification",
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
