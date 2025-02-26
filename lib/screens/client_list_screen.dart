import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/client_provider.dart';
import '../models/Client.dart';

class ClientListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
          ),
        ],
      ),
      backgroundColor: Colors.indigo[50],
      body: clientProvider.clients.isEmpty
          ? Center(child: Text('No hay clientes'))
          : ListView.builder(
              itemCount: clientProvider.clients.length,
              itemBuilder: (context, index) {
                final client = clientProvider.clients[index];
                return ListTile(
                  title: Text(client.nombre),
                  subtitle: Text('Teléfono: ${client.telefono}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.pets),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/client-pets',
                            arguments: client.id,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/add-client',
                            arguments: client,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await clientProvider.deleteClient(client.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/add-client', arguments: null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}