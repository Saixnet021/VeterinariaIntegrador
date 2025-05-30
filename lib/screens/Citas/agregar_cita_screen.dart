import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgregarCitaScreen extends StatefulWidget {
  const AgregarCitaScreen({super.key});

  @override
  State<AgregarCitaScreen> createState() => _AgregarCitaScreenState();
}

class _AgregarCitaScreenState extends State<AgregarCitaScreen> {
  String? clienteId;
  String? pacienteId;
  String? doctorId;
  String motivo = '';
  DateTime? fechaHora;

  List<DocumentSnapshot> clientes = [];
  List<DocumentSnapshot> pacientes = [];
  List<DocumentSnapshot> doctores = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final clientesSnap =
        await FirebaseFirestore.instance.collection('clientes').get();
    final doctoresSnap =
        await FirebaseFirestore.instance.collection('doctores').get();

    setState(() {
      clientes = clientesSnap.docs;
      doctores = doctoresSnap.docs;
    });
  }

  Future<void> cargarPacientes(String clienteId) async {
    print("Cargando pacientes para el cliente con ID: $clienteId");

    final pacientesSnap =
        await FirebaseFirestore.instance
            .collection('pacientes')
            .where('clienteId', isEqualTo: clienteId)
            .get();

    if (pacientesSnap.docs.isEmpty) {
      print("No se encontraron pacientes para el cliente $clienteId");
    } else {
      print("Pacientes encontrados: ${pacientesSnap.docs.length}");
      pacientesSnap.docs.forEach((doc) {
        print("Paciente: ${doc['nombre']} - ClienteID: ${doc['clienteId']}");
      });
    }

    setState(() {
      pacientes = pacientesSnap.docs;
    });
  }

  Future<void> guardarCita() async {
    if (clienteId == null ||
        pacienteId == null ||
        doctorId == null ||
        fechaHora == null ||
        motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('citas').add({
      'clienteId': clienteId,
      'pacienteId': pacienteId,
      'doctorId': doctorId,
      'fecha': fechaHora!.toIso8601String().split('T')[0],
      'hora':
          '${fechaHora!.hour.toString().padLeft(2, '0')}:${fechaHora!.minute.toString().padLeft(2, '0')}',
      'motivo': motivo,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Agregar Cita'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: clienteId,
              hint: const Text('Selecciona un Cliente'),
              items:
                  clientes.map((cliente) {
                    return DropdownMenuItem(
                      value: cliente.id,
                      child: Text(cliente['nombre']),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  clienteId = value;
                  pacienteId = null;
                  cargarPacientes(value!);
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: pacienteId,
              hint: const Text('Selecciona un Paciente'),
              items:
                  pacientes.map((paciente) {
                    return DropdownMenuItem(
                      value: paciente.id,
                      child: Text(paciente['nombre']),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => pacienteId = value),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: doctorId,
              hint: const Text('Selecciona un Doctor'),
              items:
                  doctores.map((doctor) {
                    return DropdownMenuItem(
                      value: doctor.id,
                      child: Text(doctor['nombre']),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => doctorId = value),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Motivo'),
              onChanged: (value) => motivo = value,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (fecha != null) {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (hora != null) {
                    setState(() {
                      fechaHora = DateTime(
                        fecha.year,
                        fecha.month,
                        fecha.day,
                        hora.hour,
                        hora.minute,
                      );
                    });
                  }
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                fechaHora == null
                    ? 'Seleccionar Fecha y Hora'
                    : '${fechaHora!.toLocal()}'.split('.')[0],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: guardarCita,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Cita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
