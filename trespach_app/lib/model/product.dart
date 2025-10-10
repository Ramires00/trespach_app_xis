import 'package:trespach_app/model/additional.dart';

typedef JSON = Map<String, dynamic>;

class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.additionals,
    this.image,
    required this.notes,
    this.quantity,
  });

  final String id;
  final String name;
  final String description;
  final num price;
  final List<Additional>? additionals;
  final String notes;
  final int? quantity;
  final String? image;

  factory Product.fromJson(JSON json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      additionals: json['additionals']
          .map<Additional>((a) => Additional.fromJson(a))
          .toList(),
      notes: json['notes'],
      quantity: json['quantity'],
      image: json['image'],
    );
  }

  JSON toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "additionals": additionals?.map((a) => a.toJson()).toList(),
      "notes": notes,
      "quantity": quantity,
      "image": image,
    };
  }
}
