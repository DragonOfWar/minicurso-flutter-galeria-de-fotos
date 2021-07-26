class Foto {
  int id = 0;
  String? titulo;
  String? descricao;
  DateTime? data;
  double? latitude;
  double? longitude;
  String? imagem;

  Foto({
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.latitude,
    required this.longitude,
    required this.imagem,
  });

  Foto.fromMap(Map<String, dynamic> mapa) {
    id = mapa["id"];
    titulo = mapa["titulo"];
    descricao = mapa["descricao"];
    data = DateTime.parse(mapa["data"]);
    latitude = mapa["latitude"];
    longitude = mapa["longitude"];
    imagem = mapa["imagem"];
  }
}
