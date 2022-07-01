import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TopPage extends ConsumerWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.go('/');
            },
            icon: const Icon(Icons.exit_to_app_outlined),
          )
        ],
        backgroundColor: Colors.deepPurpleAccent[700],
        title: const Text('TOP'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('cloud_firestore'),
              subtitle: const Text('v3.0.2 - updated xxx days ago'),
              trailing: Icon(
                Icons.check,
                color: Colors.deepPurpleAccent[700],
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('firebase_auth'),
              subtitle: const Text('v3.0.2 - updated xxx days ago'),
              trailing: Icon(
                Icons.check,
                color: Colors.deepPurpleAccent[700],
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('go_router'),
              subtitle: const Text('v4.0.0 - updated xxx days ago'),
              trailing: Icon(
                Icons.check,
                color: Colors.deepPurpleAccent[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
