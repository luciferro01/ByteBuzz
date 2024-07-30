import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/common.dart';
import 'package:x_clone/constants/appwrite_constants.dart';
import 'package:x_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:x_clone/features/user_profile/widgets/user_profile.dart';
import 'package:x_clone/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  final UserModel userModel;
  const UserProfileView(this.userModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update',
              )) {
                copyOfUser = UserModel.fromMap(data.payload);
              }
              return UserProfile(user: copyOfUser);
            },
            error: (error, st) => ErrorText(
              error: error.toString(),
            ),
            loading: () {
              return UserProfile(user: copyOfUser);
            },
          ),
    );
  }
}
