import 'dart:convert';
import 'dart:io';
import 'dart:math';

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

    // Map<String, dynamic> tarefa = Map();
    // tarefa['titulo'] = "Ir ao mercado";
    // tarefa['realizada'] = false;
    // _tarefas.add(tarefa);

    var dados = json.encode(_tarefas);
    await arquivo.writeAsString(dados);
  }

  Future<String> _lerArquivo() async {
    try {
      final arquivo = await _getFile();

      return await arquivo.readAsString();
    } catch (e) {
      return '';
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
      if (dados.isEmpty) {
        return;
      }

      setState(() {
        Iterable l = json.decode(dados);
        _tarefas = List<Map<String, dynamic>>.from(l);
      });
    });
  }

  Widget _criarItemLista(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        var itemRemovido = _tarefas[index];

        _tarefas.removeAt(index);
        _salvarArquivo();

        final snackbar = SnackBar(
          // backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          content: Text('Tarefa removida!!'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                _tarefas.insert(index, itemRemovido);
              });
              _salvarArquivo();
            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: CheckboxListTile(
        title: Text(_tarefas[index]['titulo']),
        value: _tarefas[index]['realizada'],
        onChanged: (bool value) {
          setState(() {
            _tarefas[index]['realizada'] = value;
          });

          _salvarArquivo();
        },
      ),
    );
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
          itemBuilder: _criarItemLista,
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
