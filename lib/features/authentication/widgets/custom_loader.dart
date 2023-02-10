import 'package:flutter/material.dart';

class CustomLoader {
  static Future<dynamic> showMyLoader(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (ctx) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: GestureDetector(
                  onTap: () {
                    print("Loader tapped");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
