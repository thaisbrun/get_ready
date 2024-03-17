import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/skinPage.dart';

import '../main.dart';
import 'EyesPage.dart';
import 'browPage.dart';
import 'lipsPage.dart';
import 'nailsPage.dart';

class GetProduct extends StatefulWidget {
  const GetProduct({super.key, required this.title, required this.firestoreDocID});
  final String title;
  final String? firestoreDocID;
  @override
  State<GetProduct> createState() => _GetProductState();

}
class _GetProductState extends State<GetProduct> {
  int _selectedIndex = 0;

  get firestoreDocID => 'AXg2ouAmz9t6115IFvdM';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(product.libelle),
      ),
      body:
      Padding(
    padding: EdgeInsets.all(20.0),
    child:
        Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          'Informations du produit',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
    Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Image.network(
        'https://via.placeholder.com/150',
        width: 150,
        height: 150,
      ),
      SizedBox(
        child: Flexible(
           child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:FutureBuilder(
              future: FirebaseFirestore.instance.collection("Produits").doc(firestoreDocID).get(),
             builder: (BuildContext context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return const CircularProgressIndicator();
               }

               if (!snapshot.hasData) {
                 return const Text("Aucun produit");
               }
               var product = snapshot.data;
               return Card(
                child: Text(product!["conseilUtil"]),
                color: Colors.red[200]!
               );
             },
            ),
           ),
          ),
      ),],
    ),],),),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFEF9A9A),
              ),
              child: Text('Get Ready'),
            ),
            ListTile(
              title: const Text('Produits teint'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SkinPage(title: MyApp.appTitle)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits yeux'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EyesPage(title: MyApp.appTitle)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits lèvres'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LipsPage(title: MyApp.appTitle)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits sourcils'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrowPage(title: MyApp.appTitle)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits ongles'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NailsPage(title:MyApp.appTitle)),
                );
              },
            ),
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'Mon Compte',
          )
        ],
        selectedItemColor: Colors.red[200],
      ),
    );
  }
  }
