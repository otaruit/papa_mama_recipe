import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/api/user_api.dart';
import 'package:papa_mama_recipe/models/user_model.dart';
import 'package:papa_mama_recipe/core/utils.dart';

final userControllerProvider = StateNotifierProvider<UserController, bool>(
  (ref) {
    return UserController(
      userAPI: ref.watch(userAPIProvider),
    );
  },
);

final getLatestUserDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  UserController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, '設定を更新しました'),
    );
  }
}
