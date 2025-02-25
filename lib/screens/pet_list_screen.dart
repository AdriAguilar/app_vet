import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../models/Pet.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Lista de Mascotas')),
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-pet', arguments: pet);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await petProvider.deletePet(pet.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-pet');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}