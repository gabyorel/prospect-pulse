import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:provider/provider.dart';          // new

import 'app_state.dart';                          // new
import 'src/authentication.dart';                 // new
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.analytics)),
                Tab(icon: Icon(Icons.attach_money)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
            title: const Text('ProspectPulse'),   
          ),
          body: TabBarView(
            children: [
              Consumer<ApplicationState>(
                builder: (context, appState, _) =>
                AuthFunc(loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}            