import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/authService.dart';
import 'package:consumption/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width,
            child: InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                AuthService service = new AuthService();
                try {
                  await service.signInwithGoogle();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                } catch (e) {
                  print(e);
                  if (e is FirebaseAuthException) {
                    showMessage(e.message);
                    print(e.message);
                  }
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Constants.secondColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Log in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Constants.accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ))
        : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
