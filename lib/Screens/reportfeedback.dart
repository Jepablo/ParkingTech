import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../model/FirebaseAPI.dart';

class FeedbackDialog extends StatefulWidget{
  const FeedbackDialog({Key? key}):super(key: key);
  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>{
  final TextEditingController _controller=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey ();
  File? file;
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    final fName = file != null ? basename(file!.path) : 'No Image Taken';
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here',
                filled: true,
              ),
              maxLines: 5,
              maxLength: 4096,
              textInputAction: TextInputAction.done,
              validator: (String? text){
                if (text == null || text.isEmpty){
                  return 'Please enter a description';
                }
                return null;
              },
            ),
              // Text(fName),
          ],

          )
      ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextButton(
                      onPressed: _FromCamera,
                      child: const Text('Take Photo')
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: selectImage,
                      child: const Text('Upload Photo')
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')
                  ),
                ),
                Center(
                  child: TextButton(
                      child: const Text('Send'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String message;
                          try {
                            final collection =
                            FirebaseFirestore.instance.collection('Report');
                            await collection.doc().set({
                              'timestamp': FieldValue.serverTimestamp(),
                              'feedback': _controller.text,
                              'imageURL' : fName,
                            });
                            uploadImage();
                            message = 'Report successful';
                          } catch (_) {
                            message = 'Error when sending feedback';
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                          Navigator.pop( context);
                        }
                      }
                  ),
                ),
              ],
            ),
        ]
      );
  }
  Future _FromCamera() async {

    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,);
    if (photo == null){
      Fluttertoast.showToast(msg: "No Picture Taken");
      return;
    }
    setState(() => file = File(photo.path) );
  }

  Future uploadImage() async{
    if( file == null){
      Fluttertoast.showToast(msg: "Please Insert the Product Image");
      return;
    }
    final fileName = basename(file!.path);
    final destination = 'Report/$fileName';
    FirebaseApi.uploadFile(destination, file!);
  }

  Future selectImage() async{
    // // final Storage storage = Storage();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png','jpg'],
    );
    if (result == null){
      Fluttertoast.showToast(msg: "No Image Selected From Gallery");
      return;
    }
    final path = result.files.single.path!;
    setState(() => file = File(path) );
  }
}



