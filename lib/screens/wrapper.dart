import 'package:brew_coffee/models/user.dart';
import 'package:brew_coffee/screens/authenticate/authenticate.dart';
import 'package:brew_coffee/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<BrewUser?>(context);

    return user != null ? Home() : const Authenticate();
  }
}
