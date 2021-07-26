import 'package:trabalhofinal/model/foto.dart';
import 'package:trabalhofinal/persistencia/bando_de_dados.dart';

class FotosRepository {
  final String sqlSelect = "SELECT * FROM fotos";
  final String sqlInsert =
      "INSERT INTO fotos(titulo, descricao, data, latitude, longitude, imagem) VALUES (?, ?, ?, ?, ?, ?)";
  final String sqlUpdate = "UPDATE fotos SET titulo=?, descricao=? WHERE id=?";
  final String sqlDelete = "DELETE FROM fotos WHERE id=?";
  final String sqlDeleteAll = "DELETE FROM fotos";

  Future<List<Foto>> selectAll() async {
    List<Foto> fotos = [];
    List<Map<String, dynamic>> mapas = await BancoDeDados().db!.query("fotos");
    for (var foto in mapas) {
      fotos.add(Foto.fromMap(foto));
    }

    return fotos;
  }

  Future<void> insert(Foto foto) async {
    foto.id = await BancoDeDados().db!.rawInsert(sqlInsert, [
      foto.titulo,
      foto.descricao,
      foto.data.toString(),
      foto.latitude,
      foto.longitude,
      foto.imagem
    ]);
    return;
  }

  Future<void> update(Foto foto) async {
    await BancoDeDados().db!.rawUpdate(sqlUpdate, [
      foto.titulo,
      foto.descricao,
      foto.id,
    ]);
    return;
  }

  Future<void> delete(Foto foto) async {
    await BancoDeDados().db!.rawDelete(sqlDelete, [foto.id]);
    return;
  }

  Future<void> deleteAll() async {
    await BancoDeDados().db!.rawDelete(sqlDeleteAll);
    return;
  }
}
