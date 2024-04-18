import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:papa_mama_recipe/constants/assets_constants.dart';
import 'package:papa_mama_recipe/constants/ui_constants.dart';
import 'package:papa_mama_recipe/core/day_of_the_week_get.dart';
import 'package:papa_mama_recipe/features/menu/view/create_menu_view.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';
import 'package:papa_mama_recipe/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateMenu() {
    final passMenu = Menu(
        id: '',
        mainDish: '',
        sideDish: '',
        soup: '',
        others: '',
        dayOfTheWeek: 0,
        uid: '');
    Navigator.push(context, CreateMenuScreen.route(passMenu));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
        
      ),
    
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
                icon: _page == 0
                    ? Icon(Icons.event, size: 30)
                    : Icon(
                        Icons.event_available_outlined,
                        size: 30,
                        color: Pallete.redColor,
                      ),
                label: 'らいしゅう',
          ),
          BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_dining,
                  size: 30,
                  color: Pallete.redColor,
                ),
                label: 'レシピ',
          ),
          BottomNavigationBarItem(
                icon: Icon(
                  Icons.format_list_bulleted,
                  size: 30,
                  color: Pallete.redColor,
                ),
                label: 'かいものリスト',
              )
            ]));
  }
}
