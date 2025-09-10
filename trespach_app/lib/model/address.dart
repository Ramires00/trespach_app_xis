class Address {
  Address({
    required this.address,
    this.number,
    required this.neighborhood,
    required this.postalCode,
    this.deliveryTax,
    this.reference,
  });

  final String address;
  final String? number;
  final String neighborhood;
  final String postalCode;
  final num? deliveryTax;
  final String? reference;
}
