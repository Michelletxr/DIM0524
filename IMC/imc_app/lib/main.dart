import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: "calculador de imc",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home()));
}

//classe home
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//criando a classe de estado
class _HomeState extends State<Home> {
  //metodo build
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _textInfo = "";

  void _resetCampos() {
    setState(() {
      _formKey.currentState?.reset();
      pesoController.clear();
      alturaController.clear();
    });
  }

  void _calcular() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;
      double imc = peso / (altura * altura);
      if (imc < 18.6) {
        _textInfo = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _textInfo = "Peso ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _textInfo = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _textInfo = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _textInfo = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        _textInfo = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IMC - CALCULATOR"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () => debugPrint("helo button"),
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.person, size: 120, color: Colors.blue),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Peso:",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: pesoController,
                  validator: (value) {
                    if (value == null) {
                      return "Insira seu peso!";
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Altura: ",
                  labelStyle: TextStyle(color: Colors.pink, fontSize: 25.0),
                ),
                controller: alturaController,
                validator: (value) {
                  if (value == null) {
                    return "insira sua altura!";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ButtonTheme(
                    child: ElevatedButton(
                        child: const Text("realizar calculo",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0)),
                        onPressed: (() {
                          if (_formKey.currentState != null) {
                            _calcular();
                          }
                        })),
                  )),
              Text(
                _textInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green, fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
