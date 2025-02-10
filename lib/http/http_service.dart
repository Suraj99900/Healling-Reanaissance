
import 'package:dio/dio.dart' as dio;
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/http/JwtToken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class HttpService {
  late String sBaseUrl;
  late String sToken;
  // Config controller...
  ConfigController configController = ConfigController();
  late Map<String, String> Headers;
  // JWT Service Token Class
  JwtToken jwtToken = JwtToken();

  final dio.Dio _dio;

  HttpService() : _dio = dio.Dio() {
    sBaseUrl = configController.getBaseURL().value;
    sToken = jwtToken.generateJWT();
    _dio.options.baseUrl = sBaseUrl;
    Headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $sToken',
    };
    _dio.options.headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods' : 'POST, GET, OPTIONS, PUT, DELETE',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Max-Age' : '86400',
      'Access-Control-Allow-Headers' : 'Content-Type, Authorization, X-Requested-With',
      'Authorization': 'Bearer $sToken',
    };
  }

  Future<Map<String, dynamic>> getRequest(String endpoint) async {
    try {
      print(_dio);
      final response = await _dio.get(endpoint);
      var aData = {
        "data": response.data,
      };
      if (response.statusCode == 200) {
        aData['iTrue'] = true;
      } else {
        aData['iTrue'] = false;
      }
      return aData;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: json.encode(body));
      var aData = {
        "data": response.data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
      } else {
        aData['iTrue'] = false;
      }
      return aData;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> putRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(endpoint, data: json.encode(body));
      var aData = {
        "data": response.data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
      } else {
        aData['iTrue'] = false;
      }
      return aData;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteRequest(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      var aData = {
        "data": response.data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
      } else {
        aData['iTrue'] = false;
      }
      return aData;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> postMultipartRequest(String endpoint,
      Map<String, dynamic> fields, Map<String, XFile> files) async {
    var formData = dio.FormData();

    try {
      // Add the files to the request
      await Future.forEach(files.entries,
          (MapEntry<String, XFile> entry) async {
        var key = entry.key;
        var file = entry.value;
        formData.files.add(MapEntry(
          key,
          await dio.MultipartFile.fromFile(file.path,
              contentType: MediaType('application', 'octet-stream')),
        ));
      });

      // Add the fields to the request
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      final response = await _dio.post(endpoint, data: formData);
      var aData = {
        "data": response.data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
      } else {
        aData['iTrue'] = false;
      }
      return aData;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleError(dio.DioException error) {
    if (error.response != null) {
      // The server responded with an error status code.
      return {
        "data": error.response?.data,
        "statusCode": error.response?.statusCode,
        "iTrue": false,
      };
    } else {
      // The request was made but no response was received.
      return {
        "data": "Request failed with no response",
        "statusCode": 500,
        "iTrue": false,
      };
    }
  }
}
