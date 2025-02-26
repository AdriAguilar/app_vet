import 'package:app_vet/firebase_options.dart';
import 'package:app_vet/models/Client.dart';
import 'package:app_vet/models/Pet.dart';
import 'package:app_vet/providers/auth_provider.dart';
import 'package:app_vet/providers/client_pets_provider.dart';
import 'package:app_vet/providers/client_provider.dart';
import 'package:app_vet/providers/vaccine_provider.dart';
import 'package:app_vet/screens/add_vaccine_screen.dart';
import 'package:app_vet/screens/client_pets_screen.dart';
import 'package:app_vet/screens/dashboard_screen.dart';
import 'package:app_vet/screens/login_screen.dart';
import 'package:app_vet/screens/vaccine_list_screen.dart';
import 'package:app_vet/widgets/auth_check.dart';
import 'package:app_vet/widgets/protected_route.dart';
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        home: AuthCheck(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/dashboard': (context) => ProtectedRoute(child: DashboardScreen()),
          '/pet-list': (context) => ProtectedRoute(child: PetListScreen()),
          '/add-pet': (context) => ProtectedRoute(child: AddPetScreen(pet: ModalRoute.of(context)?.settings.arguments as Pet?)),
          '/vaccine-list': (context) => ProtectedRoute(child: VaccineListScreen(petId: ModalRoute.of(context)?.settings.arguments as String,)),
          '/add-vaccine': (context) => ProtectedRoute(child: AddVaccineScreen(
            petId: (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['petId'] as String,
            vaccine: (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['vaccine'] as Vaccine?,
          )),
          '/client-list': (context) => ProtectedRoute(child: ClientListScreen()),
          '/add-client': (context) => ProtectedRoute(child: AddClientScreen(client: ModalRoute.of(context)?.settings.arguments as Client?)),
          '/client-pets': (context) => ProtectedRoute(child: ClientPetsScreen(clientId: ModalRoute.of(context)?.settings.arguments as String))
        },
      ),
    );
  }
}