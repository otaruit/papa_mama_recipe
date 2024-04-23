import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/features/menu/controller/menu_controller.dart';
import 'package:papa_mama_recipe/features/menu/widget/menu_card.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';

class MenuList extends ConsumerWidget {
  const MenuList({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Menu> menuList = List.generate(
      7,
      (index) => Menu(
        id: '',
        dayOfTheWeek: index,
        mainDish: '',
        sideDish: '',
        soup: '',
        others: '',
        uid: '',
      ),
    );

    return ref.watch(getMenusProvider).when(
          data: (menus) {
            // menusをMap<int, Menu>に変換する
            Map<int, Menu> menuMap = Map.fromIterable(
              menus,
              key: (menu) => menu.dayOfTheWeek,
              value: (menu) => menu,
            );

            // menuListの各要素を更新する
            for (int i = 0; i < menuList.length; i++) {
              int dayOfTheWeek = menuList[i].dayOfTheWeek;
              if (menuMap.containsKey(dayOfTheWeek)) {
                menuList[i] = menuMap[dayOfTheWeek]!;
              }
            }

            return ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (BuildContext context, int index) {
                final menu = menuList[index];
                return MenuCard(menu: menu);
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
