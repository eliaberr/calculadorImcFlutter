import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmaSenhaController = TextEditingController();

  final databaseHelper = DatabaseHelper();

  void cadastrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      bool existe = await databaseHelper.emailExiste(emailController.text);

      if (existe) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('E-mail já cadastrado')));
        return;
      }

      await databaseHelper.insertUser(
        nomeController.text,
        emailController.text,
        senhaController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      nomeController.clear();
      emailController.clear();
      senhaController.clear();
      confirmaSenhaController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        backgroundColor: const Color.fromRGBO(169, 209, 231, 8),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                campoTexto('Nome', nomeController, (value) {
                  if (value!.isEmpty) return 'Digite seu nome';
                  return null;
                }),
                const SizedBox(height: 10),
                campoTexto('E-mail', emailController, (value) {
                  if (value!.isEmpty) return 'Digite seu e-mail';
                  if (!RegExp(
                    r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
                  ).hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                }),
                const SizedBox(height: 10),
                campoTextoSenha('Senha', senhaController, (value) {
                  if (value!.isEmpty) return 'Digite sua senha';
                  if (value.length < 8) {
                    return 'A senha deve ter no mínimo 8 caracteres';
                  }
                  if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                    return 'A senha deve conter letras e números';
                  }
                  return null;
                }),
                const SizedBox(height: 10),
                campoTextoSenha('Confirmar Senha', confirmaSenhaController, (
                  value,
                ) {
                  if (value != senhaController.text)
                    return 'As senhas não coincidem';
                  return null;
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: cadastrarUsuario,
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget campoTexto(
    String label,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Container(
      decoration: boxDecoration(),
      child: TextFormField(
        controller: controller,
        decoration: inputDecoration(label),
        validator: validator,
      ),
    );
  }

  Widget campoTextoSenha(
    String label,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Container(
      decoration: boxDecoration(),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: inputDecoration(label),
        validator: validator,
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
