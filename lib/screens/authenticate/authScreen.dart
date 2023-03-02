import 'package:brew_coffee/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final String mode;
  final Function toggleView;
  const AuthScreen({Key? key, required this.mode, required this.toggleView}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //form state variable
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text(widget.mode == "register" ? "Register to Brew Coffee" : "Sign in to Brew Coffee"),
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: Text(
              widget.mode == "register" ? "Sign In" : "Sign Up",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
                validator: (val) => val!.isEmpty ? "Enter a email" : null,
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                validator: (val) => val!.length > 6 ? null : "Enter a valid password",
                obscureText: true,
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    error = '';
                  });
                  if(_formKey.currentState!.validate()){
                    if (widget.mode == "register"){
                      dynamic user = await _auth.registerWithEmailAndPassword(email, password);
                      if (user == null){
                        setState(() {
                          error = "Something went wrong, Please try again.";
                        });
                      }
                    }else{
                      dynamic user = await _auth.signInWithEmailAndPassword(email, password);
                      if (user == null){
                        setState(() {
                          error = "Can't sign in with given credentials.";
                        });
                      }
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink[400]),
                ),
                child: Text(
                  widget.mode == "register" ? "Register" : "Sign In",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}
