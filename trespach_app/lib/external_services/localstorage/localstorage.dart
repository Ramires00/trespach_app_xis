import 'package:localstore/localstore.dart';
import 'package:trespach_app/external_services/localstorage/localstorage_collections.dart';

typedef JSON = Map<String, dynamic>;

class LocalStorage {
  static final _db = Localstore.instance;

  static Future<void> storeJson({
    required LocalStorageCollections localStorageCollection,
    required JSON data,
  }) async => await _db
      .collection(localStorageCollection.name)
      .doc(data["cartId"])
      .set(data);

  static Future<List> getAllJsons({
    required LocalStorageCollections localStorageCollection,
  }) async {
    final jsons = await _db.collection(localStorageCollection.name).get();
    return jsons?.values.toList() ?? [];
  }

  static Future<void> deleteJson({
    required LocalStorageCollections localStorageCollection,
    required String id,
  }) async =>
      await _db.collection(localStorageCollection.name).doc(id).delete();

  static Future<void> clearAll({
    required LocalStorageCollections localStorageCollection,
  }) async {
    await _db.collection(localStorageCollection.name).delete();
  }
}
