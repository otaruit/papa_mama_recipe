import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/constants/appwrite_constants.dart';
import 'package:papa_mama_recipe/features/recipe/controller/recipe_controller.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_card.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late TextEditingController searchController;
  late int recipeType = 0;
  String selectedCategory = 'メイン';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

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
            onPressed: null,
            icon: Icon(Icons.create),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                      decoration: InputDecoration(
                        hintText: 'Search recipes...',
                        border: InputBorder.none, // 枠線を非表示にする
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // 検索ボタンの処理を記述
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'レシピ種別',
            textAlign: TextAlign.left,
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
          Expanded(
            child: YourRecipeListWidget(
              selectedCategory: selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}

class YourRecipeListWidget extends StatelessWidget {
  final String selectedCategory;

  const YourRecipeListWidget({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return ref.watch(getRecipesProvider).when(
              data: (recipes) {
                return ref.watch(getLatestRecipeProvider).when(
                      data: (data) {
                        if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.recipesCollection}.documents.*.create',
                        )) {
                          final recipeId =
                              _extractRecipeIdFromEvent(data.events[0]);

                          var recipe = recipes
                              .firstWhere((element) => element.id == recipeId);
                          final recipeIndex = recipes.indexOf(recipe);
                          recipes
                              .removeWhere((element) => element.id == recipeId);

                          recipe = Recipe.fromMap(data.payload);
                          recipes.insert(recipeIndex, recipe);
                        } else if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.recipesCollection}.documents.*.update',
                        )) {
                          final recipeId =
                              _extractRecipeIdFromEvent(data.events[0]);
                          var recipe = recipes
                              .firstWhere((element) => element.id == recipeId);
                          final recipeIndex = recipes.indexOf(recipe);
                          recipes
                              .removeWhere((element) => element.id == recipeId);

                          recipe = Recipe.fromMap(data.payload);
                          recipes.insert(recipeIndex, recipe);
                        }

                        return ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final recipe = recipes[index];
                            return RecipeCard(recipe: recipe);
                          },
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () {
                        return ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final recipe = recipes[index];
                            return RecipeCard(recipe: recipe);
                          },
                        );
                      },
                    );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
      },
    );
  }

  String _extractRecipeIdFromEvent(String event) {
    final startingPoint = event.lastIndexOf('documents.');
    final endPoint = event.lastIndexOf('.create');
    return event.substring(startingPoint + 10, endPoint);
  }
}
