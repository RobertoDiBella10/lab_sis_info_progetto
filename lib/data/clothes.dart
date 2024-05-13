import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/warehouse_area/products/products.dart';

class Vestito {
  int pageNumber = 0;
  int pageSize = 10;
  List<String> filter = ["", "", "", "", "", "", "", ""];
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
    this.sort = sort;
    this.idOrder = idOrder;
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
          "http://localhost:8081/ordineFornitore/allVestito/$idOrder?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else if (filter[0] != "" ||
        filter[1] != "" ||
        filter[2] != "" ||
        filter[3] != "" ||
        filter[4] != "" ||
        filter[5] != "" ||
        filter[6] != "" ||
        filter[7] != "") {
      url = Uri.parse(
          "http://localhost:8081/magazzino/vestiti/filtra?quantita=${filter[0]}&tipologiaProdotto=${filter[1]}&genere=${filter[2]}&taglia=${filter[3]}&tessuto=${filter[4]}&colore=${filter[5]}&marca=${filter[6]}&fascia_eta=${filter[7]}&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else {
      url = Uri.parse(
          "http://localhost:8081/magazzino/vestito/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> vestitiJson = json.decode(request.body);
        List<Map<String, dynamic>> vestiti =
            vestitiJson.map((json) => json as Map<String, dynamic>).toList();
        for (var vestito in vestiti) {
          if (idOrder != "") {
            url = Uri.parse(
                "http://localhost:8081/ordineFornitore/infoDettagliOrdine/$idOrder/${vestito['id'].toString()}");
            final requestOrderDetails = await http.get(url, headers: headers);

            if (requestOrderDetails.statusCode == 200) {
              oderDetailsJson = json.decode(requestOrderDetails.body);
            }
          }
          sampleDataRows.add(SampleDataRow.fromList([
            vestito['id'].toString(),
            (idOrder == "")
                ? vestito['quantita'].toString()
                : oderDetailsJson[0].toString(),
            vestito['nome'],
            vestito['marca'],
            vestito['genere'],
            vestito['tipologia'],
            vestito['tessuto'],
            vestito['colore'],
            (idOrder == "")
                ? vestito['costo'].toString()
                : oderDetailsJson[1].toString(),
            vestito['taglia'],
            vestito['fasciaEta'],
            vestito['confezione'],
          ]));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return sampleDataRows;
  }

  Future<bool> addQuantityClothes(
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
    body['nome'] = "";
    body['marca'] = "";
    body['genere'] = "";
    body['tipologia'] = "";
    body['fasciaEta'] = "";
    body['tessuto'] = "";
    body['colore'] = "";
    body['costo'] = 0;
    body['taglia'] = "";
    body['confezione'] = {'id': ""};

    try {
      for (int k = 0; k < packagesID.length; k++) {
        body['id'] = packagesID[k];

        final url =
            Uri.parse("http://localhost:8081/magazzino/vestito/addQuantita");
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

  Future<bool> addClothes(
      id,
      quantita,
      nome,
      marca,
      String genere,
      tipologia,
      fasciaEta,
      tessuto,
      colore,
      costo,
      taglia,
      confezione,
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
    body['quantita'] = int.parse(quantita.trim());
    body['nome'] = nome.trim();
    body['marca'] = marca.trim();
    body['genere'] = genere.trim().toLowerCase();
    body['tipologia'] = tipologia.trim();
    body['fasciaEta'] = fasciaEta.trim();
    body['tessuto'] = tessuto.trim();
    body['colore'] = colore.trim();
    body['costo'] = costo.trim();
    body['taglia'] = taglia.trim();
    body['confezione'] = {"id": confezione.trim()};

    try {
      final url = Uri.parse("http://localhost:8081/magazzino/vestito/add");

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
                  selectedValue: "Vestiti",
                )));
  }

  void deleteClothes(List<String> packages, BuildContext context) async {
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
            "http://localhost:8081/magazzino/vestiti/remove/${selectedRowKeys[k]}");

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
            builder: (context) => Products(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  filter: filter,
                  sort: sort,
                  selectedValue: "Vestiti",
                )));
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
          "http://localhost:8081/magazzino/vestiti/remove/$package/${quantity.trim()}");

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

  showFilterDialog(
      String quantita,
      String tipologiaProdotto,
      String genere,
      String taglia,
      String tessuto,
      String colore,
      String marca,
      String fasciaEta,
      BuildContext context) {
    filter[0] = quantita.trim();
    filter[1] = tipologiaProdotto.trim();
    filter[2] = genere.trim().toLowerCase();
    filter[3] = taglia.trim();
    filter[4] = tessuto.trim();
    filter[5] = colore.trim();
    filter[6] = marca.trim();
    filter[7] = fasciaEta.trim();

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
                  selectedValue: "Vestiti",
                )));
  }
}

class SampleDataRow {
  SampleDataRow._({
    required this.id,
    required this.quantita,
    required this.nomeProdotto,
    required this.marca,
    required this.genere,
    required this.tipologia,
    required this.tessuto,
    required this.colore,
    required this.costo,
    required this.taglia,
    required this.fasciaEta,
    required this.confezione,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      id: values[0],
      quantita: values[1],
      nomeProdotto: values[2],
      marca: values[3],
      genere: values[4],
      tipologia: values[5],
      tessuto: values[6],
      colore: values[7],
      costo: values[8],
      taglia: values[9],
      fasciaEta: values[10],
      confezione: values[11],
    );
  }

  final String id;
  final String quantita;
  final String nomeProdotto;
  final String marca;
  final String genere;
  final String tipologia;
  final String tessuto;
  final String colore;
  final String costo;
  final String taglia;
  final String fasciaEta;
  final String confezione;

  Map<String, dynamic> get values {
    return {
      'id': id,
      'quantita': quantita,
      'nomeProdotto': nomeProdotto,
      'marca': marca,
      'genere': genere,
      'tipologia': tipologia,
      'tessuto': tessuto,
      'colore': colore,
      'costo': costo,
      'taglia': taglia,
      'fasciaEta': fasciaEta,
      'confezione': confezione,
    };
  }
}
