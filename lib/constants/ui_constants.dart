import 'package:flutter/material.dart';
import 'package:papa_mama_recipe/features/menu/widget/menu_list.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_list.dart';


class UIConstants {
  static AppBar appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: null,
        icon: Icon(Icons.settings),
      ),
      title: const Text('今週のレシピ'),
      actions: [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.delete_outline_outlined),
        ),
      ],
    );
  }

  static const List<Widget> bottomTabBarPages = [
    MenuList(),
    RecipeList(),
    // NotificationView(),
  ];
}
