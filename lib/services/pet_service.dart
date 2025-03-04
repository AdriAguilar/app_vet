import 'package:firebase_database/firebase_database.dart';
import '../models/Pet.dart';

class PetService {
  final DatabaseReference _petsRef = FirebaseDatabase.instance.ref('pets');

  Map<String, dynamic> convertToMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data.map((key, value) {
        return MapEntry(key.toString(), value);
      }));
    }
    return {};
  }

  Stream<List<Pet>> get petsStream {
    return _petsRef.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) return [];

      final mapData = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);

      return mapData.entries
          .where((entry) => entry.value is Map)
          .map((entry) {
            try {
              return Pet.fromJson(Map<String, dynamic>.from(entry.value), entry.key);
            } catch (e) {
              print('Error al procesar mascota con ID ${entry.key}: $e');
              return null;
            }
          })
          .whereType<Pet>()
          .toList();
    });
  }

  Stream<List<Pet>> getPetsByClient(String clientId) {
    final clientRef = FirebaseDatabase.instance.ref('clients/$clientId');

    return clientRef.onValue.asyncMap((clientEvent) async {
      final clientData = clientEvent.snapshot.value as Map<dynamic, dynamic>?;

      if (clientData == null || !clientData.containsKey('mascotas')) {
        print('El cliente con ID $clientId no tiene mascotas.');
        return [];
      }

      // Asegurarse de que mascotas sea una lista
      final petIds = (clientData['mascotas'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
      if (petIds.isEmpty) {
        print('El cliente con ID $clientId no tiene mascotas asociadas.');
        return [];
      }

      // Obtener todas las mascotas por IDs
      final petsRef = FirebaseDatabase.instance.ref('pets');
      final petsSnapshot = await petsRef.get();

      if (!petsSnapshot.exists) {
        print('No se encontraron mascotas en Firebase.');
        return [];
      }

      // Convertir datos a Map<String, dynamic>
      final petsData = Map<String, dynamic>.from(petsSnapshot.value as Map<dynamic, dynamic>);

      // Filtrar solo las mascotas asociadas al cliente
      return petIds
          .where((petId) => petsData.containsKey(petId)) // Solo IDs válidos
          .map((petId) {
            try {
              // Convertir explícitamente a Map<String, dynamic>
              final petData = Map<String, dynamic>.from(petsData[petId] as Map<dynamic, dynamic>);
              return Pet.fromJson(petData, petId);
            } catch (e) {
              print('Error al procesar mascota con ID $petId: $e');
              return null;
            }
          })
          .whereType<Pet>() // Filtrar entradas nulas
          .toList();
    });
  }

  Future<void> addPet(Pet pet) async {
    final newPetRef = _petsRef.push();
    pet.id = newPetRef.key!;
    await newPetRef.set(pet.toJson());
  }

  Future<void> updatePet(Pet pet) async {
    await _petsRef.child(pet.id).update(pet.toJson());
  }

  Future<void> deletePet(String petId) async {
    await _petsRef.child(petId).remove();
  }
}