import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map> FetchInfo(String collection, String doc) async {
  final data = await FirebaseFirestore.instance.collection(collection).doc(doc).get();
  return data.data()!;
}