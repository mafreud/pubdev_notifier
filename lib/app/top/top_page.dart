import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopPage extends ConsumerWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[700],
        title: const Text('TOP'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text('cloud_firestore'),
              subtitle: Text('v3.0.2 - updated xxx days ago'),
              trailing: Icon(Icons.check),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('firebase_auth'),
              subtitle: Text('v3.0.2 - updated xxx days ago'),
              trailing: Icon(
                Icons.check,
                color: Colors.deepPurpleAccent[700],
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('go_router'),
              subtitle: Text('v4.0.0 - updated xxx days ago'),
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
