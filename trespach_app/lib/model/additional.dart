import 'package:flutter/foundation.dart';

typedef JSON = Map<String, dynamic>;

class Additional {
  Additional({
    required this.name,
    required this.price,
    this.quantity,
    required this.quantityLimit,
  });

  final String name;
  final num price;
  final int? quantity;
  final int quantityLimit;

  JSON toJson() {
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
      "quantityLimit": quantityLimit,
    };
  }

  factory Additional.fromJson(JSON json) {
    return Additional(
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      quantityLimit: json['quantityLimit'],
    );
  }
}

// Adicional
//   - Nome (String)
//   - Valor (número)
//   - Quantidade (número)
//   - Limite (número)
