import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'deletePost',
            onPressed: () =>
                context.push('/bottomNavigationBar/timeline/deletePost'),
            child: const Icon(Icons.delete),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'newPostDialog',
            onPressed: () =>
                context.push('/bottomNavigationBar/timeline/newPostDialog'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[700],
        title: const Text(
          'タイムライン',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: (context),
                  builder: (context) => AlertDialog(
                    title: const Text('ブロック・通報'),
                    content: const Text(
                      '投稿の「ban」マークをタップすると、投稿を通報またはブロックできます。通報した場合は、運営が24時間に対応し、ブロックの場合は、投稿を即非表示にできます。',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                        ),
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: FirestoreListView<Map<String, dynamic>>(
        query: FirebaseFirestore.instance
            .collection('timeline')
            .orderBy('createdAt', descending: true),
        itemBuilder: (context, snapshot) {
          Map<String, dynamic> data = snapshot.data();
          final userId = FirebaseAuth.instance.currentUser!.uid;
          final likedBy = data['likedBy'].cast<String>() as List<String>;
          final blockedBy = data['blockedBy'].cast<String>() as List<String>;

          final hasBlockedByMe = blockedBy.contains(userId);
          print(hasBlockedByMe);

          final hasLikedByMe = likedBy.contains(userId);

          return Visibility(
            visible: !hasBlockedByMe,
            child: Card(
              child: ListTile(
                title: Text(data['title']),
                subtitle: Text(data['body']),
                trailing: SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('timeline')
                              .doc(snapshot.id)
                              .update({
                            'likedBy': FieldValue.arrayUnion([userId])
                          });
                        },
                        icon: hasLikedByMe
                            ? const Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Colors.pink,
                              )
                            : const Icon(FontAwesomeIcons.heart),
                      ),
                      Text('x${likedBy.length}'),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.ban),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('通報 or ブロックしますか?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          final userId = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          await FirebaseFirestore.instance
                                              .collection('reports')
                                              .add({
                                            'createdAt': Timestamp.now(),
                                            'reporter': userId,
                                            'timelineDocId': snapshot.id,
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('投稿を通報しました'),
                                                    content: const Text(
                                                      '通報内容を確認し、24時間いないに対応します。',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('了解'))
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('通報')),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            final userId = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            await FirebaseFirestore.instance
                                                .collection('timeline')
                                                .doc(snapshot.id)
                                                .update({
                                              'blockedBy':
                                                  FieldValue.arrayUnion(
                                                      [userId])
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text('ブロック'))
                                    ],
                                  ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
