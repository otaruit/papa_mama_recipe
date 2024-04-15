import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/constants/assets_constants.dart';
import 'package:papa_mama_recipe/features/auth/controller/auth_controller.dart';
import 'package:papa_mama_recipe/features/menu/controller/menu_controller.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';
import 'package:papa_mama_recipe/theme/pallete.dart';

class CreateMenuScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateMenuScreen(),
      );
  const CreateMenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateMenuScreenState();
}

class _CreateMenuScreenState extends ConsumerState<CreateMenuScreen> {
  final dayOfTheWeekController = TextEditingController();
  final mainMenuController = TextEditingController();
  final sideMenuController = TextEditingController();
  final soupController = TextEditingController();
  final othersController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dayOfTheWeekController.dispose();
  }

  void shareMenu() {
    // 足りないところがある場合　実行しない
    //    if (menuNameController.text.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('レシピ名を入力してください'),
    //     ),
    //   );
    //   return;
    // }

    // コントローラーの値が空の場合は'0'に設定
    final dayOfTheWeek =
        dayOfTheWeekController.text.isEmpty ? '0' : dayOfTheWeekController.text;
    final mainMenu =
        dayOfTheWeekController.text.isEmpty ? '0' : dayOfTheWeekController.text;
    final sideMenu =
        dayOfTheWeekController.text.isEmpty ? '0' : dayOfTheWeekController.text;
    final soup =
        dayOfTheWeekController.text.isEmpty ? '0' : dayOfTheWeekController.text;
    final others =
        dayOfTheWeekController.text.isEmpty ? '0' : dayOfTheWeekController.text;

    final menuEntry = Menu(
        id: '',
        dayOfTheWeek: int.parse(dayOfTheWeek),
        mainDish: mainMenu,
        sideDish: sideMenu,
        soup: soup,
        others: others,
        uid: '');
    ref
        .read(menuControllerProvider.notifier)
        .shareMenu(menu: menuEntry, context: context);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(menuControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: shareMenu, // onTapで呼び出す関数を指定
            icon: Icon(Icons.menu), // ボタンの左側に表示するアイコン
            label: Text('Menu'), // ボタンに表示するテキスト
            style: ElevatedButton.styleFrom(
              primary: Pallete.blueColor, // ボタンの背景色
              onPrimary: Pallete.whiteColor, // テキストの色
            ),
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: null,
                          radius: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: dayOfTheWeekController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
