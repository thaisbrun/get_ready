import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/pages/connexion.dart';
import 'package:get_ready/pages/product_by_category_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  final mailController = TextEditingController();
  final mdpController = TextEditingController();
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final telController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    mdpController.dispose();
    telController.dispose();
    nomController.dispose();
    prenomController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Inscription'),
            backgroundColor: Colors.red[200]!),
    body:Container(
      margin:const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child:Column(
          children: [
        Container(
        margin: const EdgeInsets.only(top:40,bottom: 10),
            child:const Text('Inscrivez-vous dès maintenant ! ',
                style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.pink,
                fontSize: 20))
        ),
            Container(
              margin: const EdgeInsets.only(top:50,bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Prénom ",
                  hintText: "Entrez votre prénom ",
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200]!, width: 2.0),
                  ),
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
                decoration: InputDecoration(
                  labelText: "Nom ",
                  hintText: "Entrez votre nom ",
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200]!, width: 2.0),
                  ),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le nom ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: nomController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Téléphone ",
                  hintText: "Entrez votre numéro de téléphone ",
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200]!, width: 2.0),
                  ),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Le numéro ne peut pas être invalide. ";
                  }
                  return null;
                },
                controller: telController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Mail ",
                  hintText: "Entrez votre adresse mail ",
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200]!, width: 2.0),
                  ),
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
              margin: const EdgeInsets.only(bottom: 40),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe ',
                  hintText: 'Entrez votre mdp',
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200]!, width: 2.0),
                  ),
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
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: MyApp.appTitle)),
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
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
              ),
                child: const Text("M'inscrire", selectionColor: Colors.white),
            ),
  ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
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
    ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"), // Remplacez "votre_image.jpg" par le chemin de votre image
                  fit: BoxFit.cover,
                ),
                color: Color(0xFFEF9A9A),
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Produits teint'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'S06QeCJdPDMn7E4LavRK')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits yeux'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'IJNzsCvZlQiYLgWsOT8k')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits lèvres'),
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'zqlU4lCuCAfiu30KIH6h')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits sourcils'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'3C5vfgtxttPvB0Nc79d2')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits ongles'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'4UFwQChDvPHUrg7k8XiS')),
                );
              },
            ),
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Mon Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Mes favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'Mon Compte',
          )
        ],
        selectedItemColor: Colors.red[200],


      ),    );
  }
}

