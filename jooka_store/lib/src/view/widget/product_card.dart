import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;

  ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  }) : super(key: key);

  final CartController cartController = Get.find(); // Instance du contrôleur

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isInCart = cartController.isProductInCart(product);

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du produit
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              // Titre du produit
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              // Étoiles de notation
              _buildRating(product.rating.rate),
              const SizedBox(height: 5),
              // Prix et bouton d'ajout/retrait
              Row(
                children: [
                  Text(
                    "${product.price} XAF",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (!isInCart) {
                        onAddToCart();
                      } else {
                        onRemoveFromCart();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isInCart ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        isInCart ? Icons.check : Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget pour afficher les étoiles de notation
  Widget _buildRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return const Icon(Icons.star, size: 16, color: Colors.orange);
        } else if (rating >= index + 0.5) {
          return const Icon(Icons.star_half, size: 16, color: Colors.orange);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.grey);
        }
      }),
    );
  }
}
