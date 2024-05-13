import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/warehouse_area/products/products.dart';

class Confezione {
  int pageNumber = 0;
  int pageSize = 10;
  List<String> filter = ["", "", "", ""];
  String sort = "id";
  late Uri url;
  String idOrder = "";

  void deletePack(List<String> packages, BuildContext context) async {
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
            "http://localhost:8081/magazzino/confezione/remove/${selectedRowKeys[k]}");

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
          "http://localhost:8081/magazzino/confezione/remove/$package/${quantity.trim()}");

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

  Future<bool> addPack(id, quantita, stato, tipologia, dimensione, colore,
      BuildContext context) async {
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
    body['stato'] = stato.trim();
    body['tipologia'] = tipologia.trim();
    body['dimensione'] = dimensione.trim();
    body['colore'] = colore.trim();

    try {
      final url = Uri.parse("http://localhost:8081/magazzino/confezione/add");

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

  Future<bool> addQuantityPack(
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

    body['stato'] = "";
    body['tipologia'] = "";
    body['dimensione'] = "";
    body['colore'] = "";

    try {
      for (int k = 0; k < packagesID.length; k++) {
        body['id'] = packagesID[k];

        final url =
            Uri.parse("http://localhost:8081/magazzino/confezione/addquantita");
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
                  filter: const [],
                  sort: sort,
                  selectedValue: "Confezioni",
                )));
  }

  ///fetch tutti i vestiti nelle scorte
  Future<List<Map<String, dynamic>>> data(
      int pageNumber, int pageSize, List<String> filter, String sort) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort;
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k];
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
          "http://localhost:8081/ordineFornitore/allConfezione/$idOrder?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else if (filter[0] != "" ||
        filter[1] != "" ||
        filter[2] != "" ||
        filter[3] != "") {
      url = Uri.parse(
          "http://localhost:8081/magazzino/confezione/filtra?stato=${filter[0]}&tipologia=${filter[1]}&dimensione=${filter[2]}&colore=${filter[3]}&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else {
      url = Uri.parse(
          "http://localhost:8081/magazzino/confezione/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> confezioniJson = json.decode(request.body);
        List<Map<String, dynamic>> confezioni =
            confezioniJson.map((json) => json as Map<String, dynamic>).toList();
        for (var confezione in confezioni) {
          if (idOrder != "") {
            url = Uri.parse(
                "http://localhost:8081/ordineFornitore/infoDettagliOrdine/$idOrder/${confezione['id'].toString()}");
            final requestOrderDetails = await http.get(url, headers: headers);

            if (requestOrderDetails.statusCode == 200) {
              oderDetailsJson = json.decode(requestOrderDetails.body);
            }
          }
          sampleDataRows.add(SampleDataRow.fromList([
            confezione['id'].toString(),
            (idOrder == "")
                ? confezione['quantita'].toString()
                : oderDetailsJson[0].toString(),
            confezione['stato'],
            confezione['tipologia'],
            confezione['dimensione'],
            confezione['colore'],
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
                  selectedValue: "Confezioni",
                )));
  }

  showFilterDialog(String stato, String tipologia, String dimensione,
      String colore, BuildContext context) {
    filter[0] = stato.trim();
    filter[1] = tipologia.trim();
    filter[2] = dimensione.trim();
    filter[3] = colore.trim();

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
                  selectedValue: "Confezioni",
                )));
  }

  Future<List<Map<String, dynamic>>> dataPositiveQuantity(
      int pageNumber, int pageSize, List<String> filter, String sort) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k].trim();
    }
    var list = await getDataPositiveQuantity().then((value) {
      return value.map((row) => row.values).toList();
    });
    return list;
  }

  Future<List<SampleDataRow>> getDataPositiveQuantity() async {
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
        "http://localhost:8081/magazzino/confezione/allDisponibili?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> confezioniJson = json.decode(request.body);
        List<Map<String, dynamic>> confezioni =
            confezioniJson.map((json) => json as Map<String, dynamic>).toList();
        for (var confezione in confezioni) {
          sampleDataRows.add(SampleDataRow.fromList([
            confezione['id'].toString(),
            confezione['quantita'].toString(),
            confezione['stato'],
            confezione['tipologia'],
            confezione['dimensione'],
            confezione['colore'],
            "",
          ]));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return sampleDataRows;
  }
}

class SampleDataRow {
  SampleDataRow._({
    required this.id,
    required this.quantita,
    required this.stato,
    required this.tipologia,
    required this.dimensione,
    required this.colore,
    required this.costo,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      id: values[0],
      quantita: values[1],
      stato: values[2],
      tipologia: values[3],
      dimensione: values[4],
      colore: values[5],
      costo: values[6],
    );
  }

  final String id;
  final String quantita;
  final String stato;
  final String tipologia;
  final String dimensione;
  final String colore;
  final String costo;

  Map<String, dynamic> get values {
    return {
      'id': id,
      'quantita': quantita,
      'stato': stato,
      'tipologia': tipologia,
      'dimensione': dimensione,
      'colore': colore,
      'costo': costo,
    };
  }
}
