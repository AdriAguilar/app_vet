import 'package:firebase_database/firebase_database.dart';
import '../models/Vaccine.dart';

class VaccineService {
  final DatabaseReference _vaccinesRef = FirebaseDatabase.instance.ref('vaccines');

  Stream<List<Vaccine>> getVaccinesStream(String petId) {
  return _vaccinesRef.orderByChild('petId').equalTo(petId).onValue.map((event) {
    final data = event.snapshot.value;

    if (data == null) return [];

    final mapData = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);

    return mapData.entries
        .where((entry) => entry.value is Map)
        .map((entry) {
          try {
            return Vaccine.fromJson(Map<String, dynamic>.from(entry.value), entry.key);
          } catch (e) {
            print('Error al procesar vacuna con ID ${entry.key}: $e');
            return null;
          }
        })
        .whereType<Vaccine>()
        .toList();
  });
}

  // Agregar vacuna
  Future<void> addVaccine(Vaccine vaccine) async {
    final newVaccineRef = _vaccinesRef.push();
    vaccine.id = newVaccineRef.key!;
    await newVaccineRef.set(vaccine.toJson());
  }

  // Actualizar vacuna
  Future<void> updateVaccine(Vaccine vaccine) async {
    await _vaccinesRef.child(vaccine.id).update(vaccine.toJson());
  }

  // Eliminar vacuna
  Future<void> deleteVaccine(String vaccineId) async {
    await _vaccinesRef.child(vaccineId).remove();
  }
}