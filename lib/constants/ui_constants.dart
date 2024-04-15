import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:papa_mama_recipe/constants/assets_constants.dart';
import 'package:papa_mama_recipe/features/menu/widget/menu_list.dart';
import 'package:papa_mama_recipe/theme/pallete.dart';


class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    MenuList(),
    // ExploreView(),
    // NotificationView(),
  ];
}
