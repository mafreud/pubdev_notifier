import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pubdev_notifier/utils/firebase/firebase_auth/firebase_auth_service.dart';

/// Sign In Page
class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthServiceProvider);
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
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent[700],
              ),
              onPressed: () async {
                await firebaseAuth.sigInAnonymously();
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
}
