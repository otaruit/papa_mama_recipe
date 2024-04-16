import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/features/menu/controller/menu_controller.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';

class CreateMenuScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateMenuScreen(),
      );

  const CreateMenuScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateMenuScreen> createState() => _CreateMenuScreenState();
}

class _CreateMenuScreenState extends ConsumerState<CreateMenuScreen> {
  final mainMenuController = TextEditingController();
  final sideMenuController = TextEditingController();
  final soupController = TextEditingController();
  final othersController = TextEditingController();

  bool isAtLeastOneSelected = false;

  void shareMenu() {
    final mainMenu =
        mainMenuController.text.isEmpty ? '0' : mainMenuController.text;
    final sideMenu =
        sideMenuController.text.isEmpty ? '0' : sideMenuController.text;
    final soup = soupController.text.isEmpty ? '0' : soupController.text;
    final others = othersController.text.isEmpty ? '0' : othersController.text;

    final menuEntry = Menu(
      id: '',
      dayOfTheWeek: 0,
      mainDish: mainMenu,
      sideDish: sideMenu,
      soup: soup,
      others: others,
      uid: '',
    );

    ref
        .read(menuControllerProvider.notifier)
        .shareMenu(menu: menuEntry, context: context);

    Navigator.pop(context);
  }

  Widget _buildDropdownSet(String label, TextEditingController controller) {
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
          items: ['Option 1', 'Option 2', 'Option 3']
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
        ),
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
        title: Text('月'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: shareMenu,
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
