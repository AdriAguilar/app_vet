import 'package:app_vet/providers/client_pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';
import '../models/Pet.dart';

class ClientPetsScreen extends StatelessWidget {
  final String clientId;

  const ClientPetsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final clientPetsProvider = Provider.of<ClientPetsProvider>(context);

    clientPetsProvider.listenToClientPets(clientId);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        clientPetsProvider.clearListener();
        return true;
      }, 
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mascotas del Cliente'),
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
        body: clientPetsProvider.pets.isEmpty
            ? Center(child: Text('No hay mascotas asociadas'))
            : ListView.builder(
                itemCount: clientPetsProvider.pets.length,
                itemBuilder: (context, index) {
                  final pet = clientPetsProvider.pets[index];
                  return ListTile(
                    title: Text(pet.nombre),
                    subtitle: Text('${pet.raza}, ${pet.peso} kg'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.medical_services),
                          onPressed: () {
                            if (pet.id != null && pet.id.isNotEmpty) {
                              Navigator.pushNamed(
                                context,
                                '/vaccine-list',
                                arguments: pet.id,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No se pudo cargar las vacunas para esta mascota')),
                              );
                            }
                          },
                        ),
                      ]
                    )
                  );
                },
              ),
      )
    );
  }
}