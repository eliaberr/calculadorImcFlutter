import 'package:flutter/material.dart';

class TelaBoasVindas extends StatelessWidget {
  final String name;
  //final String email;

  const TelaBoasVindas({super.key, required this.name});

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo'),
        backgroundColor: const Color.fromRGBO(169, 209, 231, 8),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0.0, -0.6),
            child: Text(
              'Seja bem-vindo\n$name',
              style: TextStyle(
                fontSize: 30,
                color: const Color.fromRGBO(64, 75, 224, 0.973),
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(5, 5),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Você está logado!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(204, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
