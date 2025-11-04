import 'package:flutter/foundation.dart';
import 'package:trespach_app/external_services/firestore/firestore_collections.dart';
import 'package:trespach_app/external_services/firestore/firestore_service.dart';
import 'package:trespach_app/external_services/localstorage/localstorage.dart';
import 'package:trespach_app/external_services/localstorage/localstorage_collections.dart';
import 'package:trespach_app/model/address.dart';
import 'package:trespach_app/model/product.dart';

typedef JSON = Map<String, dynamic>;

class CartController {
  Future<void> clearAll() async {
    await LocalStorage.clearAll(
      localStorageCollection: LocalStorageCollections.cartProducts,
    );
  }

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

  Future<void> deleteProduct(String cartId) async {
    LocalStorage.deleteJson(
      localStorageCollection: LocalStorageCollections.cartProducts,
      id: cartId,
    );
  }

  Future<List<Product>> retrieveProductsInCart() async {
    final jsonsFromCart = await LocalStorage.getAllJsons(
      localStorageCollection: LocalStorageCollections.cartProducts,
    );

    return jsonsFromCart.map((jc) => Product.fromJson(jc)).toList();
  }

  Future<List<Neighborhood>> retrieveNeighborhoods() async {
    final data = await FirestoreService.getData(
      collection: FirestoreCollections.neighborhoods,
    );

    final neighborhoods = data
        .map((json) => Neighborhood.fromJson(json))
        .toList();

    return neighborhoods;
  }

  Future<void> createNewOrder(JSON json) async {
    await FirestoreService.createData(
      collection: FirestoreCollections.orders,
      data: json,
    );
  }
}
