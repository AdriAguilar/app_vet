import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Mascotas'),
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
      body: petProvider.pets.isEmpty
          ? Center(child: Text('No hay mascotas'))
          : ListView.builder(
              itemCount: petProvider.pets.length,
              itemBuilder: (context, index) {
                final pet = petProvider.pets[index];
                return ListTile(
                  title: Text(pet.nombre),
                  subtitle: Text('${pet.tipo}, ${pet.raza}.'),
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
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-pet', arguments: pet);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await petProvider.deletePet(context, pet.id);
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
          Navigator.pushNamed(context, '/add-pet');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}