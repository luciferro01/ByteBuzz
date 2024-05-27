import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/apis/auth_api.dart';
import 'package:x_clone/apis/user_api.dart';
import 'package:x_clone/core/utils.dart';
import 'package:x_clone/features/auth/view/login_view.dart';
import 'package:x_clone/features/home/view/home_view.dart';
import 'package:x_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final AuthAPI authAPI = ref.watch(authAPIProvider);
  final UserAPI userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI: authAPI, userAPI: userAPI);
});

final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel, r.$id);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
          showSnackBar(context, 'Accounted created successfully!');
        });
      },
    );
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
