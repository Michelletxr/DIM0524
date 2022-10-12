import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=6f4028df";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.black),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final realController = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double real = 0;

  void clearAll() {
    dolarController.text = "";
    euroController.text = "";
    realController.text = "";
  }

  void _realChange(String text) {
    if (!text.isEmpty) {
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
      return;
    }
    clearAll();
  }

  void _dolarChange(String text) {
    if (!text.isEmpty) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
      return;
    }
    clearAll();
  }

  void _euroChange(String text) {
    if (!text.isEmpty) {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
      return;
    }
    clearAll();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                    child: Text(
                  'Awaiting data result...',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      const Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.black),
                      buildTextFormField(
                          "Reais", "R\$", realController, _realChange),
                      const Divider(),
                      buildTextFormField(
                          "Euro", "EUR", euroController, _euroChange),
                      const Divider(),
                      buildTextFormField(
                          "Dólar", "US\$", dolarController, _dolarChange),
                    ]),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextFormField(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    onChanged: ((value) => f(value)),
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        prefixText: "$prefix: "),
    style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
