import 'package:flutter/material.dart';

class TelaCalculadoraImc extends StatefulWidget {
  final String name;

  const TelaCalculadoraImc({super.key, required this.name});

  @override
  State<TelaCalculadoraImc> createState() => _TelaCalculadoraImcState();
}

class _TelaCalculadoraImcState extends State<TelaCalculadoraImc> {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  double peso = 0;
  double altura = 0;
  double resultado = 0;
  String imcResultado = "";

  void calcularIMC() {
    setState(() {
      String pesoTexto = pesoController.text.replaceAll(",", ".");
      String alturaTexto = alturaController.text.replaceAll(",", ".");

      peso = double.tryParse(pesoTexto) ?? 0;
      altura = double.tryParse(alturaTexto) ?? 0;

      if (altura > 3) {
        altura = altura / 100;
      }

      if (peso > 0 && altura > 0) {
        resultado = peso / (altura * altura);

        if (resultado < 18.5) {
          imcResultado = "Abaixo do peso";
        } else if (resultado < 24.9) {
          imcResultado = "Peso normal";
        } else if (resultado < 29.9) {
          imcResultado = "Sobrepeso";
        } else {
          imcResultado = "Obesidade";
        }
      } else {
        resultado = 0;
        imcResultado = "Informe valores válidos!";
      }
    });
  }

  void deleteAll() {
    setState(() {
      pesoController.clear();
      alturaController.clear();
      peso = 0;
      altura = 0;
      resultado = 0;
      imcResultado = "";
    });
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  String saudacao() {
    final hora = DateTime.now().hour;

    if (hora >= 5 && hora < 12) {
      return 'Bom dia';
    } else if (hora >= 12 && hora < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(169, 209, 231, 8),
        title: Row(
          children: [
            Image.asset('assets/logoApp.png', height: 30),
            const SizedBox(width: 10),
            Text(
              'Meu IMC',
              style: TextStyle(
                fontFamily: 'IrishGrover',
                fontSize: 26,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: deleteAll),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Text(
                '${saudacao()}, ${widget.name}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),
              const Icon(Icons.person, size: 120, color: Colors.lightGreen),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: pesoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Peso (Kg)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: alturaController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Altura (cm ou m)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: calcularIMC,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Calcular"),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "IMC: ${resultado.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      imcResultado,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
