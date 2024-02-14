import 'package:flutter/material.dart';

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
          body: const TabBarView(
            children: [
              Center(child: Text('Ranking')),
              Center(child: Text('Sales')),
              Center(child: Text('Profile'))
            ],
          ),
        ),
      ),
    );
  }
}