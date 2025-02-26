import 'dart:convert';

class Pet {
  String id;
  String chip;
  String tipo;
  String raza;
  String nombre;
  double peso;
  int idPropietario;
  DateTime fechaNacimiento;
  String? observaciones;

  Pet({
    this.id = '',
    required this.chip,
    required this.tipo,
    required this.raza,
    required this.nombre,
    required this.peso,
    required this.idPropietario,
    required this.fechaNacimiento,
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chip': chip,
      'tipo': tipo,
      'raza': raza,
      'nombre': nombre,
      'peso': peso,
      'idPropietario': idPropietario,
      'fechaNacimiento': fechaNacimiento.toIso8601String().split('T')[0],
      'observaciones': observaciones,
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json, String id) {
    try {
      return Pet(
        id: id,
        chip: json['chip']?.toString() ?? '',
        tipo: json['tipo']?.toString() ?? '',
        raza: json['raza']?.toString() ?? '',
        nombre: json['nombre']?.toString() ?? '',
        peso: double.tryParse(json['peso']?.toString() ?? '0') ?? 0.0,
        idPropietario: int.tryParse(json['idPropietario']?.toString() ?? '0') ?? 0,
        fechaNacimiento: DateTime.tryParse(json['fechaNacimiento']?.toString() ?? '') ?? DateTime.now(),
        observaciones: json['observaciones']?.toString() ?? '',
      );
    } catch (e) {
      print('Error al procesar mascota con ID $id: $e');
      rethrow; // Propagar el error para que sea capturado más arriba
    }
  }
}