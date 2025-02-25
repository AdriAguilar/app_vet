import 'package:app_vet/firebase_options.dart';
import 'package:app_vet/models/Pet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';
import 'screens/pet_list_screen.dart';
import 'screens/add_pet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()..listenToPets()),
      ],
      child: MaterialApp(
        title: 'Veterinaria',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/pet-list',
        routes: {
          '/pet-list': (context) => PetListScreen(),
          '/add-pet': (context) => AddPetScreen(pet: ModalRoute.of(context)?.settings.arguments as Pet?,),
        },
      ),
    );
  }
}