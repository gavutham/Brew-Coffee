import 'package:brew_coffee/models/brew.dart';
import 'package:brew_coffee/screens/home/settings_form.dart';
import 'package:brew_coffee/services/auth.dart';
import 'package:brew_coffee/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'brew_list.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      initialData: [],
      value: DatabaseService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text("Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
              label: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(
              onPressed: () => _showSettingsPanel(),
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              label: Text(
                "Settings",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: BrewList(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/coffee_bg.png"),
              fit: BoxFit.cover,
            )
          ),
        ),
      ),
    );
  }
}
