import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_copy/features/authentication/services/firebase_firestore_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.person),
      ),
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestoreService().getAllUsers(),
        builder: (ctx, dataSnap) {
          if (dataSnap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                color: Colors.deepPurpleAccent,
              ),
            );
          }
          if (dataSnap.hasData) {
            final userList = dataSnap.data ?? [];
            print("user List in future builder: $userList");
            return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (ctx, index) {
                  final user = userList[index];
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(user.fullName ?? 'n/a'),
                      subtitle: Text(user.email ?? 'n/a'),
                    ),
                  );
                });
          }
          if (dataSnap.hasError) {
            final error = dataSnap.error;
            print("error in future builder: $error");
            return Center(
              child: Text(
                "Error!",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            );
          }
          return Center(
            child: Text("noData!"),
          );
        },
      ),
    );
  }
}
