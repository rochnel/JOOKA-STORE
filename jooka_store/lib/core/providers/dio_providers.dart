import 'package:dio/dio.dart';
import '../../src/shared/utils/dio_error_handler.dart';
import '../strings/app_strings.dart';

class DioProvider {
  late final Dio _dio;

  DioProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppStrings.baseUrl,
        connectTimeout: const Duration(seconds: 60), // Timeout de connexion
        receiveTimeout: const Duration(seconds: 60), // Timeout de réception
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json', // En-tête par défaut
        },
      ),
    );

    // Ajouter des intercepteurs pour gérer les erreurs et les requêtes
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          print('Demande envoyée : [${options.method}] ${options.uri}');
          return handler.next(options); // Continuer avec la requête
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          print('Réponse reçue : [${response.statusCode}]');
          return handler.next(response); // Continuer avec la réponse
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // Utilisation de la classe utilitaire pour gérer les erreurs
          DioErrorHandler.logErrorDetails(error); // Journalisation
          handler.next(DioErrorHandler.handleDioErrorForHandler(error));
        },
      ),
    );
  }

  // Getter pour accéder à l'instance Dio
  Dio get client => _dio;
}
