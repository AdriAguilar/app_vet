import 'package:flutter/material.dart';
import '../services/pet_service.dart';
import '../models/Pet.dart';

class PetProvider with ChangeNotifier {
  final PetService _petService = PetService();
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  // Escuchar cambios en tiempo real
  void listenToPets() {
    _petService.petsStream.listen(
      (pets) {
        try {
          _pets = pets;
          notifyListeners();
        } catch (e) {
          print('Error procesando mascotas: $e');
        }
      },
      onError: (error) {
        print('Error obteniendo mascotas: $error');
      },
    );
  }

  // Agregar mascota
  Future<void> addPet(Pet pet) async {
    await _petService.addPet(pet);
    notifyListeners();
  }

  // Actualizar mascota
  Future<void> updatePet(Pet pet) async {
    await _petService.updatePet(pet);
    notifyListeners();
  }

  // Eliminar mascota
  Future<void> deletePet(String petId) async {
    await _petService.deletePet(petId);
    notifyListeners();
  }
}