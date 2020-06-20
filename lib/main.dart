import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=8c18ed35";
void main() {
  runApp(
    MaterialApp(
      title: "Conversor de Moedas",
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amberAccent)),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double euro;
  double libra;
  double bitcoin;

  void _realChanged(String text) {
    if (text.isEmpty) {
      return _clearAll();
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    libraController.text = (real / libra).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(8);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      return _clearAll();
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
    libraController.text = ((dolar * this.dolar) / libra).toStringAsFixed(2);
    bitcoinController.text =
        ((dolar * this.dolar) / bitcoin).toStringAsFixed(8);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      return _clearAll();
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
    libraController.text = ((euro * this.euro) / libra).toStringAsFixed(2);
    bitcoinController.text = ((euro * this.euro) / bitcoin).toStringAsFixed(8);
  }

  void _libraChanged(String text) {
    if (text.isEmpty) {
      return _clearAll();
    }
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    dolarController.text = ((libra * this.libra) / dolar).toStringAsFixed(2);
    euroController.text = ((libra * this.libra) / euro).toStringAsFixed(2);
    bitcoinController.text =
        ((libra * this.libra) / bitcoin).toStringAsFixed(8);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      return _clearAll();
    }
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text =
        ((bitcoin * this.bitcoin) / dolar).toStringAsFixed(2);
    euroController.text = ((bitcoin * this.bitcoin) / euro).toStringAsFixed(2);
    libraController.text =
        ((bitcoin * this.bitcoin) / libra).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    libraController.text = "";
    bitcoinController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "\$ Conversor de Moedas \$",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados.....",
                  style: TextStyle(color: Colors.amber, fontSize: 20.0),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 20.0),
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 120.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Real", "R\$", 40.0, realController, _realChanged),
                      buildTextField("Dólar", "US\$", 20.0, dolarController,
                          _dolarChanged),
                      buildTextField(
                          "Euro", "€", 20.0, euroController, _euroChanged),
                      buildTextField("Libra Esterlina", "£", 20.0,
                          libraController, _libraChanged),
                      buildTextField("Bitcoin", "₿", 20.0, bitcoinController,
                          _bitcoinChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, double top,
    TextEditingController controller, Function function) {
  return Padding(
    padding: EdgeInsets.only(top: top, right: 20.0, left: 20.0, bottom: 20.0),
    child: TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: Colors.amber, fontSize: 20.0),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      controller: controller,
      onChanged: function,
    ),
  );
}
