import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '4takeaway Login',
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFFE91E63),
            secondary: const Color(0xFFCFD3D6),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
