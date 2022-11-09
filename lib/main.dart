import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  initFirebase();
  runApp(const MyApp());
}

Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Form Widget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String emailadress = "";

  String password = "";
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            onChanged: (value) => {
              setState(
                () {
                  emailadress = value;
                },
              )
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ("please enter a non null value");
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) => {
              setState(
                () {
                  password = value;
                },
              )
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ("please enter a non null value");
              }
              return null;
            },
          ),
          ElevatedButton(onPressed: onSubmit, child: Text("Submit Form"))
        ]),
      ),
    );
  }

  Future<void> authentificate(emailadress, password) async {
    try {
      print(emailadress);
      print(password);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailadress, password: password);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Connexion valide")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text( 'user-not-found')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text( 'wrong-password')));
      
      }
    }
  }

  onSubmit()  {
    if (_formKey.currentState!.validate()) {}
    authentificate(emailadress, password);
  }
}
