import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectlast/providers/user_provider.dart';
import 'package:projectlast/pages/login_page.dart';
import 'package:projectlast/pages/equipment_page.dart'; // นำเข้าหน้าพัสดุ

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // ตั้งค่า UserProvider
      ],
      child: MaterialApp(
        title: 'Equipment Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(), // กำหนดหน้าแรกเป็น LoginPage
          '/equipment': (context) => const EquipmentPage(), // หน้าพัสดุ
        },
      ),
    );
  }
}
