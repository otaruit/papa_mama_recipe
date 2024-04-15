import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/constants/appwrite_constants.dart';
import 'package:papa_mama_recipe/features/menu/controller/menu_controller.dart';
import 'package:papa_mama_recipe/features/menu/widget/menu_card.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';


class MenuList extends ConsumerWidget {
  const MenuList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getMenusProvider).when(
          data: (menus) {
            return ref.watch(getLatestMenuProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.menusCollection}.documents.*.create',
                    )) {
                      menus.insert(0, Menu.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.menusCollection}.documents.*.update',
                    )) {
                      // get id of original menu
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final menuId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var menu = menus
                          .where((element) => element.id == menuId)
                          .first;

                      final menuIndex = menus.indexOf(menu);
                      menus.removeWhere((element) => element.id == menuId);

                      menu = Menu.fromMap(data.payload);
                      menus.insert(menuIndex, menu);
                    }

                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (BuildContext context, int index) {
                        final menu = menus[index];
                        return MenuCard(menu: menu);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (BuildContext context, int index) {
                        final menu = menus[index];
                        return MenuCard(menu: menu);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
