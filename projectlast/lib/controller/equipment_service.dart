import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projectlast/model/equipment_model.dart';
import 'package:projectlast/config/varbles.dart'; // Use apiURL from varbles.dart

class EquipmentService {
  final String apiUrl = apiURL + '/api/equipment'; // ใช้ URL จาก varbles.dart

  // ฟังก์ชันดึงข้อมูลทั้งหมด
  Future<List<Equipment>> getAllEquipments() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((equipment) => Equipment.fromJson(equipment)).toList();
    } else {
      throw Exception('Failed to load equipment');
    }
  }

  // ฟังก์ชันเพิ่ม/แก้ไข Equipment
  Future<Equipment> saveEquipment(Equipment equipment) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(equipment.toJson()),
    );

    if (response.statusCode == 200) {
      return Equipment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save equipment');
    }
  }

  // ฟังก์ชันลบ Equipment
  Future<void> deleteEquipment(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete equipment');
    }
  }
}
