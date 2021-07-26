import 'package:flutter/material.dart';

class TelaCadastro extends StatelessWidget {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final Image imagem;
  TelaCadastro({
    Key? key,
    required this.imagem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de foto"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            Container(
              height: 384,
              child: imagem,
            ),
            Divider(),
            _entradaTexto(nome: "Titulo", controller: tituloController),
            _entradaTexto(nome: "Descricao", controller: descricaoController),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _terminarCadastro(context);
                    },
                    child: const Text("Salvar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _cancelarCadastro(context);
                    },
                    child: const Text("Cancelar"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _entradaTexto({
    String nome = "Entrada",
    required TextEditingController controller,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          Text(nome),
          TextField(controller: controller),
        ]),
      );

  void _terminarCadastro(BuildContext context) {
    Navigator.pop(context, [tituloController.text, descricaoController.text]);
  }

  void _cancelarCadastro(BuildContext context) {
    Navigator.pop(context, null);
  }
}
