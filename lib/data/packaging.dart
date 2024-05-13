import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab_sis_info_progetto/models/warehouse_area/products/products.dart';
import '../main.dart';

class Imballaggio {
  int pageNumber = 0;
  int pageSize = 10;

  ///Per la lista [filter] in prima posizione abbiamo dimensione, a seguire materiale
  List<String> filter = ["", ""];
  String sort = "id";
  late Uri url;
  String idOrder = "";

  ///fetch tutti i vestiti nelle scorte
  Future<List<Map<String, dynamic>>> data(
      int pageNumber, int pageSize, List<String> filter, String sort) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k].trim();
    }
    var list = await getData().then((value) {
      return value.map((row) => row.values).toList();
    });
    return list;
  }

  ///fetch vestiti ordinati da un certo ordine [idOrder]
  Future<List<Map<String, dynamic>>> dataOrder(int pageNumber, int pageSize,
      List<String> filter, String sort, String idOrder) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    this.idOrder = idOrder.trim();
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k].trim();
    }
    var list = await getData().then((value) {
      return value.map((row) => row.values).toList();
    });
    return list;
  }

  Future<List<SampleDataRow>> getData() async {
    List<SampleDataRow> sampleDataRows = [];
    List<dynamic> oderDetailsJson = [];

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

    if (idOrder != "") {
      url = Uri.parse(
          "http://localhost:8081/ordineFornitore/allImballaggio/$idOrder?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else if (filter[0] != "" || filter[1] != "") {
      url = Uri.parse(
          "http://localhost:8081/magazzino/imballaggio/filtra?dimensione=${filter[1]}&materiale=${filter[0]}&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else {
      url = Uri.parse(
          "http://localhost:8081/magazzino/imballaggio/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> imballaggiJson = json.decode(request.body);
        List<Map<String, dynamic>> imballaggi =
            imballaggiJson.map((json) => json as Map<String, dynamic>).toList();
        for (var imballaggio in imballaggi) {
          if (idOrder != "") {
            url = Uri.parse(
                "http://localhost:8081/ordineFornitore/infoDettagliOrdine/$idOrder/${imballaggio['id'].toString()}");
            final requestOrderDetails = await http.get(url, headers: headers);

            if (requestOrderDetails.statusCode == 200) {
              oderDetailsJson = json.decode(requestOrderDetails.body);
            }
          }
          sampleDataRows.add(SampleDataRow.fromList([
            imballaggio['id'].toString(),
            (idOrder == "")
                ? imballaggio['quantita'].toString()
                : oderDetailsJson[0].toString(),
            imballaggio['dimensione'],
            imballaggio['materiale'],
            (idOrder == "") ? "" : oderDetailsJson[1].toString(),
          ]));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return sampleDataRows;
  }

  void deletePackaging(List<String> packages, BuildContext context) async {
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
            "http://localhost:8081/magazzino/imballaggio/remove/${selectedRowKeys[k]}");

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

  Future<bool> deleteQuantity(
      String package, String quantity, BuildContext context) async {
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
      Uri url = Uri.parse(
          "http://localhost:8081/magazzino/imballaggio/remove/$package/${quantity.trim()}");

      //DELETE
      var request = await http.delete(url, headers: headers);

      if (request.statusCode != 200) {
        // ignore: use_build_context_synchronously
        var snackBar = SnackBar(
          content: Text(request.body),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return false;
      }

      // ignore: use_build_context_synchronously
      showResultDialog("Eliminazione effettuata con successo!", context);
    } catch (e) {
      showResultDialog("Connessione internet assente", context);
    }
    return false;
  }

  Future<bool> addPackaging(
      id, quantita, dimensione, materiale, BuildContext context) async {
    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";
    Map<String, dynamic> body = {};
    body['id'] = id.trim();
    body['quantita'] = quantita.trim();
    body['dimensione'] = dimensione.trim();
    body['materiale'] = materiale.trim();

    try {
      final url = Uri.parse("http://localhost:8081/magazzino/imballaggio/add");

      //POST
      final request =
          await http.post(url, headers: headers, body: json.encode(body));
      if (request.statusCode == 200) {
        return true;
      } else if (request.statusCode == 400) {
        // ignore: use_build_context_synchronously
        showResultDialog(request.body, context);
        return false;
      } else if (request.statusCode == 406) {
        // ignore: use_build_context_synchronously
        var snackBar = SnackBar(
          content: Text(request.body),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addQuantityPackaging(
      List<String> packagesID, String quantity, BuildContext context) async {
    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";
    Map<String, dynamic> body = {};
    body['quantita'] = int.parse(quantity.trim());

    body['dimensione'] = "";
    body['materiale'] = "";

    try {
      for (int k = 0; k < packagesID.length; k++) {
        body['id'] = packagesID[k];

        final url =
            Uri.parse("http://localhost:8081/magazzino/imballaggio/aggiorna");
        //POST
        final request =
            await http.post(url, headers: headers, body: json.encode(body));
        if (request.statusCode == 400) {
          // ignore: use_build_context_synchronously
          showResultDialog(request.body, context);
          return false;
        } else if (request.statusCode == 406) {
          // ignore: use_build_context_synchronously
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  showSortDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            children: [
              const Text(
                "ORDINAMENTO",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                child: ElevatedButton(
                    onPressed: () {
                      sort = "PIVA";
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Products(
                                    pageNumber: pageNumber,
                                    pageSize: pageSize,
                                    filter: filter,
                                    sort: sort,
                                    selectedValue: "Imballaggi",
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      "Partita IVA",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      sort = "ragioneSociale";
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Products(
                                    pageNumber: pageNumber,
                                    pageSize: pageSize,
                                    filter: filter,
                                    sort: sort,
                                    selectedValue: "Imballaggi",
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      "Ragione Sociale",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ))
            ],
          );
        }));
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
            builder: (context) => Products(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  filter: filter,
                  sort: sort,
                  selectedValue: "Imballaggi",
                )));
  }

  showResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Products(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  filter: filter,
                  sort: sort,
                  selectedValue: "Imballaggi",
                )));
  }

  showFilterDialog(String dimensione, String materiale, BuildContext context) {
    filter[0] = dimensione.trim();
    filter[1] = materiale.trim();

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Products(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  filter: filter,
                  sort: sort,
                  selectedValue: "Imballaggi",
                )));
  }
}

class SampleDataRow {
  SampleDataRow._({
    required this.id,
    required this.quantita,
    required this.dimensione,
    required this.materiale,
    required this.costo,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      id: values[0],
      quantita: values[1],
      dimensione: values[2],
      materiale: values[3],
      costo: values[4],
    );
  }

  final String id;
  final String quantita;
  final String dimensione;
  final String materiale;
  final String costo;

  Map<String, dynamic> get values {
    return {
      'id': id,
      'quantita': quantita,
      'dimensione': dimensione,
      'materiale': materiale,
      'costo': costo,
    };
  }
}
