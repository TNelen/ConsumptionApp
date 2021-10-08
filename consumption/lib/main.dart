import 'package:consumption/widgets/googleSignInButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Consumption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Image.asset(
                    "assets/images/beer.jpg",
                    scale: 4,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                      "Consumptie",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "Tracker",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                   GoogleSignIn()
                ],
              ),
            ),);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
