import 'package:app_vet/models/Pet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../models/Pet.dart';
import '../ui/custom_text_input.dart';

class AddPetScreen extends StatelessWidget {

  final Pet? pet;

  AddPetScreen({super.key, this.pet});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _chipController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _idPropietarioController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();


  Future<void> _savePet(BuildContext context) async {
    if (_formKey.currentState!.validate()) {

      DateTime fechaNacimiento;
      try {
        fechaNacimiento = DateTime.parse(_fechaNacimientoController.text); // Parsear la fecha
      } catch (e) {
        print('Error al parsear la fecha: ${_fechaNacimientoController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Formato de fecha inválido')),
        );
        return;
      }

      final newPet = Pet(
        id: pet?.id ?? '',
        chip: _chipController.text,
        tipo: _tipoController.text,
        raza: _razaController.text,
        nombre: _nombreController.text,
        peso: double.tryParse(_pesoController.text) ?? 0.0,
        idPropietario: int.tryParse(_idPropietarioController.text) ?? 0,
        fechaNacimiento: fechaNacimiento,
        observaciones: _observacionesController.text,
      );

      try {
        if (pet != null) {
          await Provider.of<PetProvider>(context, listen: false).updatePet(newPet);
        } else {
          await Provider.of<PetProvider>(context, listen: false).addPet(newPet);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(pet != null ? "Mascota actualizada correctamente." : 'Mascota creada correctamente.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Aceptar", 
              onPressed: () {}
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error al guardar la mascota'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pet != null) {
      _chipController.text = pet!.chip;
      _tipoController.text = pet!.tipo;
      _razaController.text = pet!.raza;
      _nombreController.text = pet!.nombre;
      _pesoController.text = pet!.peso.toString();
      _idPropietarioController.text = pet!.idPropietario.toString();
      _fechaNacimientoController.text = pet!.fechaNacimiento.toIso8601String().split('T')[0];
      _observacionesController.text = pet!.observaciones ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Agregar Mascota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Chip
              CustomTextInput(
                controller: _chipController,
                label: 'Chip',
                hint: 'Ingrese el número de chip',
                filled: true,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Tipo
              CustomTextInput(
                controller: _tipoController,
                label: 'Tipo',
                hint: 'Ejemplo: Perro, Gato, etc.',
                filled: true,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Raza
              CustomTextInput(
                controller: _razaController,
                label: 'Raza',
                hint: 'Ejemplo: Labrador, Siames, etc.',
                filled: true,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Nombre
              CustomTextInput(
                controller: _nombreController,
                label: 'Nombre',
                hint: 'Nombre de la mascota',
                filled: true,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Peso
              CustomTextInput(
                controller: _pesoController,
                label: 'Peso (kg)',
                hint: 'Ejemplo: 5.5',
                filled: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo ID Propietario
              CustomTextInput(
                controller: _idPropietarioController,
                label: 'ID Propietario',
                hint: 'Ejemplo: 12345',
                filled: true,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Fecha de Nacimiento
              CustomTextInput(
                controller: _fechaNacimientoController,
                label: 'Fecha de Nacimiento',
                hint: 'Formato: YYYY-MM-DD',
                filled: true,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  final isValidDate = DateTime.tryParse(value) != null;
                  return isValidDate ? null : 'Formato de fecha inválido';
                },
              ),
              SizedBox(height: 10),

              // Campo Observaciones
              CustomTextInput(
                controller: _observacionesController,
                label: 'Observaciones',
                hint: 'Anotaciones adicionales',
                filled: true,
              ),
              SizedBox(height: 20),

              // Botón Guardar
              ElevatedButton(
                onPressed: () => _savePet(context),
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}