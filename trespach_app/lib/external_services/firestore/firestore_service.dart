import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trespach_app/external_services/firestore/firestore_collections.dart';

typedef JSON = Map<String, dynamic>;

class FirestoreService {
  static final db = FirebaseFirestore.instance;

  static Future<List<JSON>> getData({
    required FirestoreCollections collection,
  }) async {
    final data = await db.collection(collection.name).get();

    return data.docs.map((d) => d.data()).toList();
  }

  static Future<void> createData({
    required FirestoreCollections collection,
    required JSON data,
  }) => db.collection(collection.name).doc().set(data);
}
