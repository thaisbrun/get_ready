import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();

}

class _MyAccountState extends State<MyAccount> {

  final user = FirebaseAuth.instance.currentUser;

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          margin:const EdgeInsets.all(20),
          child:Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    initialValue: FirebaseAuth.instance.currentUser?.email,
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    //initialValue: FirebaseAuth.instance.currentUser?.phoneNumber,
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
                  ),
                ),
              ],
            ),
        ),
        );
  }
  }
