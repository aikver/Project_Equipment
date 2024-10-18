import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectlast/config/varbles.dart'; // Assuming apiURL is defined here
import 'package:projectlast/model/user_model.dart';
import 'package:projectlast/pages/login_page.dart';
import 'package:projectlast/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthService {
  // Login Method
  Future<Map<String, dynamic>> login(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_name": userName,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the user data using UserModel
        Usermodel authResponse = Usermodel.fromJson(jsonDecode(response.body));
        return {
          "success": true,
          "message": authResponse,
        };
      } else {
        // Failed login
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? 'Login failed',
        };
      }
    } catch (err) {
      print('Error during login: $err');
      return {
        "success": false,
        "message": "An error occurred. Please try again.",
      };
    }
  }

  // Register Method
  Future<Map<String, dynamic>> register(
    String userName, String firstName, String lastName, String password, String phone, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$apiURL/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_name': userName,
          'firstname': firstName,
          'lastname': lastName,
          'password': password,
          'phone': phone,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        return {
          "success": true,
          "message": "Registration successful!",
        };
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? 'Registration failed',
        };
      }
    } catch (err) {
      print('Error during registration: $err');
      return {
        "success": false,
        "message": "An error occurred. Please try again.",
      };
    }
  }

  // Logout Method
  Future<void> logout(BuildContext context) async {
    // Clear any stored user data (like tokens, preferences, etc.)
    await Future.delayed(Duration(seconds: 1)); // Simulating async logout

    // Reset user provider (if using Provider)
    Provider.of<UserProvider>(context, listen: false).onLogout();

    // Navigate back to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Clear all previous routes
    );
  }
}
