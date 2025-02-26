import 'package:app_vet/ui/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextInput(
                controller: _emailController,
                label: 'Correo Electrónico',
                hint: "ejemplo@email.com",
                validator: (value) => value!.isEmpty ? 'Requerido' : null,  
              ),
              SizedBox(height: 10),
              CustomTextInput(
                controller: _passwordController,
                obscure: true,
                label: 'Contraseña',
                hint: "Contraseña segura",
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _signIn(context),
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = await authProvider.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Inicio de sesión exitoso'), backgroundColor: Colors.green,));
        Navigator.pushNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credenciales inválidas'), backgroundColor: Colors.red));
      }
    }
  }
}