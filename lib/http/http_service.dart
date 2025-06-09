import 'dart:convert';
import 'dart:io' show File;
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:kavita_healling_reanaissance/controller/configController.dart';
import 'package:kavita_healling_reanaissance/http/JwtToken.dart';

class HttpService {
  late final String sBaseUrl;
  late String sBaseUrlCross;
  late final String sWebURL;
  late final String sToken;
  late final Map<String, String> headers;
  final ConfigController configController = ConfigController();
  final JwtToken jwtToken = JwtToken();
  final dio.Dio _dio;

  HttpService() : _dio = dio.Dio() {
    sBaseUrl = configController.getBaseURL().value;
    sToken = jwtToken.generateJWT();
    sWebURL = configController.getWebURL().value;
    if (kIsWeb) {
      sBaseUrlCross = 'https://cors-anywhere.herokuapp.com/$sBaseUrl';
      _dio.options.baseUrl = sBaseUrlCross;
    }else{
      _dio.options.baseUrl = sBaseUrl;
    }

    headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $sToken',
    };
    _dio.options.headers = headers;
  }

  Future<Map<String, dynamic>> _handleRequest(Future<dio.Response> Function() request) async {
    try {
      final response = await request();
      return {
        "data": response.data,
        "iTrue": response.statusCode == 200 || response.statusCode == 201,
      };
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getRequest(String endpoint) async {
    return _handleRequest(() => _dio.get(endpoint));
  }

  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    return _handleRequest(() => _dio.post(endpoint, data: json.encode(body)));
  }

  Future<Map<String, dynamic>> putRequest(String endpoint, Map<String, dynamic> body) async {
    return _handleRequest(() => _dio.put(endpoint, data: json.encode(body)));
  }

  Future<Map<String, dynamic>> deleteRequest(String endpoint) async {
    return _handleRequest(() => _dio.delete(endpoint));
  }

  Future<Map<String, dynamic>> postMultipartRequest(String endpoint, Map<String, dynamic> fields, Map<String, XFile> files) async {
    var formData = dio.FormData();

    try {
      await Future.forEach(files.entries, (MapEntry<String, XFile> entry) async {
        var key = entry.key;
        var file = entry.value;

        if (kIsWeb) {
          var bytes = await file.readAsBytes();
          formData.files.add(MapEntry(
            key,
            dio.MultipartFile.fromBytes(bytes, filename: file.name, contentType: MediaType('application', 'octet-stream')),
          ));
        } else {
          formData.files.add(MapEntry(
            key,
            await dio.MultipartFile.fromFile(file.path, filename: file.name, contentType: MediaType('application', 'octet-stream')),
          ));
        }
      });

      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      return _handleRequest(() => _dio.post(endpoint, data: formData));
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleError(dio.DioException error) {
    return {
      "data": error.response?.data ?? "Request failed with no response",
      "statusCode": error.response?.statusCode ?? 500,
      "iTrue": false,
    };
  }
}