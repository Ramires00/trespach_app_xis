import 'package:trespach_app/model/additional.dart';

typedef JSON = Map<String, dynamic>;

class Product {
  Product({
    required this.name,
    required this.description,
    required this.price,
    this.additionals,
    this.image,
    required this.notes,
    this.quantity,
  });

  final String name;
  final String description;
  final num price;
  final List<Additional>? additionals;
  final String notes;
  final int? quantity;
  final String? image;

  factory Product.fromJson(JSON json) {
    return Product(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      notes: json['notes'],
      quantity: json['quantity'],
    );
  }

  JSON toJson() {
    return {
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

// Produto (Lanche, bebida, doce (sobremesa))
//   - Nome (String)
//   - Descrição (String)
//   - Valor (número)
//   - Adicionais (se houver) (Lista de adicionais)
//   - Observação (String)
//   - Quantidade (número)
//   - Foto (String - link http da foto)
