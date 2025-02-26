import 'package:flutter/material.dart';
import '../services/client_service.dart';
import '../models/Client.dart';

class ClientProvider with ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];

  List<Client> get clients => _clients;

  void listenToClients() {
    _clientService.clientsStream.listen(
      (clients) {
        try {
          _clients = clients;
          notifyListeners();
        } catch (e) {
          print('Error procesando clientes: $e');
        }
      },
      onError: (error) {
        print('Error obteniendo clientes: $error');
      },
    );
  }

  // Agregar cliente
  Future<void> addClient(Client client) async {
    await _clientService.addClient(client);
    notifyListeners();
  }

  // Actualizar cliente
  Future<void> updateClient(Client client) async {
    await _clientService.updateClient(client);
    notifyListeners();
  }

  // Eliminar cliente
  Future<void> deleteClient(String clientId) async {
    await _clientService.deleteClient(clientId);
    notifyListeners();
  }
}