import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/pages/register.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}
class _ConnexionState extends State<Connexion> {

  final mdpController = TextEditingController();
  final mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    mdpController.dispose();
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
      title:const Text('Connexion'),
          backgroundColor: Colors.red[200]!),
     body:Container(
          margin:const EdgeInsets.all(20),
      child: Form(
      key: _formKey,
      child:Column(
      children: [
      Container(
      margin: const EdgeInsets.only(top:250,bottom: 10),
      child: TextFormField(
      decoration: InputDecoration(
      labelText: 'Mail  ',
      hintText: 'Entrez votre mail',
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
      decoration: InputDecoration(
      labelText: 'Mot de passe ',
      hintText: 'Entrez votre mot de passe',
        enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[200]!, width: 2.0),
        ),
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
                const SnackBar(content:Text('Aucun utilisateur trouvé pour ces informations de connexion'));
              } else if (e.code == 'wrong-password') {
                const SnackBar(content:Text('Les informations de connexion sont incorrectes'));
              }

            }
          },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
            child: const Text("Me connecter"),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0),
        child:CupertinoButton(
          child: const Text("Créer mon compte"),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const RegisterPage()),
            );
          },
        ),)
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