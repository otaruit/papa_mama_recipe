import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/core/day_of_the_week_get.dart';
import 'package:papa_mama_recipe/features/menu/controller/menu_controller.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';

class CreateMenuScreen extends ConsumerStatefulWidget {
  static route(Menu menu) => MaterialPageRoute(
        builder: (context) => CreateMenuScreen(
          initialMenu: menu,
        ),
      );
  final Menu? initialMenu;

  CreateMenuScreen({Key? key, this.initialMenu}) : super(key: key);

  @override
  _CreateMenuScreenState createState() => _CreateMenuScreenState();
}

class _CreateMenuScreenState extends ConsumerState<CreateMenuScreen> {
  late TextEditingController mainMenuController;
  late TextEditingController sideMenuController;
  late TextEditingController soupController;
  late TextEditingController othersController;
  bool isAtLeastOneSelected = false;

  @override
  void initState() {
    super.initState();
    mainMenuController =
        TextEditingController(text: widget.initialMenu?.mainDish ?? '');
    sideMenuController =
        TextEditingController(text: widget.initialMenu?.sideDish ?? '');
    soupController =
        TextEditingController(text: widget.initialMenu?.soup ?? '');
    othersController =
        TextEditingController(text: widget.initialMenu?.others ?? '');
  }

  @override
  void dispose() {
    mainMenuController.dispose();
    sideMenuController.dispose();
    soupController.dispose();
    othersController.dispose();
    super.dispose();
  }

  void shareMenu() {
    final mainMenu =
        mainMenuController.text.isNotEmpty ? mainMenuController.text : '0';
    final sideMenu =
        sideMenuController.text.isNotEmpty ? sideMenuController.text : '0';
    final soup = soupController.text.isNotEmpty ? soupController.text : '0';
    final others =
        othersController.text.isNotEmpty ? othersController.text : '0';

    final menuEntry = Menu(
      id: widget.initialMenu?.id ?? '',
      dayOfTheWeek: widget.initialMenu?.dayOfTheWeek ?? 0,
      mainDish: mainMenu,
      sideDish: sideMenu,
      soup: soup,
      others: others,
      uid: widget.initialMenu?.uid ?? '',
    );

    ref
        .read(menuControllerProvider.notifier)
        .shareMenu(menu: menuEntry, context: context);
    Navigator.pop(context);
  }

  bool areDropdownsEmpty() {
    return mainMenuController.text.isEmpty &&
        sideMenuController.text.isEmpty &&
        soupController.text.isEmpty &&
        othersController.text.isEmpty;
  }

  Widget _buildDropdownSet(String label, TextEditingController controller) {
    List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
    String? selectedValue = controller.text.isNotEmpty ? controller.text : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
            value: controller.text.isEmpty ? null : controller.text,
            items: [controller.text, 'Option 2', 'Option 3']
                .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                controller.text = value ?? '';
                isAtLeastOneSelected = true;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              if (dropdownItems.contains(value)) {
                return null;
              } else {
                return '選択した値は無効です';
              }
            })
      ],
    );
  }

  Widget _buildRegistrationButton() {
    return ElevatedButton(
      onPressed: isAtLeastOneSelected ? shareMenu : null,
      child: Text('登録'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(menuControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialMenu != null
            ? VariableTransFormation.getDayOfTheWeek(
                widget.initialMenu!.dayOfTheWeek)
            : '新規作成'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.delete_outline_outlined),
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDropdownSet('メイン', mainMenuController),
                    SizedBox(height: 16),
                    _buildDropdownSet('サイド', sideMenuController),
                    SizedBox(height: 16),
                    _buildDropdownSet('汁物', soupController),
                    SizedBox(height: 16),
                    _buildDropdownSet('その他', othersController),
                    SizedBox(height: 16),
                    _buildRegistrationButton(), // 登録ボタンを追加
                  ],
                ),
              ),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProviderScope(
      child: CreateMenuScreen(),
    ),
  ));
}
