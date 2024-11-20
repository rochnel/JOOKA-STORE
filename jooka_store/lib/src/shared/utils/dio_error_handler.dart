import 'package:dio/dio.dart';

class DioErrorHandler {
  // Gestion des erreurs Dio pour fournir des messages plus clairs
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "La connexion a expiré. Veuillez vérifier votre réseau.";
      case DioExceptionType.sendTimeout:
        return "Le délai d'envoi a expiré. Veuillez réessayer.";
      case DioExceptionType.receiveTimeout:
        return "Le délai de réponse a expiré. Réessayez.";
      case DioExceptionType.badResponse:
        return "Erreur serveur (${error.response?.statusCode ?? 'inconnue'}).";
      case DioExceptionType.cancel:
        return "La requête a été annulée.";
      case DioExceptionType.unknown:
        return "Une erreur inconnue s'est produite. Vérifiez votre réseau.";
      default:
        return "Une erreur inattendue s'est produite. Veuillez réessayer.";
    }
  }

  // Fournir un DioException enrichi pour les intercepteurs
  static DioException handleDioErrorForHandler(DioException error) {
    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      error: handleDioError(error), // Utiliser un message clair
      type: error.type,
    );
  }

  // Fonction pour logguer les détails des erreurs dans la console
  static void logErrorDetails(DioException error) {
    print("Détails de l'erreur réseau :");
    print("Message : ${error.message}");
    print("URI : ${error.requestOptions.uri}");
    if (error.response != null) {
      print("Code d'état : ${error.response?.statusCode}");
      print("Données de réponse : ${error.response?.data}");
    }
  }
}
