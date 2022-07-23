import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletePost extends ConsumerWidget {
  const DeletePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿を削除'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('timeline')
            .where('author', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final qs = snapshot.data;
          if (qs!.docs.isEmpty) {
            return const Center(
              child: Text('投稿がありません'),
            );
          }
          return ListView.builder(
            itemCount: qs.docs.length,
            itemBuilder: ((context, index) {
              final docs = qs.docs[index];
              final data = docs.data()! as Map<String, dynamic>;
              final docId = docs.id;

              return Card(
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['body']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('警告'),
                            content: const Text('本当に削除しますか'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('キャンセル'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await FirebaseFirestore.instance
                                      .collection('timeline')
                                      .doc(docId)
                                      .delete();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
