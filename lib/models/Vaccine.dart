import 'dart:convert';

class Vaccine {
  String id;
  String petId; // ID de la mascota asociada
  String nombre;
  String fecha; // Formato YYYY-MM-DD
  String? proximaFecha; // Opcional, formato YYYY-MM-DD
  String observaciones;

  Vaccine({
    this.id = '',
    required this.petId,
    required this.nombre,
    required this.fecha,
    this.proximaFecha,
    required this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'nombre': nombre,
      'fecha': fecha,
      'proximaFecha': proximaFecha,
      'observaciones': observaciones,
    };
  }

  factory Vaccine.fromJson(Map<String, dynamic> json, String id) {
    return Vaccine(
      id: id,
      petId: json['petId']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      fecha: json['fecha']?.toString() ?? '',
      proximaFecha: json['proximaFecha']?.toString() ?? '',
      observaciones: json['observaciones']?.toString() ?? '',
    );
  }
}