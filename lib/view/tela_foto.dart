import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trabalhofinal/controllers/tela_foto_controller.dart';
import 'package:trabalhofinal/model/foto.dart';

class TelaFoto extends StatefulWidget {
  final Foto foto;

  const TelaFoto({
    Key? key,
    required this.foto,
  }) : super(key: key);

  @override
  _TelaFotoState createState() => _TelaFotoState();
}

class _TelaFotoState extends State<TelaFoto> {
  TelaFotoController? telaFotoController;

  void initState() {
    super.initState();
    telaFotoController = TelaFotoController(foto: widget.foto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galera de Fotos"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.all(4),
        child: ListView(
          children: [
            Container(
              height: 384,
              child: Image.memory(base64.decode(widget.foto.imagem!)),
            ),
            Divider(
              color: Colors.transparent,
              thickness: 64,
            ),
            _textoEditavel(
                widget.foto.titulo!,
                TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                "Titulo",
                telaFotoController!.tituloController),
            Divider(
              color: Colors.transparent,
              thickness: 64,
            ),
            _textoEditavel(
              widget.foto.descricao!,
              TextStyle(fontSize: 16),
              "Descricao",
              telaFotoController!.descricaoController,
            ),
            Divider(
              color: Colors.transparent,
              thickness: 32,
            ),
            Text("Data: " + widget.foto.data.toString()),
            Text("Latitude: " + widget.foto.latitude.toString()),
            Text("Longitude: " + widget.foto.longitude.toString()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: telaFotoController!.editando,
            child: Container(
              margin: EdgeInsets.all(16),
              child: FloatingActionButton(
                onPressed: _salvarAlteracoes,
                child: Icon(Icons.save),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: _trocarModo,
              child: Icon(
                  telaFotoController!.editando ? Icons.cancel : Icons.edit),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: _mostrarDialogoApagar,
              child: Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoApagar() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => _dialogoApagar(),
    );
  }

  AlertDialog _dialogoApagar() => AlertDialog(
        title: Text("Apagar foto"),
        content: Text("Deseja mesmo apagar essa foto?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              telaFotoController!.deletar(context);
            },
            child: Text("Confirmar"),
          ),
        ],
      );

  Widget _textoEditavel(String textoPadrao, TextStyle estiloPadrao, String nome,
          TextEditingController ctrler) =>
      telaFotoController!.editando
          ? Column(
              children: [
                Text(nome),
                TextField(
                  controller: ctrler,
                )
              ],
            )
          : Text(
              textoPadrao,
              style: estiloPadrao,
            );

  void _salvarAlteracoes() {
    telaFotoController!.salvarAlteracoes().then((value) {
      telaFotoController!
          .mostrarSnackbar("Alterações salvas com sucesso", context);
    }).catchError((error, stackTrace) {
      telaFotoController!.mostrarSnackbar(
          "Não foi possível salvar as alterações. Erro: " + error.toString(),
          context);
    }).whenComplete(_trocarModo);
  }

  void _trocarModo() {
    setState(telaFotoController!.trocarModo);
  }
}
