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