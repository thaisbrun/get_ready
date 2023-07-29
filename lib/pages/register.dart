import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    prenomController.dispose();
    mailController.dispose();
    adressePostaleController.dispose();
    telephoneController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child:Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
              decoration: InputDecoration(
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
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
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
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
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
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
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
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
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

            SizedBox(
              width:double.infinity,
            child:ElevatedButton(onPressed: (){
              if(_formKey.currentState!.validate()){
                final userName = userNameController.text;
                final prenom = prenomController.text;
                final mail = mailController.text;
                final telephone = telephoneController.text;
                final adressePostale = adressePostaleController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Envoi en cours..."))
                );

                FocusScope.of(context).requestFocus(FocusNode());

                //ajout dans la collection firebase
               CollectionReference usersRef = FirebaseFirestore.instance.collection("Utilisateurs");
                usersRef.add({
                 'userName': userName,
                 'prenom': prenom,
                 'mail': mail,
                 'telephone' : telephone,
                 'adressePostale': adressePostale,
                 'dateCreation': DateTime.now(),
                 'activation': 1,
               });
              }
            },
                child: Text("M'inscrire")
            ),
            )
          ],
        ),
      ),
    );
  }
}

