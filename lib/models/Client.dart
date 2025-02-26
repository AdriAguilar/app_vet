class Client {
  String id;
  String nombre;
  String telefono;
  String email;
  String direccion;
  List<String> mascotas;

  Client({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.direccion,
    this.mascotas = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'mascotas': mascotas,
    };
  }

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    return Client(
      id: id,
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? '',
      mascotas: (json['mascotas'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }
}