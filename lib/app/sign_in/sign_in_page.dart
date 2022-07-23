import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pubdev_notifier/utils/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[700],
        title: const Text(
          'WELCOME',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Ima
              child: const Image(
                image: AssetImage('assets/pubdev_icon.png'),
                width: 120,
              ),
            ),
            const SizedBox(height: 100),
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
                // TODO(someone): add indicator
                // TODO(someone): move to firebase_messaging_service
                NotificationSettings settings =
                    await FirebaseMessaging.instance.requestPermission(
                  alert: true,
                  announcement: false,
                  badge: true,
                  carPlay: false,
                  criticalAlert: false,
                  provisional: false,
                  sound: true,
                );

                debugPrint(
                    'User granted permission: ${settings.authorizationStatus}');
                await auth.signIn();
                if (!mounted) return;
                context.go('/top');
              },
              child: const Text(
                'SIGN IN',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text(
                  'By pressing SIGN IN, \nyou agree to the Terms of Use.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent[700],
                  ),
                ),
                onTap: () => _launchUrl(
                    'https://ringed-saga-119.notion.site/9285c1859ebd43f4b806f15416797058'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String inputUrl) async {
    final Uri url = Uri.parse(inputUrl);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }
}
