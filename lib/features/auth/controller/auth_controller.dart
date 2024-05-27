import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/apis/auth_api.dart';
import 'package:x_clone/core/utils.dart';
import 'package:x_clone/features/home/view/home_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final AuthAPI authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI: authAPI);
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    if (mounted) {
      login(email: email, password: password, context: context);
    }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      debugPrint(r.email);
    });
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.logIn(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomeView();
        }),
      );
      debugPrint(r.userId);
    });
  }
}
