import 'dart:convert';

Equipment equipmentFromJson(String str) => Equipment.fromJson(json.decode(str));

String equipmentToJson(Equipment data) => json.encode(data.toJson());

class Equipment {
  final String equipmentName;
  final String equipmentType;
  final int price;
  final String unit;
  final String status;
  final String? id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Equipment({
    required this.equipmentName,
    required this.equipmentType,
    required this.price,
    required this.unit,
    required this.status,
    this.id, // id ไม่จำเป็นต้องใส่เมื่อสร้างใหม่
    required this.createdAt,
    required this.updatedAt,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        equipmentName: json["equipment_name"],
        equipmentType: json["equipment_type"],
        price: json["price"],
        unit: json["unit"],
        status: json["status"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "equipment_name": equipmentName,
        "equipment_type": equipmentType,
        "price": price,
        "unit": unit,
        "status": status,
        if (id != null) "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
