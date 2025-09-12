import 'package:flutter/foundation.dart';
import 'package:trespach_app/external_services/localstorage/localstorage.dart';
import 'package:trespach_app/external_services/localstorage/localstorage_collections.dart';
import 'package:trespach_app/model/product.dart';

typedef JSON = Map<String, dynamic>;

class CartController {
  Future<void> saveProductInCart({required JSON productJSON}) async {
    try {
      await LocalStorage.storeJson(
        localStorageCollection: LocalStorageCollections.cartProducts,
        data: productJSON,
      );
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }

  Future<List<Product>> retrieveProductsInCart() async {
    final jsonsFromCart = await LocalStorage.getAllJsons(
      localStorageCollection: LocalStorageCollections.cartProducts,
    );

    return jsonsFromCart.map((jc) => Product.fromJson(jc)).toList();
  }
}
