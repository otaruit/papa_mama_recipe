import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/features/menu/controller/menu_controller.dart';
import 'package:papa_mama_recipe/features/menu/widget/menu_card.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';


class MenuDetailsScreen extends ConsumerWidget {
  static route(Menu menu) => MaterialPageRoute(
        builder: (context) => MenuDetailsScreen(
          menu: menu,
        ),
      );
  final Menu menu;
  const MenuDetailsScreen({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        title: const Text('Menu'),
          actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigator.push(
              //     context, ReviseFormulationView.route(recipe: widget.recipe));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          MenuCard(menu: menu),
          ref.watch(getLatestMenuProvider).when(
                data: (menus) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return MenuCard(menu: menu);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return MenuCard(menu: menu);
                              },
                            ),
                          );
                        },)
        ],
      ),
    );
  }
}
