import 'package:flutter/material.dart';
import 'package:papa_mama_recipe/features/menu/widget/menu_list.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_list.dart';
import 'package:papa_mama_recipe/features/settings/view/edit_settings_view.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const CustomButton({
    required this.label,
    required this.color,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.black, fontSize: 13),
      ),
    );
  }
}


class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: const Text('今週のレシピ'),
      actions: [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.delete_outline_outlined),
        ),
      ],
    );
  }

  static List<Widget> bottomTabBarPages = [
    MenuList(),
    RecipeList(),
    EditSettingsScreen()
  ];

 
}
