import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _tarefas = [];
  TextEditingController _tarefaController = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/tarefas.json');
  }

  void _salvarArquivo() async {
    final arquivo = await _getFile();

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = "Ir ao mercado";
    tarefa['realizada'] = false;
    _tarefas.add(tarefa);

    var dados = json.encode(_tarefas);
    await arquivo.writeAsString(dados);
  }

  Future<String> _lerArquivo() async {
    try {
      final arquivo = await _getFile();

      return await arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  void _addTask() {
    setState(() {
      _tarefas.add({
        'titulo': _tarefaController.text,
        'realizada': false,
      });
    });

    _tarefaController.clear();

    _salvarArquivo();
  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        Iterable l = json.decode(dados);
        _tarefas = List<Map<String, dynamic>>.from(l);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) => CheckboxListTile(
            title: Text(_tarefas[index]['titulo']),
            value: _tarefas[index]['realizada'],
            onChanged: (bool value) {
              setState(() {
                _tarefas[index]['realizada'] = value;
              });

              _salvarArquivo();
            },
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
                controller: _tarefaController,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                FlatButton(
                  onPressed: () {
                    _addTask();
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
