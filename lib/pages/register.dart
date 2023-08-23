import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/connexion.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final prenomController = TextEditingController();
  final mailController = TextEditingController();
  final adressePostaleController = TextEditingController();
  final telephoneController = TextEditingController();
  final mdpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    prenomController.dispose();
    mailController.dispose();
    adressePostaleController.dispose();
    telephoneController.dispose();
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
             labelText: 'Nom : ',
              hintText: 'Entrez votre nom',
              border:OutlineInputBorder()
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Le nom ne peut pas être invalide. ";
                }
                return null;
              },
                controller: userNameController,
            ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Prénom : ',
                    hintText: 'Entrez votre prénom',
                    border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le prénom ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: prenomController,
              ),
            ),
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
                  labelText: "Téléphone : ",
                  hintText: "Entrez votre numéro",
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le numéro ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: telephoneController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Adresse postale : ",
                  hintText: "Entrer en euros",
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le prix ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: adressePostaleController,
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
              width:double.infinity,
            child:ElevatedButton(onPressed: () {
              if(_formKey.currentState!.validate()){
                final userName = userNameController.text;
                final prenom = prenomController.text;
                final mail = mailController.text;
                final telephone = telephoneController.text;
                final adressePostale = adressePostaleController.text;
                final motDePasse = mdpController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Envoi en cours..."))
                );

                FocusScope.of(context).requestFocus(FocusNode());

                //ajout dans la collection firebase
               CollectionReference usersRef = FirebaseFirestore.instance.collection("Utilisateurs");
                usersRef.add({
                 'nom': userName,
                 'prenom': prenom,
                 'mail': mail,
                 'telephone' : telephone,
                 'adressePostale': adressePostale,
                 'dateCreation': DateTime.now(),
                 'activation': 1,
                  'motDePasse' : motDePasse,
                });
              }
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

