import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_notifier/app/navigation_bar/navigation_bar_page.dart';
import 'package:pubdev_notifier/app/sign_in/sign_in_page.dart';
import 'package:pubdev_notifier/utils/firebase/firebase_auth/firebase_auth_service.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStream = ref.watch(authStateStreamProvider);
    return authStream.when(
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      error: (error, stack) => Text('error:$error'),
      data: (user) {
        if (user == null) {
          return const SignInPage();
        }
        return const NavigationBarPage();
      },
    );
  }
}
