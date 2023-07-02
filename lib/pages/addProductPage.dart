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

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
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
            SizedBox(
              width:double.infinity,
            child:ElevatedButton(onPressed: (){
              if(_formKey.currentState!.validate()){
                final productName = productNameController.text;
                final productDescription = productDescriptionController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Envoi en cours..."))
                );

                FocusScope.of(context).requestFocus(FocusNode());
                print("Ajout du produit $productName avec la description $productDescription .");
              }
            },
                child: Text("Ajouter")
            ),
            )
          ],
        ),
      ),
    );
  }
}

