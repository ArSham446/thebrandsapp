import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  const Warning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('suppliers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!['warnmsg'] == null) {
                  return const Text(
                    'You have no warnings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                } else {
                  return Text(
                    snapshot.data!['warnmsg'],
                    style: const TextStyle(fontSize: 20),
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
