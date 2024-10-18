import 'package:flutter/material.dart';
import 'package:projectlast/controller/auth_sevice.dart';
import 'package:projectlast/model/user_model.dart';
import 'package:projectlast/providers/user_provider.dart';
import 'package:projectlast/pages/register_page.dart'; // Import Register Page
import 'package:projectlast/pages/equipment_page.dart'; // Import EquipmentPage
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController =
      TextEditingController(text: "aik5");
  final TextEditingController passwordController =
      TextEditingController(text: "12345");

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final userName = userNameController.text;
      final password = passwordController.text;

      setState(() {
        _isLoading = true;
      });

      try {
        final result = await AuthService().login(userName, password);

        if (result['success']) {
          // Parsing UserModel from the result
          Usermodel authResponse = result['message'];

          if (!mounted) return;
          // Store the user info in the provider
          Provider.of<UserProvider>(context, listen: false).onLogin(authResponse);

          // Navigate to EquipmentPage after login success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EquipmentPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
          );
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
        print(err);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.blue),
                ),
                style: const TextStyle(color: Colors.blue),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                  suffixIcon: IconButton(
                    color: Colors.blue,
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.blue),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width * 1, 50),
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Login', style: TextStyle(color: Colors.white)),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate to Register Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  RegisterPage()),
                  );
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
