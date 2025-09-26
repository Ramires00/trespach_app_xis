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
  final Neighborhood neighborhood;
  final String postalCode;
  final num? deliveryTax;
  final String? reference;

  JSON toJson() {
    return {
      "address": address,
      "number": number,
      "neighborhood": neighborhood.toJson(),
      "postalCode": postalCode,
      "deliveryTax": deliveryTax,
      "reference": reference,
    };
  }
}

class Neighborhood {
  Neighborhood({required this.neighborhood, required this.deliveryTax});

  final String neighborhood;
  final num deliveryTax;

  factory Neighborhood.fromJson(JSON json) {
    return Neighborhood(
      deliveryTax: json['deliveryTax'],
      neighborhood: json['neighborhood'],
    );
  }

  JSON toJson() {
    return {'neighborhood': neighborhood, 'deliveryTax': deliveryTax};
  }
}
