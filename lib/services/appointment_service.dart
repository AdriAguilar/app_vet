import 'package:firebase_database/firebase_database.dart';
import '../models/Appointment.dart';

class AppointmentService {
  final DatabaseReference _appointmentsRef = FirebaseDatabase.instance.ref('appointments');

  // Obtener lista de citas por cliente
  Stream<List<Appointment>> getAppointmentsByClient(String clientId) {
    return _appointmentsRef.orderByChild('clientId').equalTo(clientId).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries
          .where((entry) => entry.value is Map)
          .map((entry) {
            try {
              final appointmentData = Map<String, dynamic>.from(entry.value as Map);
              return Appointment.fromJson(appointmentData, entry.key);
            } catch (e) {
              print('Error al procesar cita con ID ${entry.key}: $e');
              return null;
            }
          })
          .whereType<Appointment>()
          .toList();
    });
  }

  // Obtener lista de citas por mascota
  Stream<List<Appointment>> getAppointmentsByPet(String petId) {
    return _appointmentsRef.orderByChild('petId').equalTo(petId).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries
          .where((entry) => entry.value is Map)
          .map((entry) {
            try {
              final appointmentData = Map<String, dynamic>.from(entry.value as Map);
              return Appointment.fromJson(appointmentData, entry.key);
            } catch (e) {
              print('Error al procesar cita con ID ${entry.key}: $e');
              return null;
            }
          })
          .whereType<Appointment>()
          .toList();
    });
  }

  // Agregar cita
  Future<void> addAppointment(Appointment appointment) async {
    final newAppointmentRef = _appointmentsRef.push();
    appointment.id = newAppointmentRef.key!;
    await newAppointmentRef.set(appointment.toJson());
  }

  // Actualizar cita
  Future<void> updateAppointment(Appointment appointment) async {
    await _appointmentsRef.child(appointment.id).update(appointment.toJson());
  }

  // Eliminar cita
  Future<void> deleteAppointment(String appointmentId) async {
    await _appointmentsRef.child(appointmentId).remove();
  }
}