import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_notifier/utils/auth/auth_service.dart';

class SignInController extends StateNotifier<AsyncValue<void>> {
  SignInController({required this.authService})
      : super(const AsyncValue.data(null));

  final AuthService authService;

  Future<void> signIn() async {
    state = const AsyncValue<void>.loading();
    state = await AsyncValue.guard(() => authService.signIn());
  }

  Future<void> signOut() async {
    state = const AsyncValue<void>.loading();
    state = await AsyncValue.guard(() => authService.signOut());
  }
}

final signInControllerProvider =
    StateNotifierProvider<SignInController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SignInController(authService: authService);
});
