import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:math';


import 'package:wellness_app/controller/configController.dart';

class JwtToken {
  late String _sClientId;
  ConfigController configController = ConfigController();
  late String _sSecretKey;

  JwtToken() {
    _sClientId = configController.getClientId().value;
    _sSecretKey = configController.getClientKey().value;
  }

  // Function to genrate the JWT Token...
  String generateJWT() {
    // Define payload data
    final payload = {
      'id': Random().nextInt(10000).toString(), // Example payload
      'client_id': _sClientId, // Example payload
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000, // Issued at
      'exp':
          DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
              1000, // Expiration time
    };

    // Create a JWT
    final jwt = JWT(payload);

    // Sign the JWT with the secret key
    final String sToken =
        jwt.sign(SecretKey(_sSecretKey), algorithm: JWTAlgorithm.HS256);

    return sToken;
  }
}
