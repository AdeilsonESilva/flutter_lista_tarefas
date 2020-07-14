import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tarefas = [
    'Ir ao mercado',
    'estudar',
    'teste',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(_tarefas[index]),
            trailing: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
          itemCount: _tarefas.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Adicionar Tarefa'),
              content: TextField(
                decoration: InputDecoration(labelText: "Digite sua tarefa"),
                onChanged: (value) => {},
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Salvar'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
