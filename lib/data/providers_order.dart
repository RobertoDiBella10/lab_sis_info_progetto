import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/warehouse_area/provider_order/provider_orders.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';


class OrdineFornitore {
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
        "http://localhost:8081/ordineFornitore/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> ordiniJson = json.decode(request.body);
        List<Map<String, dynamic>> ordini =
            ordiniJson.map((json) => json as Map<String, dynamic>).toList();
        for (var ordine in ordini) {

          DateTime date = DateTime.parse(ordine['data'].toString());
          date = date.add(const Duration(days: 1));
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);

          DateTime deliveryDate = DateTime.parse(ordine['dataConsegna']);
          deliveryDate = deliveryDate.add(const Duration(days: 1));
          String formattedDeliveryDate = DateFormat('yyyy-MM-dd').format(deliveryDate);


          sampleDataRows.add(SampleDataRow.fromList([
            ordine['id'].toString(),
            formattedDate,
            ordine['fornitore']['piva'].toString(),
            ordine['totale'].toString(),
            ordine['titolare']['cf'].toString(),
            formattedDeliveryDate,
          ]));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return sampleDataRows;
  }

  void deleteProvidersOrders(
      List<String> packages, BuildContext context) async {
    List<String> selectedRowKeys = [];
    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    for (int k = 0; k < packages.length; k++) {
      selectedRowKeys.add(packages[k]);
    }

    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        Uri url = Uri.parse(
            "http://localhost:8081/ordineFornitore/rimuovi/${selectedRowKeys[k]}");

        //DELETE
        var request = await http.delete(url, headers: headers);

        if (request.statusCode != 200) {
          // ignore: use_build_context_synchronously
          // ignore: use_build_context_synchronously
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          return;
        }
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      showDeleteResultDialog("Eliminazione effettuata con successo!", context);
    } catch (e) {
      showDeleteResultDialog("Connessione internet assente", context);
    }
  }

  showDeleteResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProvidersOrders(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort,
                )));
  }
}

class SampleDataRow {
  SampleDataRow._({
    required this.id,
    required this.data,
    required this.piva,
    required this.totale,
    required this.codiceFiscaleTitolare,
    required this.dataConsegna,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      id: values[0],
      data: values[1],
      piva: values[2],
      totale: values[3],
      codiceFiscaleTitolare: values[4],
      dataConsegna: values[5],
    );
  }

  final String id;
  final String data;
  final String piva;
  final String totale;
  final String codiceFiscaleTitolare;
  final String dataConsegna;

  Map<String, dynamic> get values {
    return {
      'id': id,
      'data': data,
      'piva': piva,
      'totale': totale,
      'codiceFiscaleTitolare': codiceFiscaleTitolare,
      'dataConsegna': dataConsegna,
    };
  }
}
