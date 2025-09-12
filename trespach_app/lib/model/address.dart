typedef JSON = Map<String, dynamic>;

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

  JSON toJson() {
    return {
      "address": address,
      "number": number,
      "neighborhood": neighborhood,
      "postalCode": postalCode,
      "deliveryTax": deliveryTax,
      "reference": reference,
    };
  }
}
