import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/features/recipe/view/edit_recipe_view.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_stream_builder.dart';

class RecipeList extends ConsumerStatefulWidget {
  RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends ConsumerState<RecipeList> {
  final searchController = TextEditingController();
  bool isShowRecipes = false;
  late int recipeType = 0;
  String selectedCategory = 'メイン';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _extractRecipeIdFromEvent(String event) {
    final startingPoint = event.lastIndexOf('documents.');
    final endPoint = event.lastIndexOf('.create');
    return event.substring(startingPoint + 10, endPoint);
  }

  Widget _buildRadioButton(String label, int index) {
    Color? buttonColor;
    switch (index) {
      case 0:
        buttonColor = recipeType == 0 ? Colors.red : Colors.grey[300]; // メイン
        break;
      case 1:
        buttonColor = recipeType == 1 ? Colors.blue : Colors.grey[300]; // サイド
        break;
      case 2:
        buttonColor = recipeType == 2 ? Colors.green : Colors.grey[300]; // スープ
        break;
      case 3:
        buttonColor = recipeType == 3 ? Colors.orange : Colors.grey[300]; // その他
        break;
      default:
        buttonColor = Colors.grey[300]; // デフォルトは灰色
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          recipeType = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          label,
          style: TextStyle(
            color: recipeType == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('レシピリスト'),
        actions: [
          IconButton(
            onPressed: CreateRecipeScreen(
              initialRecipe: Null,
            ),
            icon: Icon(Icons.create),
          ),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // 枠線の色を指定
              ),
              borderRadius: BorderRadius.circular(8.0), // 枠線の角を丸める
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      setState(() {
                        isShowRecipes = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search recipes...',
                      border: InputBorder.none, // 枠線を非表示にする
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'レシピ種別',
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              _buildRadioButton('メイン', 0),
              const SizedBox(width: 8),
              _buildRadioButton('サイド', 1),
              const SizedBox(width: 8),
              _buildRadioButton('スープ', 2),
              const SizedBox(width: 8),
              _buildRadioButton('その他', 3),
            ],
          ),
        ),
        isShowRecipes
            ? const SizedBox()
            : Expanded(
                child: StreamRecipeList(
                recipeType: recipeType,
                searchWord: searchController.text,
              )),
      ]),
    );
  }
}
