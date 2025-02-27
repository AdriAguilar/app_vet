import 'package:app_vet/providers/pet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../models/Appointment.dart';
import '../providers/client_provider.dart';
import '../ui/custom_text_input.dart';

class AddAppointmentScreen extends StatefulWidget {
  final String? clientId;
  final Appointment? appointment;

  AddAppointmentScreen({
    super.key, 
    this.clientId,
    this.appointment,
  });
  
  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();

  String? _selectedPetId;

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final pets = petProvider.pets;

    if (widget.appointment != null) {
      _selectedPetId = widget.appointment!.petId.toString();
      _motivoController.text = widget.appointment!.motivo;
      _fechaController.text = widget.appointment!.fecha.toIso8601String().split('T')[0]; // Solo la fecha
      _observacionesController.text = widget.appointment!.observaciones;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment != null ? 'Editar Cita' : 'Agregar Cita'),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedPetId,
                items: pets
                  .where((pet) => pet.idPropietario == widget.clientId)
                  .map((pet) {
                    return DropdownMenuItem(
                      value: pet.id,
                      child: Container(
                        child: Text(pet.nombre),
                      ),
                    );
                  }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPetId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Mascota',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) => value == null ? 'Selecciona una mascota' : null,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _motivoController,
                label: 'Motivo',
                hint: 'Ejemplo: Vacunación',
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
                onPressed: () => _saveAppointment(context),
                child: Text(widget.appointment != null ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAppointment(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_selectedPetId == null || _selectedPetId!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecciona una mascota')));
          return;
        }

        DateTime fechaCita;
        try {
          fechaCita = DateTime.parse(_fechaController.text); // Parsear la fecha
        } catch (e) {
          print('Error al parsear la fecha: ${_fechaController.text}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Formato de fecha inválido')),
          );
          return;
        }

        final updatedAppointment = Appointment(
          id: widget.appointment?.id ?? '',
          petId: _selectedPetId!,
          clientId: widget.clientId ?? widget.appointment?.clientId ?? '',
          fecha: fechaCita,
          motivo: _motivoController.text,
          estado: 'pendiente',
          observaciones: _observacionesController.text,
        );

        if (widget.appointment != null) {
          await Provider.of<AppointmentProvider>(context, listen: false).updateAppointment(updatedAppointment);
        } else {
          await Provider.of<AppointmentProvider>(context, listen: false).addAppointment(updatedAppointment);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.appointment != null ? 'Cita actualizada correctamente' : 'Cita creada correctamente')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error al guardar la cita: $e')),
        );
      }
    }
  }
}