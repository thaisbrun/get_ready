import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/main.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}
class _ConnexionState extends State<Connexion> {

  final mdpController = TextEditingController();
  final mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    mdpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title:Text('Connexion'),
      ),
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
      labelText: 'Mail : ',
      hintText: 'Entrez votre mail',
      border:OutlineInputBorder()
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
      hintText: 'Entrez votre mot de passe',
      border:OutlineInputBorder(),
      ),
      validator: (value){
      if(value == null || value.isEmpty){
      return "Le mot de passe ne peut pas être invalide. ";
      }
      return null;
      },
      controller: mdpController,
      ),
      ),
        SizedBox(
          width:double.infinity,
          child:ElevatedButton(onPressed: () async {
            try {

              final mail = mailController.text;
              final mdp = mdpController.text;
              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: mail,
                  password: mdp,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: MyApp.appTitle)),
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }

            }
          },
            style:const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.pink)
            ),
            child: const Text("Me connecter"),
          ),
        ),

      ],
      ),
      ),
      ),
    );
  }
}