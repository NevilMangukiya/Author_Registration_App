import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudHelper {
  FirebaseCloudHelper._();

  static final FirebaseCloudHelper firebaseCloudHelper =
      FirebaseCloudHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference author;

  void authorCollection() {
    author = firebaseFirestore.collection("authors");
  }

  insertData(
      {required String name,
      required String books,
      required String image}) async {
    authorCollection();

    await author.doc().set({'name': name, 'books': books, "image": image});
  }

  Stream<QuerySnapshot> fetchAllData() {
    authorCollection();
    Stream<QuerySnapshot> stream = author.snapshots();

    return stream;
  }

// Todo: Update Data
  Future<void> updateData(
      {required String id, required String name, required String books}) async {
    authorCollection();
    await author.doc(id).update({
      "title": name,
      "desc": books,
    });
  }

// Todo: Delete Data
  deleteData({required String deleteId}) async {
    authorCollection();

    await author.doc(deleteId).delete();
  }
}
