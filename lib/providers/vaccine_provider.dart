import 'package:flutter/material.dart';
import '../services/vaccine_service.dart';
import '../models/Vaccine.dart';

class VaccineProvider with ChangeNotifier {
  final VaccineService _vaccineService = VaccineService();
  List<Vaccine> _vaccines = [];

  List<Vaccine> get vaccines => _vaccines;

  void listenToVaccines(String petId) {
    _vaccineService.getVaccinesStream(petId).listen(
      (vaccines) {
        try {
          _vaccines = vaccines;
          notifyListeners();
        } catch (e) {
          print('Error procesando vacunas: $e');
        }
      },
      onError: (error) {
        print('Error obteniendo vacunas: $error');
      },
    );
  }

  // Agregar vacuna
  Future<void> addVaccine(Vaccine vaccine) async {
    await _vaccineService.addVaccine(vaccine);
    notifyListeners();
  }

  // Actualizar vacuna
  Future<void> updateVaccine(Vaccine vaccine) async {
    await _vaccineService.updateVaccine(vaccine);
    notifyListeners();
  }

  // Eliminar vacuna
  Future<void> deleteVaccine(String vaccineId) async {
    await _vaccineService.deleteVaccine(vaccineId);
    notifyListeners();
  }
}