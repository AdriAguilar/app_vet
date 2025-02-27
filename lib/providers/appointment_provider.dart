import 'package:flutter/material.dart';
import '../services/appointment_service.dart';
import '../models/Appointment.dart';

class AppointmentProvider with ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  List<Appointment> _appointments = [];
  String? _clientId;
  String? _petId;

  List<Appointment> get appointments => _appointments;

  // Escuchar citas por cliente
  void listenToAppointmentsByClient(String clientId) {
    if (_clientId == clientId) return;

    _clientId = clientId;
    _petId = null;
    _appointments.clear();
    _appointmentService.getAppointmentsByClient(clientId).listen((appointments) {
      _appointments = appointments;
      notifyListeners();
    });
  }

  // Escuchar citas por mascota
  void listenToAppointmentsByPet(String petId) {
    if (_petId == petId) return;

    _petId = petId;
    _clientId = null;
    _appointments.clear();
    _appointmentService.getAppointmentsByPet(petId).listen((appointments) {
      _appointments = appointments;
      notifyListeners();
    });
  }

  // Agregar cita
  Future<void> addAppointment(Appointment appointment) async {
    await _appointmentService.addAppointment(appointment);
    notifyListeners();
  }

  // Actualizar cita
  Future<void> updateAppointment(Appointment appointment) async {
    await _appointmentService.updateAppointment(appointment);
    notifyListeners();
  }

  // Eliminar cita
  Future<void> deleteAppointment(String appointmentId) async {
    await _appointmentService.deleteAppointment(appointmentId);
    notifyListeners();
  }

  // Limpiar listener
  void clearListener() {
    _clientId = null;
    _petId = null;
    _appointments.clear();
    notifyListeners();
  }
}