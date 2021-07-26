import 'package:flutter/material.dart';
import 'package:trabalhofinal/controllers/tela_principal_controller.dart';
import 'package:trabalhofinal/model/foto.dart';
import 'package:trabalhofinal/persistencia/bando_de_dados.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  TelaPrincipalController telaPrincipalController = TelaPrincipalController();

  @override
  void initState() {
    super.initState();
    BancoDeDados().abrir().whenComplete(_recarregarPagina);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galera de Fotos"),
        backgroundColor: Colors.green,
      ),
      body: telaPrincipalController.carregando
          ? _corpoCarregando()
          : _corpoPrincipal(),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: _cadastrarFoto,
          child: const Icon(Icons.camera_alt),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Center _corpoCarregando() => Center(
        child: CircularProgressIndicator(),
      );

  Widget _corpoPrincipal() => Container(
        padding: const EdgeInsets.all(10),
        child: telaPrincipalController.fotos.length > 0
            ? ListView.builder(
                itemCount: telaPrincipalController.fotos.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return _botaoFoto(telaPrincipalController.fotos[i]);
                },
              )
            : Center(
                child: Text("Não há nenhuma foto cadastrada!"),
              ),
      );

  Container _botaoFoto(Foto foto) => Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foto.titulo!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text("Data: ${foto.data}"),
                  Text("Latitude: ${foto.latitude}"),
                  Text("Longitude: ${foto.longitude}"),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 1.0,
              child: ElevatedButton(
                onPressed: () {
                  _visualizarFoto(foto);
                },
                child: const Icon(Icons.remove_red_eye),
              ),
            ),
          ],
        ),
      ));

  void _cadastrarFoto() {
    setState(() {
      telaPrincipalController.carregando = true;
      telaPrincipalController
          .cadastrar(context)
          .whenComplete(_recarregarPagina);
    });
  }

  void _visualizarFoto(Foto foto) {
    setState(() {
      telaPrincipalController.carregando = true;
      telaPrincipalController
          .visualizarFoto(foto, context)
          .whenComplete(_recarregarPagina);
    });
  }

  void _recarregarPagina() {
    telaPrincipalController.buscarFotos().whenComplete(() {
      setState(() {
        telaPrincipalController.carregando = false;
      });
    });
  }
}
