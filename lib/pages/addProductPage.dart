import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  final _formKey = GlobalKey<FormState>();

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productConseilUtilController = TextEditingController();
  final productMesureController = TextEditingController();
  final productPrixController = TextEditingController();
  String selectedCategorie = 'lips';

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    productConseilUtilController.dispose();
    productMesureController.dispose();
    productPrixController.dispose();
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
             labelText: 'Nom du produit : ',
              hintText: 'Entrez le nom du produit',
              border:OutlineInputBorder()
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Le nom du produit ne peut pas être invalide. ";
                }
                return null;
              },
                controller: productNameController,
            ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Description : ',
                    hintText: 'Entrez la description',
                    border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "La description ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: productDescriptionController,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Conseils d'utilisation : ",
                  hintText: "Entrez les conseils d'utilisation",
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Les conseils d'utilisation ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: productConseilUtilController,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Mesure : ",
                  hintText: "Entrer en ml, gr etc...",
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "La mesure ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: productMesureController,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Prix : ",
                  hintText: "Entrer en euros",
                  border:OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le prix ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: productPrixController,
              ),
            ),

            DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(value:'lips',child: Text("levres")),
                  DropdownMenuItem(value:'eyes',child: Text("yeux")),
                  DropdownMenuItem(value:'teint',child: Text("teint")),
                ],
                decoration: InputDecoration(
                  border:OutlineInputBorder(),
                labelText: 'Catégorie du produit',
                ),
                value:selectedCategorie,
                onChanged: (value){
                  setState(() {
                    selectedCategorie = value!;
                  });
                }

            ),
            SizedBox(
              width:double.infinity,
              child:ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate()){
                final productName = productNameController.text;
                final productDescription = productDescriptionController.text;
                final productConseilUtil = productConseilUtilController.text;
                final productMesure = productMesureController.text;
                final productPrix = productPrixController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Envoi en cours..."))
                );

                FocusScope.of(context).requestFocus(FocusNode());

                //ajout dans la collection firebase
               CollectionReference productsRef = FirebaseFirestore.instance.collection("Produits");
               productsRef.add({
                 'libelle': productName,
                 'description': productDescription,
                 'conseilUtil': productConseilUtil,
                 'categorie' : selectedCategorie,
                 'prix' : productPrix,
                 'mesure': productMesure,
                 'dateCreation': DateTime.now(),
                 'activation': 1,
               });
              }
            },
                child: Text("Ajouter"),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

