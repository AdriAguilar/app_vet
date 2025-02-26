import 'package:app_vet/providers/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';
import '../models/Pet.dart';
import '../ui/custom_text_input.dart';

class AddPetScreen extends StatefulWidget {

  final Pet? pet;

  AddPetScreen({super.key, this.pet});

  @override
  _AddPetScreenState createState() => _AddPetScreenState();

}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _chipController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();

  String? selectedClientId;


  Future<void> _savePet(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (selectedClientId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debes seleccionar un propietario')),
        );
        return;
      }

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
        id: widget.pet?.id ?? '',
        chip: _chipController.text,
        tipo: _tipoController.text,
        raza: _razaController.text,
        nombre: _nombreController.text,
        peso: double.tryParse(_pesoController.text) ?? 0.0,
        idPropietario: selectedClientId!,
        fechaNacimiento: fechaNacimiento,
        observaciones: _observacionesController.text,
      );

      try {
        if (widget.pet != null) {
          await Provider.of<PetProvider>(context, listen: false).updatePet(newPet);
        } else {
          await Provider.of<PetProvider>(context, listen: false).addPet(newPet);
        }

        final clientProvider = Provider.of<ClientProvider>(context, listen: false);
        final client = clientProvider.clients.firstWhere((c) => c.id == selectedClientId);
        if (client != null) {
          client.mascotas.add(newPet.id); // Agregar el ID de la mascota
          await clientProvider.updateClient(client); // Actualizar el cliente en Firebase
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.pet != null ? "Mascota actualizada correctamente." : 'Mascota creada correctamente.'), backgroundColor: Colors.green),
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
    final clientProvider = Provider.of<ClientProvider>(context);
    final clients = clientProvider.clients;

    if (widget.pet != null) {
      _chipController.text = widget.pet!.chip;
      _tipoController.text = widget.pet!.tipo;
      _razaController.text = widget.pet!.raza;
      _nombreController.text = widget.pet!.nombre;
      _pesoController.text = widget.pet!.peso.toString();
      selectedClientId = widget.pet!.idPropietario.toString();
      _fechaNacimientoController.text = widget.pet!.fechaNacimiento.toIso8601String().split('T')[0];
      _observacionesController.text = widget.pet!.observaciones ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Mascota'),
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
              // Campo Chip
              CustomTextInput(
                controller: _chipController,
                label: 'Chip',
                hint: 'Ingrese el número de chip',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Tipo
              CustomTextInput(
                controller: _tipoController,
                label: 'Tipo',
                hint: 'Ejemplo: Perro, Gato, etc.',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Raza
              CustomTextInput(
                controller: _razaController,
                label: 'Raza',
                hint: 'Ejemplo: Labrador, Siames, etc.',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Nombre
              CustomTextInput(
                controller: _nombreController,
                label: 'Nombre',
                hint: 'Nombre de la mascota',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo Peso
              CustomTextInput(
                controller: _pesoController,
                label: 'Peso (kg)',
                hint: 'Ejemplo: 5.5',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),

              // Campo ID Propietario
              DropdownButtonFormField<String>(
                value: selectedClientId,
                items: clients.map((client) {
                  return DropdownMenuItem(
                    value: client.id,
                    child: Container(
                      child: Text(client.nombre),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClientId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Propietario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) => value == null ? 'Selecciona un propietario' : null,
              ),
              SizedBox(height: 10),

              // Campo Fecha de Nacimiento
              CustomTextInput(
                controller: _fechaNacimientoController,
                label: 'Fecha de Nacimiento',
                hint: 'Formato: YYYY-MM-DD',
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
              ),
              SizedBox(height: 20),

              // Botón Guardar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
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