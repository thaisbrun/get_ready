import 'package:flutter/material.dart';
import 'package:get_ready/pages/lipsPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Ready"),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/imageTest.jpg"),
            const Text(
              "Application de vente de cosmétiques",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const Text("Rouge à lèvres, fard à paupières, fond de teint, blush...",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Avenir',
              ),
            ),
            Padding(padding: EdgeInsets.only(top:20)),
            ElevatedButton.icon(
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                backgroundColor: MaterialStatePropertyAll(Colors.pinkAccent),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_,__,___) => LipsPage()
                    )
                );
              },
              label: Text("Page lèvres",
                style: TextStyle(
                    fontSize: 20
                ),), icon: Icon(Icons.abc_outlined),)
          ],
        ),
      ),
    );
  }
}
