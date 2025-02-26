import 'package:app_vet/providers/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pet_service.dart';
import '../models/Pet.dart';

class PetProvider with ChangeNotifier {
  final PetService _petService = PetService();
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  // Escuchar cambios en tiempo real
  void listenToPets() {
    _pets.clear();
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

  void getPetsByClient(String clientId) {
    _pets.clear();
    _petService.getPetsByClient(clientId).listen(
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
  Future<void> deletePet(BuildContext context, String petId) async {
    await _petService.deletePet(petId);

    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    final clients = clientProvider.clients;
    for (final client in clients) {
      if (client.mascotas.contains(petId)) {
        client.mascotas.remove(petId);
        await clientProvider.updateClient(client);
        break;
      }
    }

    notifyListeners();
  }
}