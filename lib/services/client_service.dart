import 'package:firebase_database/firebase_database.dart';
import '../models/Client.dart';

class ClientService {
  final DatabaseReference _clientsRef = FirebaseDatabase.instance.ref('clients');

  Stream<List<Client>> get clientsStream {
    return _clientsRef.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) return [];

      final mapData = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);

      return mapData.entries
          .where((entry) => entry.value is Map)
          .map((entry) {
            try {
              return Client.fromJson(Map<String, dynamic>.from(entry.value), entry.key);
            } catch(e) {
              print('Error parsing client data: $e');
              return null;
            }
          })
          .whereType<Client>()
          .toList();
    });
  }

  // Agregar cliente
  Future<void> addClient(Client client) async {
    final newClientRef = _clientsRef.push();
    client.id = newClientRef.key!;
    await newClientRef.set(client.toJson());
  }

  // Actualizar cliente
  Future<void> updateClient(Client client) async {
    await _clientsRef.child(client.id).update(client.toJson());
  }

  // Eliminar cliente
  Future<void> deleteClient(String clientId) async {
    await _clientsRef.child(clientId).remove();
  }
}