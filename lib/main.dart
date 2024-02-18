import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prospect_pulse/auth_gate.dart';
import 'package:prospect_pulse/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProspectPulse());
}

class ProspectPulse extends StatelessWidget {
  const ProspectPulse({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}
