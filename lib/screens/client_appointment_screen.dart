import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class ClientAppointmentsScreen extends StatelessWidget {
  final String clientId;

  ClientAppointmentsScreen({required this.clientId});

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    // Escuchar citas del cliente seleccionado
    appointmentProvider.listenToAppointmentsByClient(clientId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Citas del Cliente'),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[50],
      body: appointmentProvider.appointments.isEmpty
          ? Center(child: Text('No hay citas asociadas'))
          : ListView.builder(
              itemCount: appointmentProvider.appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointmentProvider.appointments[index];
                return ListTile(
                  title: Text(appointment.motivo),
                  subtitle: Text('Fecha: ${appointment.fecha.toIso8601String().split('T')[0]}, Estado: ${appointment.estado}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/add-appointment',
                            arguments: {'appointment': appointment, 'clientId': clientId, 'petId': appointment.petId},
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await appointmentProvider.deleteAppointment(appointment.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add-appointment',
            arguments: {'clientId': clientId, 'appointment': null},
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}