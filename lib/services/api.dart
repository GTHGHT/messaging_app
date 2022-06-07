

import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  String collection;
  String? docId;

  final _firestore = FirebaseFirestore.instance;

  Api({required this.collection, this.docId});

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({String? sortBy}){
      if(sortBy != null){
       return _firestore.collection(collection).orderBy(sortBy).snapshots();
      } else{
        return _firestore.collection(collection).snapshots();
      }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchDocument(String field, Object value){
    return _firestore.collection(collection).where(field,isEqualTo: value).limit(1).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(){
    return _firestore.collection(collection).doc(docId).get();
  }

  Future<DocumentReference> addDocument(Map<String, dynamic> data) {
    return _firestore.collection(collection).add(data);
  }
  Future<void> setDocument(Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(docId).set(data) ;
  }

  Future<void> removeDocument(){
    return _firestore.collection(collection).doc(docId).delete();
  }
}