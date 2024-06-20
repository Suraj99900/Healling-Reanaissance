import 'package:image_picker/image_picker.dart';
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/http/JwtToken.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';

class HttpService {
  late String sBaseUrl;
  late String sToken;
  // config controller...
  ConfigController configController = ConfigController();

  // JWT Service Token Class
  JwtToken jwtToken = JwtToken();

  HttpService() {
    sBaseUrl = configController.getBaseURL().value;
    sToken = jwtToken.generateJWT();
  }

  Future getRequest(String endpoint) async {
    final url = Uri.parse('$sBaseUrl$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sToken',
        },
      );

      final data = json.decode(response.body);
      var aData = {
        "data": data,
      };
      if (response.statusCode == 200) {
        aData['iTrue'] = true;
        return aData;
      } else {
        aData['iTrue'] = false;
        return aData;
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$sBaseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sToken',
        },
        body: json.encode(body),
      );
      final data = json.decode(response.body);

      var aData = {
        "data": data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
        return aData;
      } else {
        aData['iTrue'] = false;
        return aData;
      }
    } catch (e) {
      return e;
    }
  }

  Future putRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$sBaseUrl$endpoint');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sToken',
        },
        body: json.encode(body),
      );
      final data = json.decode(response.body);

      var aData = {
        "data": data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
        return aData;
      } else {
        aData['iTrue'] = false;
        return aData;
      }
    } catch (e) {
      print(e);
      return "e";
    }
  }

  Future deleteRequest(String endpoint) async {
    final url = Uri.parse('$sBaseUrl$endpoint');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sToken',
        },
      );

      final data = json.decode(response.body);

      var aData = {
        "data": data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
        return aData;
      } else {
        aData['iTrue'] = false;
        return aData;
      }
    } catch (e) {
      return e;
    }
  }

  Future postMultipartRequest(String endpoint, Map<String, dynamic> fields,
      Map<String, XFile> files) async {
    final url = Uri.parse('$sBaseUrl$endpoint');
    var request = http.MultipartRequest('POST', url);

    try {
      // Add the files to the request
      files.forEach((key, file) async {
        request.files.add(
          await http.MultipartFile.fromPath(
            key,
            file.path,
            contentType: MediaType('application', 'octet-stream'),
          ),
        );
      });

      // Add the fields to the request
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $sToken',
      });

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      final data = json.decode(responseData.body);

      var aData = {
        "data": data,
      };
      if (response.statusCode == 200 || response.statusCode == 201) {
        aData['iTrue'] = true;
        return aData;
      } else {
        aData['iTrue'] = false;
        return aData;
      }
    } catch (e) {
      return e;
    }
  }
  
}
