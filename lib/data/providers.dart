import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/warehouse_area/providers/providers.dart';

class Fornitore {
  int pageNumber = 0;
  int pageSize = 10;
  String search = "";

  ///Per la lista [filter] in prima posizione abbiamo regione, a seguire città, provincia, ragione sociale e tipologia prodotto
  List<String> filter = ["", "", "", "", ""];
  String sort = "ragioneSociale";
  late Uri url;

  Future<List<Map<String, dynamic>>> data(int pageNumber, int pageSize,
      String search, List<String> filter, String sort) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.search = search.trim();
    this.sort = sort.trim();
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

    if (search != "" && search != "default_search") {
      url = Uri.parse(
          "http://localhost:8081/fornitore/search?piva=$search&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else if (filter[0] != "" ||
        filter[1] != "" ||
        filter[2] != "" ||
        filter[3] != "" ||
        filter[4] != "") {
      url = Uri.parse(
          "http://localhost:8081/fornitore/filtra?regione=${filter[0]}&citta=${filter[1]}&provincia=${filter[2]}&ragioneSociale=${filter[3]}&tipologiaProdotto=${filter[4]}&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else {
      url = Uri.parse(
          "http://localhost:8081/fornitore/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      //POST
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> fornitoriJson = json.decode(request.body);
        List<Map<String, dynamic>> fornitori =
            fornitoriJson.map((json) => json as Map<String, dynamic>).toList();
        for (var fornitore in fornitori) {
            sampleDataRows.add(SampleDataRow.fromList([
              fornitore['piva'],
              fornitore['regione'],
              fornitore['citta'],
              fornitore['provincia'],
              fornitore['ragioneSociale'],
              fornitore['tipologiaProdotto'].toString(),
              fornitore['telefono'].toString(),
              fornitore['email'],
            ]));
          
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return sampleDataRows;
  }

  void deleteProviders(List<String> providers, BuildContext context) async {
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

    for (int k = 0; k < providers.length; k++) {
      selectedRowKeys.add(providers[k]);
    }

    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        Uri url = Uri.parse(
            "http://localhost:8081/fornitore/remove/${selectedRowKeys[k]}");

        //DELETE
        var request = await http.delete(url, headers: headers);

        if (request.statusCode != 200) {
          // ignore: use_build_context_synchronously
          showDeleteResultDialog("Fornitore inesistente", context);
        }
      }
      // ignore: use_build_context_synchronously
      showDeleteResultDialog("Eliminazione effettuata con successo!", context);
    } catch (e) {
      showDeleteResultDialog("Connessione internet assente", context);
    }
  }

  Future<bool> addProvider(piva, regione, citta, provincia, ragioneSociale,
      tipologiaProdotto, int cellulare, email, BuildContext context) async {
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
    body['piva'] = piva.trim();
    body['regione'] = regione.trim();
    body['citta'] = citta.trim();
    body['provincia'] = provincia.trim();
    body['ragioneSociale'] = ragioneSociale.trim();
    body['tipologiaProdotto'] = tipologiaProdotto;
    body['telefono'] = cellulare;
    body['email'] = email.trim();

    try {
      final url = Uri.parse("http://localhost:8081/fornitore/add");

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

  void searchProviders(search, BuildContext context) {
    this.search = search.trim();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Providers(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filter,
                sort: sort)));
  }

  showFilterDialog(String regione, String citta, String provincia,
      String ragioneSociale, String tipologiaProdotto, BuildContext context) {
    List<String> filterParameters = [
      regione.trim(),
      citta.trim(),
      provincia.trim(),
      ragioneSociale.trim(),
      tipologiaProdotto.trim(),
    ];
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Providers(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filterParameters,
                sort: sort)));
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
                              builder: (context) => Providers(
                                  pageNumber: pageNumber,
                                  pageSize: pageSize,
                                  search: search,
                                  filter: filter,
                                  sort: sort)));
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
                              builder: (context) => Providers(
                                  pageNumber: pageNumber,
                                  pageSize: pageSize,
                                  search: search,
                                  filter: filter,
                                  sort: sort)));
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
            builder: (context) => Providers(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filter,
                sort: sort)));
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
            builder: (context) => Providers(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filter,
                sort: sort)));
  }

  Future<List<String>> getTypeProduct(String id, context) async {
    List<String> type = [];

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
      Uri url =
          Uri.parse("http://localhost:8081/fornitore/tipologieProdotto/$id");

      var request = await http.get(url, headers: headers);

      if (request.statusCode == 200) {
        final List<dynamic> typeJson = json.decode(request.body);
        for (int k = 0; k < typeJson.length; k++) {
          type.add(typeJson[k]);
        }
      } else {
        var snackBar = SnackBar(
          content: Text(request.body),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return type;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return type;
  }

  Future<bool> createOrder(
      int idOrder,
      List<Map<String, dynamic>> products,
      String idProvider,
      String date,
      String deliveryProduct,
      double total,
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
    body['id'] = idOrder;
    body['data'] = date.trim();
    body['fornitore'] = {'piva': idProvider.trim()};
    body['totale'] = total;
    body['titolare'] = {'cf': userData.getCodiceFiscale()};
    body['dataConsegna'] = deliveryProduct.trim();

    try {
      Uri url = Uri.parse("http://localhost:8081/ordineFornitore/creazione");

      var request =
          await http.post(url, headers: headers, body: json.encode(body));

      if (request.statusCode == 200) {
        Uri compositionUrl = Uri.parse(
            "http://localhost:8081/ordineFornitore/creazione/componi");
        for (int k = 0; k < 6; k++) {
          Map<String, dynamic> singleproduct = products[k];
          Uri fornituraUrl =
              Uri.parse("http://localhost:8081/fornitore/fornitura/add");
          body.clear();
          body['fornitore'] = {'piva': idProvider};
          body['prodotto'] = {'id': singleproduct['id']};
          body['prezzoUnitario'] = singleproduct['price'];
          body['dataConsegna'] = deliveryProduct;
          request = await http.post(fornituraUrl,
              headers: headers, body: json.encode(body));

          if (request.statusCode == 200) {
            body.clear();
            body['ordine'] = {'id': idOrder};
            body['prodotto'] = {'id': singleproduct['id']};
            body['quantita'] = singleproduct['quantity'];

            request = await http.post(compositionUrl,
                headers: headers, body: json.encode(body));
            if (request.statusCode != 200) {
              var snackBar = SnackBar(
                content: Text(request.body),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return false;
            }
          } else {
            var snackBar = SnackBar(
              content: Text(request.body),
            );
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return false;
          }
        }
      } else {
        var snackBar = SnackBar(
          content: Text(request.body),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    var snackBar = const SnackBar(
      content: Text("Ordine completato"),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Providers(
                pageNumber: 0,
                pageSize: 10,
                search: "default_search",
                filter: [],
                sort: "ragioneSociale")));
    return true;
  }
}

class SampleDataRow {
  SampleDataRow._({
    required this.piva,
    required this.regione,
    required this.citta,
    required this.provincia,
    required this.ragioneSociale,
    required this.tipologiaProdotto,
    required this.cellulare,
    required this.email,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      piva: values[0],
      regione: values[1],
      citta: values[2],
      provincia: values[3],
      ragioneSociale: values[4],
      tipologiaProdotto: values[5],
      cellulare: values[6],
      email: values[7],
    );
  }

  final String piva;
  final String regione;
  final String citta;
  final String provincia;
  final String ragioneSociale;
  final String tipologiaProdotto;
  final String cellulare;
  final String email;

  Map<String, dynamic> get values {
    return {
      'piva': piva,
      'regione': regione,
      'citta': citta,
      'provincia': provincia,
      'ragione_sociale': ragioneSociale,
      'tipologia_prodotto': tipologiaProdotto,
      'cellulare': cellulare,
      'email': email,
    };
  }
}
