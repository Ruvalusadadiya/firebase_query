// ignore_for_file: avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State createState() => _State();
}

class _State extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  List<Map> data = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  String updatekey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
                hintText: 'Enter Your Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Password',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(180, 40)),
            child: const Text('Login'),
            onPressed: () async {
              await insert();
              pass.clear();
              email.clear();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(180, 40)),
            child: const Text('update'),
            onPressed: () {
              update();
              pass.clear();
              email.clear();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(180, 40)),
            child: const Text('delete'),
            onPressed: () {
              delete();
              pass.clear();
              email.clear();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(180, 40)),
            child: const Text('select'),
            onPressed: () async {
              await select();
              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    email.text = data[index]["Email"];
                    pass.text = data[index]["Pass"];
                    updatekey = data[index]["key"];
                  },
                  title: Text(data[index]["Email"].toString()),
                  subtitle: Text(data[index]["Pass"].toString()),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> insert() async {
    String? key = database.ref("Admin").push().key;
    updatekey = key!;
    print(key);
    await database.ref("Admin").child(key).set({
      "Email": email.text,
      "Pass": pass.text,
    });
  }

  Future<void> update() async {
    await database
        .ref("Admin")
        .child(updatekey)
        .update({"Email": email.text, "Pass": pass.text});
  }

  void delete() {
    print(updatekey);
    database.ref("Admin").child(updatekey).remove();
  }

  Future<void> select() async {
    data.clear();
    await database.ref("Admin").once().then(
      (value) {
        Map temp = value.snapshot.value as Map;
        print(temp);
        temp.forEach((key, value) {
          data.add({
            "Email": value["Email"],
            "Pass": value["Pass"],
            "key": key,
          });
        });
        print(data);
      },
    );
  }
}
