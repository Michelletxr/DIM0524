import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Contador de Pessoas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pessoa = 0;

  String _mensagem = "Adicione pessoas!";
  void _changePeople(int delta) {
    setState(() {
      _pessoa += delta;
      if (_pessoa >= 20) {
        _mensagem = "Lotado!";
        _pessoa = 20;
      } else if (_pessoa < 0) {
        _mensagem = "Vázio!";
        _pessoa = 0;
      } else {
        _mensagem = "Há vagas!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "imagens/operarios.jpeg",
          fit: BoxFit.cover,
          height: 2000.0,
          width: 2000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //primira linha
            Text(
              "Pesssoas: $_pessoa",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      child: const Text(
                        "Adicionar",
                        style: TextStyle(fontSize: 30.0, color: Colors.black),
                      ),
                      onPressed: () => {debugPrint("helo"), _changePeople(1)},
                    )),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      child: const Text(
                        "Remover",
                        style: TextStyle(fontSize: 30.0, color: Colors.black),
                      ),
                      onPressed: () =>
                          {debugPrint('removendo'), _changePeople(-1)},
                    ))
              ],
            ),
            Text(
              _mensagem,
              style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30),
            ) //text
          ],
        ),
      ],
    );
  }
}
