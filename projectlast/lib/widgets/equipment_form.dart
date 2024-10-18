import 'package:flutter/material.dart';
import 'package:projectlast/model/equipment_model.dart';

class EquipmentForm extends StatefulWidget {
  final Equipment? equipment;
  final Function(Equipment) onSave;

  const EquipmentForm({Key? key, this.equipment, required this.onSave})
      : super(key: key);

  @override
  _EquipmentFormState createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<EquipmentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController priceController;
  late TextEditingController unitController;
  String status = 'available';

  @override
  void initState() {
    super.initState();
    if (widget.equipment != null) {
      nameController = TextEditingController(text: widget.equipment!.equipmentName);
      typeController = TextEditingController(text: widget.equipment!.equipmentType);
      priceController = TextEditingController(text: widget.equipment!.price.toString());
      unitController = TextEditingController(text: widget.equipment!.unit);
      status = widget.equipment!.status;
    } else {
      nameController = TextEditingController();
      typeController = TextEditingController();
      priceController = TextEditingController();
      unitController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Equipment Name'),
              validator: (value) => value!.isEmpty ? 'Please enter equipment name' : null,
            ),
            TextFormField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Equipment Type'),
              validator: (value) => value!.isEmpty ? 'Please enter equipment type' : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter price' : null,
            ),
            TextFormField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Unit'),
              validator: (value) => value!.isEmpty ? 'Please enter unit' : null,
            ),
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['available', 'unavailable']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                status = value!;
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final equipment = Equipment(
                    id: widget.equipment?.id,
                    equipmentName: nameController.text,
                    equipmentType: typeController.text,
                    price: int.parse(priceController.text),
                    unit: unitController.text,
                    status: status,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  widget.onSave(equipment);
                  Navigator.pop(context); // ปิดฟอร์มหลังบันทึกสำเร็จ
                }
              },
              child: Text(widget.equipment == null ? 'Add Equipment' : 'Update Equipment'),
            ),
          ],
        ),
      ),
    );
  }
}
