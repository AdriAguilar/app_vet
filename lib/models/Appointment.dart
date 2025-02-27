import 'dart:convert';

class Appointment {
  String id;
  String petId;
  String clientId;
  DateTime fecha;
  String motivo;
  String estado;
  String observaciones;

  Appointment({
    required this.id,
    required this.petId,
    required this.clientId,
    required this.fecha,
    required this.motivo,
    required this.estado,
    required this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'clientId': clientId,
      'fecha': fecha.toIso8601String().split('T')[0],
      'motivo': motivo,
      'estado': estado,
      'observaciones': observaciones,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json, String id) {
    try {
      return Appointment(
        id: id,
        petId: json['petId']?.toString() ?? '',
        clientId: json['clientId']?.toString() ?? '',
        fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
        motivo: json['motivo']?.toString() ?? '',
        estado: json['estado']?.toString() ?? 'pendiente',
        observaciones: json['observaciones']?.toString() ?? '',
      );
    } catch (e) {
      print('Error al procesar cita con ID $id: $e');
      rethrow;
    }
  }
}