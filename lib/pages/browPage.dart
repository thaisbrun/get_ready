import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/pages/skinPage.dart';
import 'EyesPage.dart';
import 'connexion.dart';
import 'lipsPage.dart';
import 'myAccount.dart';
import 'myCart.dart';
import 'myFav.dart';
import 'nailsPage.dart';

class BrowPage extends StatefulWidget {
  const BrowPage({super.key, required this.title});
  final String title;

  @override
  State<BrowPage> createState() => _BrowPageState();
}

class _BrowPageState extends State<BrowPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==0) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new MyHomePage(title: MyApp.appTitle)
            )
        );
      }
      if(_selectedIndex==1) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new MyCart()
            )
        );
      }
      if(_selectedIndex==2) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new MyFav()
            )
        );
      }
      if(_selectedIndex==3) {
        if(FirebaseAuth.instance.currentUser != null){
          Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (context) => const MyAccount(title:MyApp.appTitle))
          );
        }else{
          Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (context) => const Connexion())
          );
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits sourcils'),
        backgroundColor: Colors.red[200]!,),
      body: Column(
        children: [
          Flexible(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("SousCategories").where("idCategorie", isEqualTo: FirebaseFirestore.instance.doc('Categories/S06QeCJdPDMn7E4LavRK')).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    return const Text("Aucun produit");
                  }

                  List<dynamic> sousCategories = [];
                  for (var element in snapshot.data!.docs) {
                    sousCategories.add(element);
                  }

                  return ListView.builder(
                    itemCount: sousCategories.length,
                    itemBuilder: (context, index) {
                      final sousCategorie = sousCategories[index];
                      final libelle = sousCategorie['libelle'];

                      return Card(
                        child: ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: 1),
                          title: Text('$libelle'),
                          textColor: Colors.red[200]!,
                          trailing: const Icon(Icons.open_in_new),

                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
                  MaterialPageRoute(builder: (context) => const EyesPage(
                      title: MyApp.appTitle)),
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
                  MaterialPageRoute(builder: (context) => const BrowPage(
                      title: MyApp.appTitle)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits ongles'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NailsPage(
                      title: MyApp.appTitle)),
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
