import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirestoreServices._();
  static final instance = FirestoreServices._();

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    debugPrint('$path:$data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    debugPrint('delete:$path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs.map((e) => builder(e.data(), e.id)).toList(),
    );
  }
}
