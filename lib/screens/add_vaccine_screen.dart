import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vaccine_provider.dart';
import '../models/Vaccine.dart';
import '../ui/custom_text_input.dart';

class AddVaccineScreen extends StatelessWidget {
  final String petId;
  final Vaccine? vaccine;

  AddVaccineScreen({super.key, required this.petId, this.vaccine}) : assert(petId != null && petId.isNotEmpty);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _proximaFechaController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (vaccine != null) {
      _nombreController.text = vaccine!.nombre;
      _fechaController.text = vaccine!.fecha;
      _proximaFechaController.text = vaccine!.proximaFecha ?? '';
      _observacionesController.text = vaccine!.observaciones;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vaccine != null ? 'Editar Vacuna' : 'Agregar Vacuna'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextInput(
                controller: _nombreController,
                label: 'Nombre',
                hint: 'Ejemplo: Rabia',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _fechaController,
                label: 'Fecha',
                hint: 'Formato: YYYY-MM-DD',
                keyboardType: TextInputType.datetime,
                validator: (value) => DateTime.tryParse(value!) == null ? 'Formato inválido' : null,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _proximaFechaController,
                label: 'Próxima Fecha',
                hint: 'Formato: YYYY-MM-DD (opcional)',
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _observacionesController,
                label: 'Observaciones',
                hint: 'Notas adicionales',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _saveVaccine(context),
                child: Text(vaccine != null ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveVaccine(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedVaccine = Vaccine(
          id: vaccine?.id ?? '',
          petId: petId,
          nombre: _nombreController.text,
          fecha: _fechaController.text,
          proximaFecha: _proximaFechaController.text.isNotEmpty ? _proximaFechaController.text : null,
          observaciones: _observacionesController.text,
        );

        if (vaccine != null) {
          await Provider.of<VaccineProvider>(context, listen: false).updateVaccine(updatedVaccine);
        } else {
          await Provider.of<VaccineProvider>(context, listen: false).addVaccine(updatedVaccine);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vaccine != null ? 'Vacuna actualizada correctamente' : 'Vacuna creada correctamente'), backgroundColor: Colors.green),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error al guardar la vacuna: $e')),
        );
      }
    }
  }
}