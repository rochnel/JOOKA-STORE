import 'package:dio/dio.dart';

import '../../core/providers/dio_providers.dart';
import '../model/product_response_model.dart';
import '../../core/strings/app_strings.dart';
import '../shared/utils/dio_error_handler.dart';

class GetProductRepository {
  static final DioProvider dioProvider = DioProvider();

  // Récupérer tous les produits depuis l'API
  static Future<List<Product>> getAllProducts() async {
    try {
      // Effectuer la requête GET
      Response response =
          await dioProvider.client.get(AppStrings.getAllProductsUri);

      // Vérification de la structure des données reçues
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> jsonBody = response.data;

        // Conversion de la réponse JSON en liste d'objets `Product`
        List<Product> products =
            jsonBody.map((json) => Product.fromJson(json)).toList();

        print("Produits reçus : ${products.length}");
        return products;
      } else {
        // Si les données reçues ne sont pas valides
        throw Exception("Données invalides reçues : ${response.data}");
      }
    } on DioException catch (dioError) {
      // Utiliser la classe utilitaire pour gérer et logguer les erreurs
      DioErrorHandler.logErrorDetails(dioError);
      throw Exception(DioErrorHandler.handleDioError(dioError));
    } catch (e) {
      // Gestion des autres erreurs inattendues
      print("Erreur inattendue : $e");
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }
}
