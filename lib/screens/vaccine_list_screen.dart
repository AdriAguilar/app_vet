import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vaccine_provider.dart';
import '../models/Vaccine.dart';

class VaccineListScreen extends StatelessWidget {
  final String petId;

  VaccineListScreen({super.key, required this.petId}) : assert(petId != null && petId.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final vaccineProvider = Provider.of<VaccineProvider>(context);

    if (petId != null && petId.isNotEmpty) {
      vaccineProvider.listenToVaccines(petId);
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Vacunas')),
        body: Center(child: Text('No se pudo cargar las vacunas')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Vacunas')),
      body: vaccineProvider.vaccines.isEmpty
          ? Center(child: Text('No hay vacunas'))
          : ListView.builder(
              itemCount: vaccineProvider.vaccines.length,
              itemBuilder: (context, index) {
                final vaccine = vaccineProvider.vaccines[index];
                return ListTile(
                  title: Text(vaccine.nombre),
                  subtitle: Text('Fecha: ${vaccine.fecha}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-vaccine', arguments: {'petId': petId, 'vaccine': vaccine});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await vaccineProvider.deleteVaccine(vaccine.id);
                        },
                      ),
                    ],
                  )
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-vaccine', arguments: {'petId': petId, 'vaccine': null});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}