import 'package:flutter_test/flutter_test.dart';
import 'package:jooka_store/src/model/product_response_model.dart';

void main() {
  group('Product Model', () {
    test('Conversion JSON -> Objet', () {
      final json = {
        "id": 1,
        "title": "Produit 1",
        "price": 100.0,
        "description": "Description produit",
        "category": "Catégorie",
        "image": "https://s.alicdn.com/@sc04/kf/H6a0586cc28e748babb4078902904449fU.jpg_720x720q50.jpg",
        "rating": {"rate": 4.5, "count": 100},
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, "Produit 1");
      expect(product.rating.rate, 4.5);
    });

    test('Conversion Objet -> JSON', () {
      final product = Product(
        id: 1,
        title: "Produit 1",
        price: 100.0,
        description: "Description produit",
        category: "Catégorie",
        image: "https://s.alicdn.com/@sc04/kf/H6a0586cc28e748babb4078902904449fU.jpg_720x720q50.jpg",
        quantity: 0,
        rating: Rating(rate: 4.5, count: 100),
      );

      final json = product.toJson();

      expect(json['id'], 1);
      expect(json['title'], "Produit 1");
      expect(json['rating']['rate'], 4.5);
    });
  });
}
