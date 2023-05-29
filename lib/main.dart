import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref('Users');

  List<Map> data = [];
  String selectedData = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: emailController,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passController,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // String? key = firebaseDatabase.push().key;
                firebaseDatabase.child('1').set({
                  'email': emailController.text,
                  'pass': passController.text,
                  //'key': key,
                });
              },
              child: const Text('Insert'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                firebaseDatabase.child(selectedData).update({
                  'email': emailController.text,
                  'pass': passController.text,
                });
              },
              child: const Text('Update'),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                firebaseDatabase.child(selectedData).remove();
              },
              child: const Text('Delete'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                firebaseDatabase.once().then((value) {
                  Map temp = value.snapshot.value as Map;
                  data.clear();
                  temp.forEach((k, v) {
                    data.add(v);
                  });
                  // ignore: avoid_print
                  print('--------- $data');
                  setState(() {});
                });
              },
              child: const Text('Select'),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    emailController.text = data[index]['email'];
                    passController.text = data[index]['pass'];
                    selectedData = data[index]['key'];
                    setState(() {});
                  },
                  title: Text(data[index]['email']),
                  subtitle: Text(data[index]['pass']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
