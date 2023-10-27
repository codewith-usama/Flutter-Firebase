import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_tutorial/ui/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  bool isLoading = false;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        if (kDebugMode) {
          print('no image selected');
        }
      }
    });
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 3,
                        color: Colors.black87,
                      ),
                    ),
                    child: _image == null
                        ? const Icon(
                            Icons.image,
                            size: 150,
                          )
                        : Image.file(
                            _image!.absolute,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              RoundButton(
                text: 'Upload Image',
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  Reference ref =
                      FirebaseStorage.instance.ref('/folderName' + 'fileName');
                  UploadTask uploadTask = ref.putFile(_image!.absolute);

                  await Future.value(uploadTask);

                  var newUrl = ref.getDownloadURL();

                  reference.child('1').set({
                    'id': 123,
                    'title': newUrl.toString(),
                  });

                  setState(() {
                    isLoading = false;
                  });
                },
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
