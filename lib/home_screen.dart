import 'package:flutter/material.dart';
import 'package:petsandhealth/screens/Citas/citas_screen.dart';
import 'package:petsandhealth/screens/Clientes/clientes_screen.dart';
import 'package:petsandhealth/screens/Doctores/doctores_screen.dart';

import 'package:petsandhealth/screens/Pacientes/pacientes_screen.dart';
import 'package:petsandhealth/profile_screen.dart';
import 'package:petsandhealth/usuarios_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        toolbarHeight: 90, // Altura personalizada
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 65),
            const SizedBox(width: 10),
            const Text(
              'Pets & Health',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black, // Texto en negro
                fontFamily:
                    'Roboto', // Usa una fuente bonita; puedes cambiarla si tienes otra
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.account_circle, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fondo.png'),
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
            opacity: 0.5,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 30,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _dashboardTile(
                            context,
                            icon: Icons.calendar_today,
                            title: 'Citas',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CitasScreen(),
                                ),
                              );
                            },
                          ),
                          _dashboardTile(
                            context,
                            icon: Icons.pets,
                            title: 'Pacientes',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PacientesScreen(),
                                ),
                              );
                            },
                          ),
                          _dashboardTile(
                            context,
                            icon: Icons.medical_services,
                            title: 'Doctores',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DoctoresScreen(),
                                ),
                              );
                            },
                          ),
                          _dashboardTile(
                            context,
                            icon: Icons.people,
                            title: 'Clientes',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ClientesScreen(),
                                ),
                              );
                            },
                          ),

                          _dashboardTile(
                            context,
                            icon: Icons.account_circle,
                            title: 'Perfil',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfileScreen(),
                                ),
                              );
                            },
                          ),
                          if (role == 'administrador')
                            _dashboardTile(
                              context,
                              icon: Icons.supervised_user_circle,
                              title: 'Usuarios',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UsuariosScreen(),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 220,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.teal, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.white),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
