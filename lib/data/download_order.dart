import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class ScaricoMerci {
  int pageNumber = 0;
  int pageSize = 10;

  String sort = "id";
  late Uri url;

  Future<List<Map<String, dynamic>>> data(
      int pageNumber, int pageSize, String sort) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    var list = await getData().then((value) {
      return value.map((row) => row.values).toList();
    });
    return list;
  }

  Future<List<SampleDataRow>> getData() async {
    List<SampleDataRow> sampleDataRows = [];

    await Future.delayed(const Duration(milliseconds: 500));

    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    url = Uri.parse(
        "http://localhost:8081/magazzino/merce/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> ordiniJson = json.decode(request.body);
        List<Map<String, dynamic>> ordini =
            ordiniJson.map((json) => json as Map<String, dynamic>).toList();
        for (var ordine in ordini) {
          sampleDataRows.add(SampleDataRow.fromList([
            ordine['id'].toString(),
            (ordine['addetto']['cf'] == "0")
                ? "nessuno"
                : ordine['addetto']['cf'],
          ]));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return sampleDataRows;
  }

  Future<bool> setDownload(List<String> idOrders, context) async {
    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    String cf = userData.getCodiceFiscale();

    bool error = false;

    try {
      for (int k = 0; k < idOrders.length; k++) {
        final url = Uri.parse(
            "http://localhost:8081/magazzino/merce/aggiornaStato?id=${idOrders[k]}&cf=$cf");

        //POST
        final request = await http.get(url, headers: headers);
        if (request.statusCode != 200) {
          // ignore: use_build_context_synchronously
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          error = true;
        }
      }
      if (!error) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class SampleDataRow {
  SampleDataRow._({
    required this.id,
    required this.addetto,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      id: values[0],
      addetto: values[1],
    );
  }

  final String id;
  final String addetto;

  Map<String, dynamic> get values {
    return {
      'id': id,
      'addetto': addetto,
    };
  }
}
