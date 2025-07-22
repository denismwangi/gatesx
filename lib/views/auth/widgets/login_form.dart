import 'package:flutter/material.dart';
import '../../../viewmodels/login_viewmodel.dart';
import 'social_button.dart';

class LoginForm extends StatefulWidget {
  final LoginViewModel model;
  const LoginForm({super.key, required this.model});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20), // 40 pixels top margin
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Color(0xFFFF8F00),
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '4takeaway',
                style: TextStyle(
                  color: Color(0xFFFF8F00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          //   const SizedBox(height: 24),
          //  const Text(
          //     'Nice to have you here!',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          //     textAlign: TextAlign.center,
          //   ),
          const SizedBox(height: 10),
          const Text(
            'Log in and discover great deals',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Username',
              style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                9,
                10,
                0,
                0,
              ), // left, top, right, bottom
              hintText: 'username',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBFC3C7)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w600,color:Colors.grey),
            ),
          ),
          SizedBox(height: 7),

          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                9,
                10,
                0,
                0,
              ), // left, top, right, bottom
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBFC3C7)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
              ),
              child: const Text(
                'Forgot password',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8F00),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: model.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await model.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (success && context.mounted) {
                          // AuthWrapper will automatically handle navigation
                          // when login state changes
                        } else if (model.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(child: Text(model.errorMessage!)),
                                ],
                              ),
                              backgroundColor: Colors
                                  .redAccent, // or Colors.orange for a warning
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior
                                  .floating, // Optional: makes it float above content
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      }
                    },
              child: model.isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Login', style: TextStyle(fontSize: 17)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_right_alt),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'Or sign in with',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(icon: Icons.facebook, onTap: () {}),
              const SizedBox(width: 16),
              SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account? ',style:TextStyle(color: Colors.grey)),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Create one here!',
                  style: TextStyle(
                    color: Color(0xFFFF8F00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
