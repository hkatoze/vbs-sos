import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:vbs_sos/models/alertPivot.dart';
import 'package:vbs_sos/models/apiResponseModel.dart';
import 'package:vbs_sos/models/employee.dart';

import 'package:vbs_sos/services/local_db_services.dart';

const endpoint = "https://vbs-alert-api.onrender.com";

const apiToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTcwMjA1MDIzOSwiZXhwIjoxNzMzNTg2MjM5fQ.vlAMLEwlVnkDYZRt5pz9QqaJtWoenAbf76gvrcNBSHk";
Future<dynamic> axios(String url,
    {String methode = 'GET', Map<String, dynamic>? donnees}) async {
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $apiToken',
  };

  http.Response response;

  try {
    switch (methode) {
      case 'GET':
        response = await http.get(Uri.parse(url), headers: headers);
        break;
      case 'POST':
        response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(donnees));
        break;
      case 'PUT':
        response = await http.put(Uri.parse(url),
            headers: headers, body: jsonEncode(donnees));
        break;
      case 'DELETE':
        response = await http.delete(Uri.parse(url), headers: headers);
        break;
      default:
        throw Exception("Méthode HTTP non supportée");
    }

    return json.decode(response.body);
  } catch (e) {
    return {"message": "$e"};
  }
}

Future<ApiResponseModel> loginAPI(String phone, String password) async {
  String? tokenfetched = await FirebaseMessaging.instance.getToken();
  final response = await axios('$endpoint/api/login',
      methode: 'POST',
      donnees: {
        'phone_number': phone,
        'password': password,
        'tokens': tokenfetched
      });

  try {
    if (response["message"] == "L'utilisateur s'est connecté avec succès.") {
      Employee employee = Employee(
        companyId: response["data"]['companyId'],
        employeeId: response["data"]['employeeId'],
        firstname: response["data"]['firstname'],
        lastname: response["data"]['lastname'],
        tokens: response["data"]['tokens'],
        profilUrl: response["data"]['profilUrl'],
        phone_number: response["data"]['phone_number'],
        role: response["data"]['role'],
        job: response["data"]['job'],
      );

      await DatabaseManager.instance.addEmployee(employee);

      return ApiResponseModel(
          message: response["message"],
          data: Employee(
            companyId: response["data"]['companyId'],
            employeeId: response["data"]['employeeId'],
            firstname: response["data"]['firstname'],
            lastname: response["data"]['lastname'],
            tokens: response["data"]['tokens'],
            profilUrl: response["data"]['profilUrl'],
            phone_number: response["data"]['phone_number'],
            role: response["data"]['role'],
            job: response["data"]['job'],
          ));
    } else {
      return ApiResponseModel(
        message: response["message"],
      );
    }
  } catch (e) {
    return ApiResponseModel(message: "$e");
  }
}

Future<ApiResponseModel> addAlertApi(AlertPivot alertPivot, double longitude,
    double latitude, String message) async {
  final response =
      await axios('$endpoint/api/alerts', methode: 'POST', donnees: {
    'companyId': alertPivot.employee.companyId,
    'employeeId': alertPivot.employee.employeeId,
    'alertType': alertPivot.alert.alertType,
    'alertStatus': alertPivot.alert.alertStatus,
    'message': message,
    'alertLocation': {
      'longitude': longitude,
      'latitude': latitude,
    },
  });

  return ApiResponseModel(message: response["message"], data: response["data"]);
}

Future<ApiResponseModel> resetPassword(
  String phone,
) async {
  final response =
      await axios('$endpoint/api/reset-password', methode: 'POST', donnees: {
    'phone_number': phone,
  });
  try {
    return ApiResponseModel(
        message: response["message"],
        data: {'verificationCode': response['verificationCode']});
  } catch (e) {
    return ApiResponseModel(message: "$e");
  }
}

Future<ApiResponseModel> checkCodeForResetPassword(
    String phone, String verificationCode, String newPassword) async {
  final response = await axios('$endpoint/api/reset-password-verify',
      methode: 'POST',
      donnees: {
        'phone_number': phone,
        'verificationCode': verificationCode,
        'newPassword': newPassword
      });
  try {
    return ApiResponseModel(message: response["message"]);
  } catch (e) {
    return ApiResponseModel(message: "$e");
  }
}

Future<ApiResponseModel> updateAlertApi(int alertId, String status) async {
  final response =
      await axios('$endpoint/api/alerts/$alertId', methode: 'POST', donnees: {
    'alertStatus': status,
  });

  return ApiResponseModel(message: response["message"], data: response["data"]);
}
