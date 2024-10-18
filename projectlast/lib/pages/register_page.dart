import 'package:flutter/material.dart';
import 'package:projectlast/controller/auth_sevice.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String _selectedRole = 'user'; // Default role is 'user'

  bool _isPasswordVisible = false;
  final AuthService authService = AuthService();
  bool _isLoading = false;

  // Register user
  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call the register method in AuthService with all the required arguments
      final result = await authService.register(
        userNameController.text, // user_name from the user
        firstNameController.text, // firstname from the user
        lastNameController.text, // lastname from the user
        passwordController.text, // password from the user
        phoneController.text, // phone number from the user
        _selectedRole, // Role from the dropdown
      );

      setState(() {
        _isLoading = false;
      });

      // Display the result message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      // Reset the form fields if registration was successful
      if (result['success']) {
        _formKey.currentState?.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:  AppBar(
        title: Text('Register Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader if registering
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(userNameController, 'User Name', Icons.person),
                      const SizedBox(height: 20),
                      _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
                      const SizedBox(height: 20),
                      _buildTextField(firstNameController, 'First Name', Icons.person_outline),
                      const SizedBox(height: 20),
                      _buildTextField(lastNameController, 'Last Name', Icons.person_outline),
                      const SizedBox(height: 20),
                      _buildTextField(phoneController, 'Phone', Icons.phone),
                      const SizedBox(height: 20),
                      _buildRoleDropdown(),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width * 1, 50),
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Helper method to build text fields with validation and custom styling
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[600]!),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  // Helper method to build a dropdown for role selection
  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      onChanged: (String? newValue) {
        setState(() {
          _selectedRole = newValue!;
        });
      },
      items: <String>['user', 'admin']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Role',
        labelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: const Icon(Icons.account_circle, color: Colors.blue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[600]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your role';
        }
        return null;
      },
    );
  }
}
