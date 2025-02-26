import 'package:flutter/material.dart';
import '../services/pet_service.dart';
import '../models/Pet.dart';

class ClientPetsProvider with ChangeNotifier {
  final PetService _petService = PetService();
  List<Pet> _pets = [];
  String? _clientId;

  List<Pet> get pets => _pets;

  // Escuchar mascotas de un cliente específico
  void listenToClientPets(String clientId) {
    if (_clientId == clientId) return; // Evitar duplicar listeners

    _clientId = clientId;
    _pets.clear(); // Limpiar lista anterior
    _petService.getPetsByClient(clientId).listen((pets) {
      _pets = pets;
      notifyListeners();
    });
  }

  // Limpiar el listener cuando ya no sea necesario
  void clearListener() {
    _clientId = null;
    _pets.clear();
    notifyListeners();
  }
}