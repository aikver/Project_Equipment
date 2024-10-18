import 'package:flutter/material.dart';
import 'package:projectlast/controller/equipment_service.dart';
import 'package:projectlast/model/equipment_model.dart';
import 'package:projectlast/widgets/equipment_form.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List<Equipment> equipments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEquipments();
  }

  // ดึงข้อมูล equipment ทั้งหมด
  void _fetchEquipments() async {
    try {
      var result = await EquipmentService().getAllEquipments();
      setState(() {
        equipments = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // เปิดฟอร์มเพิ่ม/แก้ไข Equipment
  void _openEquipmentForm({Equipment? equipment}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => EquipmentForm(
        equipment: equipment,
        onSave: (updatedEquipment) {
          if (equipment == null) {
            setState(() {
              equipments.add(updatedEquipment);
            });
          } else {
            setState(() {
              int index = equipments.indexOf(equipment);
              equipments[index] = updatedEquipment;
            });
          }
        },
      ),
    );
  }

  // ลบ Equipment
  void _deleteEquipment(String id) {
    EquipmentService().deleteEquipment(id).then((_) {
      setState(() {
        equipments.removeWhere((equipment) => equipment.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Deleted successfully!"),
        backgroundColor: Colors.green,
      ));
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete."),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Management'),
        backgroundColor: Colors.blue[800],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: equipments.length,
              itemBuilder: (context, index) {
                final equipment = equipments[index];
                return ListTile(
                  title: Text(equipment.equipmentName),
                  subtitle: Text(
                      "Type: ${equipment.equipmentType}, Price: ${equipment.price}, Unit: ${equipment.unit}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openEquipmentForm(equipment: equipment),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteEquipment(equipment.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEquipmentForm(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
