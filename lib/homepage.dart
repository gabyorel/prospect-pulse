import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospect_pulse/sales.dart';

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
            title: const Text('Prospect Pulse'),   
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Ranking')),
              SalesPage(),
              ProfileScreen()
            ],
          ),
        ),
      ),
    );
  }
}