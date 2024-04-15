
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/api/menu_api.dart';
import 'package:papa_mama_recipe/core/utils.dart';
import 'package:papa_mama_recipe/features/auth/controller/auth_controller.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';

final menuControllerProvider = StateNotifierProvider<MenuController, bool>(
  (ref) {
    return MenuController(
      ref: ref,
      menuAPI: ref.watch(menuAPIProvider),
    );
  },
);

final getMenusProvider = FutureProvider((ref) {
  final menuController = ref.watch(menuControllerProvider.notifier);
  return menuController.getMenus();
});

final getLatestMenuProvider = StreamProvider((ref) {
  final menuAPI = ref.watch(menuAPIProvider);
  return menuAPI.getLatestMenu();
});

final getMenuByIdProvider = FutureProvider.family((ref, String id) async {
  final menuController = ref.watch(menuControllerProvider.notifier);
  return menuController.getMenuById(id);
});

class MenuController extends StateNotifier<bool> {
  final MenuAPI _menuAPI;
  final Ref _ref;
  MenuController({
    required Ref ref,
    required MenuAPI menuAPI,
  })  : _ref = ref,
        _menuAPI = menuAPI,
        super(false);

  Future<List<Menu>> getMenus() async {
    final menuList = await _menuAPI.getMenus();
    return menuList.map((menu) => Menu.fromMap(menu.data)).toList();
  }

  Future<Menu> getMenuById(String id) async {
    final menu = await _menuAPI.getMenuById(id);
    return Menu.fromMap(menu.data);
  }

  void shareMenu({
    required Menu menu,
    required BuildContext context,
  }) async {
    state = true;
    final user = _ref.read(currentUserDetailsProvider).value!;
    Menu menuEntry = menu.copyWith();
    final res = await _menuAPI.shareMenu(menuEntry);
    res.fold((l) => showSnackBar(context, l.message), (r) {});
    state = false;
  }
}
