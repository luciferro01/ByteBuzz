import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/user_profile/widgets/user_profile.dart';
import 'package:x_clone/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  final UserModel userModel;
  const UserProfileView(this.userModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProfile(user: userModel);
  }
}
