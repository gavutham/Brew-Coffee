import 'package:brew_coffee/models/user.dart';
import 'package:brew_coffee/services/database.dart';
import 'package:brew_coffee/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_coffee/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName = "";
  String _currentSugars = "";
  int _currentStrength = 0;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BrewUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Text(
                  "Update your brew settings.",
                  style: TextStyle(
                      fontSize: 18.0
                  ),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  initialValue: userData?.name,
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? "Please enter a value" : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0,),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars == "" ? userData?.sugars : _currentSugars,
                  items: sugars.map((sugar){
                    return DropdownMenuItem(
                        value: sugar,
                        child: Text('${sugar} sugars')
                    );
                  }).toList(),
                  onChanged: (val) => _currentSugars = val.toString(),
                ),
                SizedBox(height: 20.0,),
                Slider(
                  value: _currentStrength == 0 ? userData!.strength.toDouble() : _currentStrength.toDouble(),
                  activeColor: Colors.brown[_currentStrength],
                  inactiveColor: Colors.white,
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(() {
                    _currentStrength = val.toInt();
                  }),
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                       await DatabaseService(uid: user.uid).updateUserData(
                         _currentSugars != '' ? _currentSugars : userData!.sugars,
                         _currentName != "" ? _currentName: userData!.name,
                         _currentStrength != 0 ? _currentStrength : userData!.strength,
                       );
                       Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink[400]),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          );
        }else{
          return Loading();
        }

      }
    );
  }
}
