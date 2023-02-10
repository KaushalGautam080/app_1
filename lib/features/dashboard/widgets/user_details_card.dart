import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_copy/features/dashboard/services/firebase_storage_services.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("UserProfle"),
      ),
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 180,
                width: 180,
              ),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1385&q=80"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      final imagePicker = ImagePicker();
                      final imageFile = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (imageFile != null) {
                        final imageName = imageFile.name;
                        print("image name : $imageName");
                        final imageData = await imageFile.readAsBytes();

                        final imageUrl =
                            await FireBaseStorageServices().uploadImageGetUrl(
                          imageData,
                          imageName: imageName,
                        );
                        print("imageurl : $imageUrl");
                      } else {
                        print("Image not picked");
                      }
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              )
            ],
          ),
          Text(
            "FullName",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            "Email",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
