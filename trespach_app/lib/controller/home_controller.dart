import 'package:flutter/foundation.dart';
import 'package:trespach_app/external_services/firestore/firestore_collections.dart';
import 'package:trespach_app/external_services/firestore/firestore_service.dart';
import 'package:trespach_app/model/product.dart';

class HomeController {
  Future<List<Product>?> getProducts() async {
    try {
      final data = await FirestoreService.getData(
        collection: FirestoreCollections.products,
      );

      final products = data
          .map((jsonAtual) => Product.fromJson(jsonAtual))
          .toList();

      return products;
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }
}
