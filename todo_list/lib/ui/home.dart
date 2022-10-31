import 'package:flutter/material.dart';
import 'package:todo_list/ui/home_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _list = [];
  Map<String, dynamic> _lastRemoved = {};
  int _lastRemovedPos = 0;
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readData().then((data) => setState(() => _list = json.decode(data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHomeAppBar(),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                getExpandedPattern(_todoController),
                ElevatedButton(onPressed: addTodo, child: const Text("ADD"))
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemBuilder: buildItem,
                itemCount: _list.length,
                padding: const EdgeInsets.only(top: 10.0)),
          ))
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_list[index]["title"]),
        value: _list[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_list[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          checkTodo(index, c);
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_list[index]);
          _lastRemovedPos = index;
          _list.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa ${_lastRemoved["title"]} removida."),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _list.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_list);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    final file = await _getFile();
    return file.readAsString();
  }

  void addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = {};
      newTodo["title"] = _todoController.text;
      _todoController.text = "";
      newTodo["ok"] = false;
      _list.add(newTodo);
      _saveData();
    });
  }

  void checkTodo(index, c) {
    setState(() {
      _list[index]["ok"] = c;
      _saveData();
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _list.sort((a, b) {
        if (a["ok"] && !b["ok"]) {
          return 1;
        } else if (!a["ok"] && b["ok"]) {
          return -1;
        } else {
          return 0;
        }
      });

      _saveData();
    });

    return;
  }
}
