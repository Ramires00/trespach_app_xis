typedef JSON = Map<String, dynamic>;

class Additional {
  Additional({
    required this.name,
    required this.price,
    required this.quantity,
    required this.quantityLimit,
  });

  final String name;
  final num price;
  final int quantity;
  final int quantityLimit;

  JSON toJson() {
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
      "quantityLimit": quantityLimit,
    };
  }
}

// Adicional
//   - Nome (String)
//   - Valor (número)
//   - Quantidade (número)
//   - Limite (número)
