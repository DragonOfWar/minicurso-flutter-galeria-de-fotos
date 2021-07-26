import 'package:flutter/material.dart';
import 'package:trabalhofinal/model/foto.dart';
import 'package:trabalhofinal/persistencia/fotos_repository.dart';

class TelaFotoController {
  bool editando = false;
  Foto foto;
  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  FotosRepository fotosRepository = FotosRepository();

  TelaFotoController({required this.foto});

  Future<void> salvarAlteracoes() async {
    foto.titulo = tituloController.text;
    foto.descricao = descricaoController.text;
    await fotosRepository.update(foto);
  }

  void trocarModo() {
    editando = !editando;
    tituloController.text = foto.titulo!;
    descricaoController.text = foto.descricao!;
  }

  void mostrarSnackbar(String corpo, BuildContext contexto) {
    ScaffoldMessenger.of(contexto).showSnackBar(SnackBar(content: Text(corpo)));
  }

  void deletar(BuildContext context) {
    Navigator.pop(context, {"delete": true});
  }
}
