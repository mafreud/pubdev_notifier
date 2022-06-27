import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pubdev_notifier/utils/auth/auth_service.dart';

import 'package:cloud_functions/cloud_functions.dart';

/// Sign In Page
class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[700],
        title: const Text('WELCOME'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to pub.dev notifier',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await FirebaseFunctions.instance
                    .httpsCallable('helloWorld')
                    .call();
                print(result);

                // final response =
                //     await http.get(Uri.parse(_packageUrl('cloud_firestore')));
                // final json = jsonDecode(response.body) as Map<String, dynamic>;
                // final version = json['latest']['version'] as String;
                // print(version);
              },
              child: const Text('test'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent[700],
              ),
              onPressed: () async {
                await auth.signIn();
                // ignore: use_build_context_synchronously
                context.go('/top');
              },
              child: const Text('SIGN IN'),
            )
          ],
        ),
      ),
    );
  }

  String _packageUrl(String packageName) =>
      'https://pub.dev/api/packages/$packageName';

  String _changelogUrl(String packageName) =>
      'https://pub.dev/packages/$packageName/changelog';
}
