import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';

import 'myCart.dart';
import 'myFav.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key, required this.title});
  final String title;

  @override
  State<MyAccount> createState() => _MyAccountState();

}

class _MyAccountState extends State<MyAccount> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  final mailController = TextEditingController();
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final telController = TextEditingController();

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyHomePage(title: MyApp.appTitle)));
  }
  @override
  void dispose() {
    super.dispose();
    prenomController.dispose();
    nomController.dispose();
    telController.dispose();
    mailController.dispose();
  }
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
        margin:const EdgeInsets.all(20),
    child: Form(
    key: _formKey,
    child:Column(
    children: [
    Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
    decoration: const InputDecoration(
    labelText: "Prénom : ",
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
    labelText: "Nom : ",
    border:OutlineInputBorder(),
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
    decoration: const InputDecoration(
    labelText: "Téléphone : ",
    border:OutlineInputBorder(),
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
      decoration: const InputDecoration(
    labelText: "Mail : ",
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
      SizedBox(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: mailController.text,
                password: prenomController.text,
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
          child: const Text("Modifier mon profil", selectionColor: Colors.white),
        ),
      ),
      CupertinoButton(
        child: const Text("Déconnexion"),
        onPressed: () {
          signOut();
        },
      ),
    ],
    ),
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
