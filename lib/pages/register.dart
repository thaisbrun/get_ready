import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/connexion.dart';
import 'homePage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  final mailController = TextEditingController();
  final mdpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    mdpController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:Container(
      margin:const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child:Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Mail : ",
                  hintText: "Entrez votre adresse mail ",
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le mail ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: mailController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mot de passe : ',
                  hintText: 'Entrez votre mdp',
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le mdp ne peut pas être invalide. ";
                  }
                  return null;
                },
                  controller: mdpController,
              ),
            ),
            SizedBox(
              child: ElevatedButton(
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: mailController.text,
                    password: mdpController.text,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
                  FocusScope.of(context).requestFocus(FocusNode());
            },
              style:const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink)
              ),
                child: const Text("M'inscrire"),
            ),
  ),
            Center(
              child: CupertinoButton(
                child: const Text("J'ai déjà un compte"),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const Connexion()),
                  );
                },
    ),
            ),
          ],
        ),
      ),
    )
    );
  }
}

