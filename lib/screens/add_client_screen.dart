import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/client_provider.dart';
import '../models/Client.dart';
import '../ui/custom_text_input.dart';

class AddClientScreen extends StatelessWidget {
  final Client? client;

  AddClientScreen({super.key, this.client});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if (client != null) {
      _nombreController.text = client!.nombre;
      _telefonoController.text = client!.telefono;
      _emailController.text = client!.email;
      _direccionController.text = client!.direccion;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(client != null ? 'Editar Cliente' : 'Agregar Cliente'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextInput(
                controller: _nombreController,
                label: 'Nombre',
                hint: 'Nombre completo',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _telefonoController,
                label: 'Teléfono',
                hint: 'Número de teléfono',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _emailController,
                label: 'Email',
                hint: 'Dirección de correo electrónico',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _direccionController,
                label: 'Dirección',
                hint: 'Dirección física',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveClient(context),
                child: Text(client != null ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveClient(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final updatedClient = Client(
        id: client?.id ?? '', // Usar el ID existente si estamos editando
        nombre: _nombreController.text,
        telefono: _telefonoController.text,
        email: _emailController.text,
        direccion: _direccionController.text,
        mascotas: client?.mascotas ?? [], // Mantener las mascotas asociadas
      );

      if (client != null) {
        await Provider.of<ClientProvider>(context, listen: false).updateClient(updatedClient);
      } else {
        await Provider.of<ClientProvider>(context, listen: false).addClient(updatedClient);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(client != null ? 'Cliente actualizado correctamente' : 'Cliente creado correctamente'), backgroundColor: Colors.green),
      );

      Navigator.pop(context);
    }
  }
}