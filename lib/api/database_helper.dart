import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
/* for any auth function 
first
final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
then after body 
headers: {'Authorization': 'token $value'}

sample of post 
final response = await http.post(myUrl, body: {"username": "$username", "password": "$password"});
sample of get 
http.Response response =await http.get(myUrl);
any get should
return json.decode(response.body);
*/
class DatabaseHelper {
  var status;
  var loginEmailStatus, loginEmailStatus1, loginUsernameStatus;
  var token;
//1 login
  loginData(String username, String password) async {
    Uri myUrl = Uri(
      scheme: 'http',
      host: 'maisala7.pythonanywhere.com',
      path: 'get_user_info/',
    );
    final response = await http
        .post(myUrl, body: {"username": "$username", "password": "$password"});
    status = response.body.contains('Incorrect username or password');
    var data = json.decode(response.body);
    if (status) {
    } else {
      _save(data);
    }
  }
  //2 register

  registerData(int national_number, int phone,String email,String username,String password, 
      ) async {
    Uri myUrl = Uri(
      scheme: 'http',
      host: 'maisala7.pythonanywhere.com',
      path: 'register/',
    );
    final response = await http.post(myUrl, body: {
      "national_number": "$national_number",
      "phone": "$phone",
      "email": email,
      "username": "$username",
      "password": "$password",
    });
    status = response.body.contains('error');
    loginEmailStatus1 =
        response.body.contains('A user with that Email already exists.');
    loginEmailStatus = response.body.contains('Enter a valid email address');
    loginUsernameStatus =
        response.body.contains('A user with that username already exists');

    var data = response.body;

    if (status) {
      print(data);
    } else {
      print(data);
      _save(data);
    }
  }
  //3 card info
   addcard(String FirstName, String SecondName, String ThirdName, String FourtName,
   String Birthdate , String Placeof_Birth, String Blood_Type, String Job,
   String Address , int Phone, int Old_id ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    Uri myUrl = Uri(
      scheme: 'http',
      host: 'maisala7.pythonanywhere.com',
      path: 'card_info/',
    );
    final response = http.post(myUrl, headers: {
      'Authorization': 'token $value'
    }, body: {
      "FirstName": "$FirstName",
      "SecondName": "$SecondName",
      "ThirdName": "$ThirdName",
      "Birthdate": "$Birthdate ",
      "Placeof_Birth": "$Placeof_Birth",
      "Blood_Type": "$Blood_Type",
      "Job": "$Job",
      "Address": "$Address",
      "Phone": "$Phone",
      }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
    status = response.toString().contains('error');
  }
  //4 payment
  /////????????????????????????????????????????????????????????
   payment(String payment_Notification, int process_number
    ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    Uri myUrl = Uri(
      scheme: 'http',
      host: 'Maisala7.pythonanywhere.com',
      path: 'Payment_info/',
    );
    final response = http.post(myUrl, headers: {
      'Authorization': 'token $value'
    }, body: {
      "payment_Notification": payment_Notification,
      "process_number": "$process_number",
      }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
    status = response.toString().contains('error');
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }
  
  }