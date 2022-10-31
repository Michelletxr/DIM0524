import 'package:flutter/material.dart';

//melhorar modularização de widgets

AppBar getHomeAppBar() {
  return AppBar(
    title: const Text("Lista de Tarefas"),
    backgroundColor: Colors.purple,
    centerTitle: true,
  );
}

Expanded getExpandedPattern(_todoController) {
  return Expanded(
      child: TextField(
          controller: _todoController,
          decoration: const InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.purple),
          )));
}
