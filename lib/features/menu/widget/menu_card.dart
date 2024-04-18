import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/core/day_of_the_week_get.dart';
import 'package:papa_mama_recipe/features/menu/view/create_menu_view.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';
import 'package:papa_mama_recipe/theme/pallete.dart';

class MenuCard extends ConsumerWidget {
  final Menu menu;

  MenuCard({
    Key? key,
    required this.menu,
  }) : super(key: key);

  Widget _buildItem({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 4),
        Flexible(
          // Use Flexible instead of Expanded
          child: Text(
            value,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, CreateMenuScreen.route(menu));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.blueColor,
                      ),
                      child: Center(
                        child: Text(
                        VariableTransFormation.getDayOfTheWeek(
                            menu.dayOfTheWeek),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildItem(label: 'メイン', value: menu.mainDish),
                      _buildItem(label: 'サイド', value: menu.sideDish),
                      _buildItem(label: 'スープ', value: menu.soup),
                      _buildItem(label: 'その他', value: menu.others),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
