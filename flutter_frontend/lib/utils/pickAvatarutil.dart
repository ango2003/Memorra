import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

pickImage(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: ImageSource.gallery);
  if(_file != null){
    return await _file.readAsBytes();
  }

  print("No image selected");
}

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImage(String childName, Uint8List file) async {
    Reference ref = storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required Uint8List file,
  }) async {

    String resp = "Some error occurred";

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      String imageURL = await uploadImage('profilePics/$uid', file);

      await _firestore.collection('accounts').doc(uid).set({
        'imageURL': imageURL,
      });

      resp = "success";

    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}