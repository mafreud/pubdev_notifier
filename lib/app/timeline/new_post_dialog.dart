import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewPostDialog extends StatefulHookConsumerWidget {
  const NewPostDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPostDialogState();
}

class _NewPostDialogState extends ConsumerState<NewPostDialog> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final title = useTextEditingController();
    final body = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイムライン投稿'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(labelText: 'タイトル'),
              validator: (value) {
                if (value == null) {
                  return 'タイトルを入力してください';
                }
                return null;
              },
            ),
            TextFormField(
              controller: body,
              decoration: const InputDecoration(labelText: '本文'),
              validator: (value) {
                if (value == null) {
                  return '本文を入力してください';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final userId = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance.collection('timeline').add(
                    {
                      'author': userId,
                      'blockedBy': [],
                      'body': body.text,
                      'createdAt': Timestamp.now(),
                      'title': title.text,
                      'likedBy': [],
                    },
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('投稿'),
            )
          ],
        ),
      ),
    );
  }
}
