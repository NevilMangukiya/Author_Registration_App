import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helpers/firebase_auth_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  Uint8List? image;
  Uint8List? decodedImage;
  String encodedImage = "";
  String books = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController booksController = TextEditingController();

  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateBooksController = TextEditingController();

  GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Register Your Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed('add_page');
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 700,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseCloudHelper.firebaseCloudHelper.fetchAllData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("ERROR: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> docu = querySnapshot.docs;

                return ListView.builder(
                  itemCount: docu.length,
                  itemBuilder: (context, i) {
                    Map<String, dynamic> data =
                        docu[i].data() as Map<String, dynamic>;

                    if (data["image"] != null) {
                      decodedImage = base64Decode(data["image"]);
                    } else {
                      decodedImage == null;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.red,
                              blurRadius: 6,
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (decodedImage == null)
                                ? const Text(
                                    "NO IMAGE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  )
                                : Container(
                                    height: 400,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        decodedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Author : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "${data["name"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    deleteData(
                                      id: docu[i].id,
                                    );
                                  },
                                  child: Icon(
                                    size: 25,
                                    Icons.delete_forever,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Books : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 225,
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    "${data["books"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
  //
  // insertNoteData(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(
  //           builder: (context, setState) {
  //             return AlertDialog(
  //               title: const Text(
  //                 "Add Author",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               content: Form(
  //                 key: insertFormKey,
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Ink(
  //                         decoration: const BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           // color: secondaryColor,
  //                         ),
  //                         child: InkWell(
  //                           borderRadius: BorderRadius.circular(50),
  //                           onTap: () async {
  //                             final ImagePicker _picker = ImagePicker();
  //
  //                             XFile? img = await _picker.pickImage(
  //                                 source: ImageSource.gallery);
  //
  //                             if (img != null) {
  //                               File compressedImage =
  //                                   await FlutterNativeImage.compressImage(
  //                                       img.path);
  //                               image = await compressedImage.readAsBytes();
  //                               encodedImage = base64Encode(image!);
  //                             }
  //                             setState(() {});
  //                           },
  //                           child: CircleAvatar(
  //                             radius: 50,
  //                             child: Center(
  //                               child: image == null
  //                                   ? const Text(
  //                                       "ADD IMAGE",
  //                                       style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 10),
  //                                     )
  //                                   : Container(
  //                                       height: 100,
  //                                       width: 100,
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white.withOpacity(0.7),
  //                                       ),
  //                                       child: ClipRRect(
  //                                         borderRadius:
  //                                             BorderRadius.circular(50),
  //                                         child: Image.memory(
  //                                           image!,
  //                                           fit: BoxFit.cover,
  //                                         ),
  //                                       ),
  //                                     ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 20,
  //                       ),
  //                       TextFormField(
  //                         controller: nameController,
  //                         validator: (val) {
  //                           if (val!.isEmpty) {
  //                             return "Enter name";
  //                           }
  //                           return null;
  //                         },
  //                         onSaved: (val) {
  //                           setState(() {
  //                             name = val!;
  //                           });
  //                         },
  //                         decoration: const InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           labelText: "Name",
  //                           hintText: "Enter name",
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       TextFormField(
  //                         maxLines: 3,
  //                         controller: booksController,
  //                         validator: (val) {
  //                           if (val!.isEmpty) {
  //                             return "Enter Books";
  //                           }
  //                           return null;
  //                         },
  //                         onSaved: (val) {
  //                           setState(() {
  //                             books = val!;
  //                           });
  //                         },
  //                         decoration: const InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           labelText: "Books",
  //                           alignLabelWithHint: true,
  //                           hintText: "Enter Books...",
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               actions: [
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     if (insertFormKey.currentState!.validate()) {
  //                       insertFormKey.currentState!.save();
  //
  //                       await FirebaseCloudHelper.firebaseCloudHelper
  //                           .insertData(
  //                               name: name, books: books, image: encodedImage);
  //                     } else {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                           backgroundColor: Colors.red,
  //                           content: Text("Failed To Add data"),
  //                           behavior: SnackBarBehavior.floating,
  //                         ),
  //                       );
  //                     }
  //                     nameController.clear();
  //                     booksController.clear();
  //
  //                     setState(() {
  //                       name = "";
  //                       books = "";
  //                       image == "";
  //                     });
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("save"),
  //                 ),
  //                 OutlinedButton(
  //                   onPressed: () {
  //                     nameController.clear();
  //                     booksController.clear();
  //
  //                     setState(() {
  //                       name = "";
  //                       books = "";
  //                       image == null;
  //                     });
  //
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text("cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       });
  // }

  deleteData({required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Data"),
        content: const Text(
          "Are you sure to delete this data permanently",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseCloudHelper.firebaseCloudHelper.deleteData(deleteId: id);

              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
