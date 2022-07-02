import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final packageStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((_) {
  return FirebaseFirestore.instance.collection('package').snapshots();
});

class TopPage extends ConsumerWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageStream = ref.watch(packageStreamProvider);
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('package').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            final qs = snapshot.data as QuerySnapshot<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: qs.docs.length,
              itemBuilder: (_, index) {
                final docs = qs.docs[index];
                final data = docs.data();

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
            );
          },
        ));
  }
}
