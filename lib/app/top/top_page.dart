import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
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
      body: FirestoreListView<Map<String, dynamic>>(
        query: FirebaseFirestore.instance
            .collection('package')
            .orderBy('packageName'),
        itemBuilder: (context, snapshot) {
          final data = snapshot.data();

          return Card(
            child: ListTile(
              title: Text(data['packageName']),
              subtitle: Text('v${data['version']}'),
              trailing: Icon(
                Icons.check,
                color: Colors.deepPurpleAccent[700],
              ),
            ),
          );
        },
      ),
    );
  }
}
