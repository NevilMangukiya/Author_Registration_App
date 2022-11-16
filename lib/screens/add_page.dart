import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/firebase_auth_helper.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
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
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          height: 500,
          width: double.infinity,
          child: Form(
            key: insertFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();

                      XFile? img =
                          await _picker.pickImage(source: ImageSource.gallery);

                      if (img != null) {
                        File compressedImage =
                            await FlutterNativeImage.compressImage(img.path);
                        image = await compressedImage.readAsBytes();
                        encodedImage = base64Encode(image!);
                      }
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 100,
                      child: Center(
                        child: image == null
                            ? const Text(
                                "ADD IMAGE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              )
                            : Container(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.memory(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter name";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        name = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Author Name",
                      hintText: "Enter Author name",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: booksController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Books";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        books = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Books",
                      alignLabelWithHint: true,
                      hintText: "Enter Books...",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (insertFormKey.currentState!.validate()) {
                            insertFormKey.currentState!.save();

                            await FirebaseCloudHelper.firebaseCloudHelper
                                .insertData(
                                    name: name,
                                    books: books,
                                    image: encodedImage);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Failed To Add data"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                          nameController.clear();
                          booksController.clear();

                          setState(() {
                            name = "";
                            books = "";
                            image == "";
                          });
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        child: const Text("Add"),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          nameController.clear();
                          booksController.clear();

                          setState(() {
                            name = "";
                            books = "";
                            image == null;
                          });

                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
