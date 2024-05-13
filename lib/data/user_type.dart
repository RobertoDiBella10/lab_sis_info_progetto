import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab_sis_info_progetto/models/access/access.dart';

enum UserType {
  admin,
  titolare,
  sarto,
  addetto,
  socialMediaManager,
  defaultUser
}

class User {
  late String username, password, codiceFiscale;
  UserType userType = UserType.defaultUser;
  String accessToken = "";

  void setParam(String username, String password) {
    this.username = username.trim();
    this.password = password.trim();
  }

  String getCodiceFiscale() {
    return codiceFiscale;
  }

  UserType getType() {
    return userType;
  }

  Future<bool> getAccess(BuildContext context) async {
    var contentType = "application/json;charset=utf-8";
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'bearer $accessToken';
    Map<String, String> body = {};
    body['username'] = username;
    body['password'] = password;

    try {
      final url = Uri.parse("http://localhost:8081/api/auth/signin");

      //POST
      final request =
          await http.post(url, headers: headers, body: json.encode(body));
      if (request.statusCode == 200) {
        Map dataResponse = json.decode(request.body);
        accessToken = dataResponse["accessToken"];
        if (dataResponse["role"] == "ROLE_ADMIN") {
          userType = UserType.admin;
        } else if (dataResponse["role"] == "ROLE_TITOLARE") {
          userType = UserType.titolare;
        } else if (dataResponse["role"] == "ROLE_SARTO") {
          userType = UserType.sarto;
        } else {
          userType = UserType.addetto;
        }
        codiceFiscale = dataResponse["cf"];
        return true;
      } else if (request.statusCode == 403) {
        // ignore: use_build_context_synchronously
        if (!context.mounted) {
          return false;
        }
        const snackBar = SnackBar(
          content: Text('Utente non registrato'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Errore Connessione'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return false;
  }

  void logOut(BuildContext context) {
    username = "";
    password = "";
    accessToken = "";
    const snackBar = SnackBar(
      content: Text('Uscita effettuata con successo'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Access()),
        (route) => false);
  }
}
