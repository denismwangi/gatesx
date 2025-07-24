import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/login_viewmodel.dart';
import '../../../views/home/home_screen.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<LoginViewModel>(
        builder: (context, model, child) {
          return Container(
            color: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            width: double.infinity,
            height: double.infinity,
            child: LoginForm(model: model),
          );
        },
      ),
    );
  }
}
