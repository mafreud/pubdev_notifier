import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pubdev_notifier/app/navigation_bar/navigation_bar_page.dart';
import 'package:pubdev_notifier/app/sign_in/sign_in_page.dart';
import 'package:pubdev_notifier/app/timeline/new_post_dialog.dart';

import 'app/auth_gate/auth_gate.dart';
import 'app/timeline/delete_post.dart';
import 'app/timeline/timeline_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        theme: ThemeData(
            colorSchemeSeed: Colors.deepPurpleAccent[700], useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      );

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/signIn',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/bottomNavigationBar',
        builder: (context, state) => const NavigationBarPage(),
        routes: [
          GoRoute(
            path: 'timeline',
            builder: (context, state) => const TimelinePage(),
            routes: [
              GoRoute(
                path: 'newPostDialog',
                pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true, child: NewPostDialog()),
              ),
              GoRoute(
                path: 'deletePost',
                pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true, child: DeletePost()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
