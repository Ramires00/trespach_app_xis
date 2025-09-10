class Product {
  Product({
    required this.name,
    required this.description,
    required this.price,
    this.additionals,
    this.image,
    required this.notes,
    required this.quantity,
  });

  final String name;
  final String description;
  final num price;
  final dynamic additionals;
  final String notes;
  final int quantity;
  final String? image;
}

// Produto (Lanche, bebida, doce (sobremesa))
//   - Nome (String)
//   - Descrição (String)
//   - Valor (número)
//   - Adicionais (se houver) (Lista de adicionais)
//   - Observação (String)
//   - Quantidade (número)
//   - Foto (String - link http da foto)
