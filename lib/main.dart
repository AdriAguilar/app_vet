import 'package:app_vet/firebase_options.dart';
import 'package:app_vet/models/Client.dart';
import 'package:app_vet/models/Pet.dart';
import 'package:app_vet/providers/client_pets_provider.dart';
import 'package:app_vet/providers/client_provider.dart';
import 'package:app_vet/providers/vaccine_provider.dart';
import 'package:app_vet/screens/add_vaccine_screen.dart';
import 'package:app_vet/screens/client_pets_screen.dart';
import 'package:app_vet/screens/dashboard_screen.dart';
import 'package:app_vet/screens/vaccine_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/Vaccine.dart';
import 'providers/pet_provider.dart';
import 'screens/add_client_screen.dart';
import 'screens/client_list_screen.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()..listenToPets()),
        ChangeNotifierProvider(create: (_) => VaccineProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()..listenToClients()),
        ChangeNotifierProvider(create: (_) => ClientPetsProvider()),
      ],
      child: MaterialApp(
        title: 'Veterinaria',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DashboardScreen(),
          '/pet-list': (context) => PetListScreen(),
          '/add-pet': (context) => AddPetScreen(pet: ModalRoute.of(context)?.settings.arguments as Pet?),
          '/vaccine-list': (context) => VaccineListScreen(petId: ModalRoute.of(context)?.settings.arguments as String,),
          '/add-vaccine': (context) => AddVaccineScreen(
            petId: (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['petId'] as String,
            vaccine: (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['vaccine'] as Vaccine?,
          ),
          '/client-list': (context) => ClientListScreen(),
          '/add-client': (context) => AddClientScreen(client: ModalRoute.of(context)?.settings.arguments as Client?),
          '/client-pets': (context) => ClientPetsScreen(clientId: ModalRoute.of(context)?.settings.arguments as String)
        },
      ),
    );
  }
}