// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class OrdineClienti {
    Future<List<Map<String, dynamic>>> get data async {
    var list = await getData().then((value) {
      return value.map((row) => row.values).toList();
    });
    return list;
  }

  Future<List<SampleDataRow>> getData() async {
    List<SampleDataRow> sampleDataRows = [];

    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    try {
      int pageNumber = 0;
      int pageSize = 10;
      String sortBy = "";

      final url = Uri.parse(
          "http://localhost:8081/fornitore/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sortBy");

      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> fornitoriJson = json.decode(request.body);
        List<Map<String, dynamic>> fornitori =
            fornitoriJson.map((json) => json as Map<String, dynamic>).toList();
        for (var fornitore in fornitori) {
          sampleDataRows.add(SampleDataRow.fromList([
            fornitore['numeroOrdine'],
            fornitore['stato'],
            fornitore['data'],
            fornitore['codiceFiscaleCliente'],
            fornitore['codiceFiscaleAddetto'],
            fornitore['scontoApplicato'].toString(),
            fornitore['tipoConsegna'].toString(),
            fornitore['totale'],
          ]));
        }
      }
    } catch (e) {
      print(e);
    }

    return sampleDataRows;
  }

    void deleteProviders(
      List<String> selectedRowKeys, BuildContext context) async {
    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    try {
      for (String piva in selectedRowKeys) {
        final url = Uri.parse("http://localhost:8081/fornitore/remove/$piva");

        //DELETE
        final request = await http.delete(url, headers: headers);

        if (request.statusCode == 200) {
          // ignore: use_build_context_synchronously
          showResultDialog("Eliminazione effettuata con successo!", context);
        } else {
          // ignore: use_build_context_synchronously
          showResultDialog("Fornitore inesistente", context);
        }
      }
    } catch (e) {
      print(e);
    }
  }

    showResultDialog(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              children: [
                Text(message),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    //Navigator.pushReplacement(context,
                        //MaterialPageRoute(builder: (context) => Providers()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      "OK",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                )
              ],
          );
        });
  }

}

class SampleDataRow {
  SampleDataRow._({
    required this.numeroOrdine,
    required this.stato,
    required this.data,
    required this.codiceFiscaleCliente,
    required this.codiceFiscaleAddetto,
    required this.scontoApplicato,
    required this.tipoConsegna,
    required this.totale,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      numeroOrdine: values[0],
      stato: values[1],
      data: values[2],
      codiceFiscaleCliente: values[3],
      codiceFiscaleAddetto: values[4],
      scontoApplicato: values[5],
      tipoConsegna: values[6],
      totale: values[7],
    );
  }

  final String numeroOrdine;
  final String stato;
  final String data;
  final String codiceFiscaleCliente;
  final String codiceFiscaleAddetto;
  final String scontoApplicato;
  final String tipoConsegna;
  final String totale;

  //final DateTime dateTime;

  Map<String, dynamic> get values {
    return {
      'numeroOrdine': numeroOrdine,
      'stato': stato,
      'data': data,
      'codiceFiscaleCliente': codiceFiscaleCliente,
      'codiceFiscaleAddetto': codiceFiscaleAddetto,
      'scontoApplicato': scontoApplicato,
      'tipoConsegna': tipoConsegna,
      'totale': totale,
    };
  }
}
