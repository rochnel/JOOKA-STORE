import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badge;
import 'package:jooka_store/src/view/widget/product_card.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';
import 'add_to_cart_page.dart';


class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final productController = Get.put(ProductController());
  final cartController = Get.put(CartController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs; // Observable pour surveiller le texte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildPriceFilter(),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return _buildSkeletonLoader();
              }
              if (productController.filteredProducts.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucun produit disponible",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await productController.fetchAllProducts();
                },
                child: _buildProductGrid(),
              );
            }),
          ),
        ],
      ),
    );
  }

  // AppBar personnalisé
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'JOOKA STORE',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Obx(() {
          return badge.Badge(
            position: badge.BadgePosition.topEnd(top: -2, end: 3),
            showBadge: cartController.cart.isNotEmpty,
            badgeContent: Text(
              cartController.cart.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                Get.to(() => AddToCartPage(
                      productList: productController.products,
                    ));
              },
            ),
          );
        }),
        const SizedBox(width: 10),
      ],
    );
  }

  // Barre de recherche
 Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Obx(
          () => TextField(
            controller: searchController,
            onChanged: (value) {
              searchText.value = value;
              productController.filterProducts(value);
            },
            decoration: InputDecoration(
              hintText: "Rechercher un produit...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.blue,
              ),
              suffixIcon: searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        searchController.clear();
                        searchText.value = '';
                        productController.filterProducts('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // Barre de filtre par prix
  Widget _buildPriceFilter() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filtrer par prix",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${productController.minPrice.value.toInt()} XAF"),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(
                      productController.minPrice.value,
                      productController.maxPrice.value,
                    ),
                    min: 0,
                    max: 1000, // Ajustez selon vos besoins
                    divisions: 100,
                    labels: RangeLabels(
                      "${productController.minPrice.value.toInt()} XAF",
                      "${productController.maxPrice.value.toInt()} XAF",
                    ),
                    onChanged: (values) {
                      productController.updatePriceFilter(values.start, values.end);
                    },
                  ),
                ),
                Text("${productController.maxPrice.value.toInt()} XAF"),
              ],
            ),
          ],
        ),
      );
    });
  }

  // Grille de produits
  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2.1 / 3.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: productController.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = productController.filteredProducts[index];
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1.0,
            child: ProductCard(
              product: product,
              onAddToCart: () => cartController.addToCart(product),
              onRemoveFromCart: () => cartController.removeFromCart(product),
            ),
          );
        },
      ),
    );
  }

  // Skeleton Loader
  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2 / 3.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey.shade300,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 40,
                          color: Colors.grey.shade300,
                        ),
                        const Spacer(),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
