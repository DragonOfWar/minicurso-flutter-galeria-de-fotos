import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:trabalhofinal/model/foto.dart';
import 'package:trabalhofinal/persistencia/fotos_repository.dart';
import 'package:trabalhofinal/view/tela_cadastro.dart';
import 'package:trabalhofinal/view/tela_foto.dart';

class TelaPrincipalController {
  List<Foto> fotos = [];
  FotosRepository fotosRepository = FotosRepository();
  ImagePicker picker = ImagePicker();
  bool carregando = true;

  TelaPrincipalController() {
    Location.instance.changeSettings(
      accuracy: LocationAccuracy.low,
      interval: 3000,
      distanceFilter: 3,
    );
  }

  Future<void> buscarFotos() {
    return fotosRepository.selectAll().then((value) => {fotos = value});
  }

  Future<void> inserirFoto(Foto foto) {
    fotos.add(foto);
    return fotosRepository.insert(foto);
  }

  Future<void> cadastrar(context) async {
    PickedFile? imagemEscolhida = await picker.getImage(
        source: ImageSource.camera, maxHeight: 512, maxWidth: 512);
    if (imagemEscolhida == null) return;
    Uint8List imagemBytes = await imagemEscolhida.readAsBytes();
    String imagemString = base64.encode(imagemBytes);
    List<String>? dadosFoto = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => TelaCadastro(imagem: Image.memory(imagemBytes)),
      ),
    );

    if (dadosFoto == null) return;
    LocationData localizacao = await Location.instance.getLocation();
    Foto foto = Foto(
      titulo: dadosFoto[0],
      descricao: dadosFoto[1],
      data: DateTime.now(),
      latitude: localizacao.latitude,
      longitude: localizacao.longitude,
      imagem: imagemString,
    );

    await fotosRepository.insert(foto);
    mostrarSnackbar("Cadastrado foto com sucesso", context);
  }

  Future<void> visualizarFoto(Foto foto, BuildContext context) async {
    Map<String, dynamic>? resultado = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => TelaFoto(foto: foto)));
    if (resultado == null) return;
    if (resultado["delete"]) {
      await fotosRepository.delete(foto);
      mostrarSnackbar("Removido foto com sucesso", context);
    }
  }

  void mostrarSnackbar(String corpo, BuildContext contexto) {
    ScaffoldMessenger.of(contexto).showSnackBar(SnackBar(content: Text(corpo)));
  }

  Future<void> deletarTodosFotos() async {
    this.fotos.clear();
    this.fotosRepository.deleteAll();
  }
}
