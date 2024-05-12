import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/pages/product_by_category_page.dart';

import '../models/user_model.dart';
import '../services/utilisateur_service.dart';
import 'connexion.dart';
import 'my_cart.dart';
import 'my_fav.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key, required this.title});
  final String title;

  @override
  State<MyAccount> createState() => _MyAccountState();

}

class _MyAccountState extends State<MyAccount> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  Utilisateur utilisateur = Utilisateur();
  final _formKey = GlobalKey<FormState>();
  UtilisateurService utilisateurService = UtilisateurService();
  int _selectedIndex = 0;
  final idController = TextEditingController();
  final mailController = TextEditingController();
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final telController = TextEditingController();
  final refUserAuthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData(); //On appelle la fonction de chargement des infos de l'utilisateur connecté
  }
  Future<void> loadUserData() async {
    // Récupérer les données complètes de l'utilisateur avec l'id de l'utilisateur connecté
    Utilisateur utilisateur = (await UtilisateurService().getUserLinkToFirestore(user?.uid)) as Utilisateur;

    // Mettre à jour l'état du widget
    setState(() {
      idController.text = utilisateur.id!;
      prenomController.text = utilisateur.prenom!;
      nomController.text = utilisateur.nom!;
      refUserAuthController.text = utilisateur.refUserAuth!;
      telController.text = utilisateur.telephone!;
      mailController.text = user!.email!;
    });
  }
  //méthode de déconnexion
  signOut() async {
    await auth.signOut();
    //Redirection vers la page de connexion
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Connexion()));
  }

  //Pour la navbar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==0) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyHomePage(title: MyApp.appTitle)
            )
        );
      }
      if(_selectedIndex==1) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyCart()
            )
        );
      }
      if(_selectedIndex==2) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyFav()
            )
        );
      }
      if(_selectedIndex==3) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyAccount(title:MyApp.appTitle)
            )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Mes informations de profil'),
            backgroundColor: Colors.red[200]!),
        body:Container(
    child: Column(
        children:[
        Image.asset("assets/images/getready2.png"),
        Form(
    key: _formKey,
    child:Column(
      children: [
      Container(
    margin: const EdgeInsets.only(bottom: 10, top:50, left:20, right:20),
    child: TextFormField(
    decoration: InputDecoration(
    labelText: "Prénom : ",
    border:const OutlineInputBorder(),
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
    margin: const EdgeInsets.only(bottom: 10,left:20, right:20),
    child: TextFormField(
    decoration: InputDecoration(
    labelText: "Nom : ",
    border:const OutlineInputBorder(),
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
    margin: const EdgeInsets.only(bottom: 10,left:20, right:20),
    child: TextFormField(
    decoration:  InputDecoration(
    labelText: "Téléphone : ",
    border:const OutlineInputBorder(),
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
    margin: const EdgeInsets.only(bottom: 30,left:20, right:20),
    child: TextFormField(
      decoration: InputDecoration(
    labelText: "Mail : ",
    border:const OutlineInputBorder(),
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
      SizedBox(
        child: ElevatedButton(
          onPressed: () async {
            utilisateur = utilisateur;
            utilisateur.id = idController.text;
            utilisateur.prenom = prenomController.text;
            utilisateur.refUserAuth = refUserAuthController.text;
            utilisateur.nom = nomController.text;
            utilisateur.telephone = telController.text;
            String mail = mailController.text;
         //Mettre la modification de l'utilisateur
            user?.updateEmail(mail).then((_) {
              // Succès : l'email de l'utilisateur a été mis à jour avec succès
              print('Email mis à jour avec succès.');
              const snackBar = SnackBar(content: Text('Vos informations de profil ont bien été modifiées.'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }).catchError((error) {
              // Erreur : afficher un message d'erreur ou traiter l'erreur selon les besoins
              print('Erreur lors de la mise à jour de l\'email : $error');
            });
            utilisateurService.updateUser(utilisateur);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 50.0), )
          ),

          child: const Text("Modifier mon profil", selectionColor: Colors.white),

        ),

      ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
      child:CupertinoButton(
        child: const Text("Déconnexion"),
        onPressed: () {
          signOut();
        },
      ),),
    ],
    ),
    ),])
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


      ),
    );
  }
  }
