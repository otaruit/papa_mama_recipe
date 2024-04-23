import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/constants/appwrite_constants.dart';
import 'package:papa_mama_recipe/constants/ui_constants.dart';
import 'package:papa_mama_recipe/features/recipe/controller/recipe_controller.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_card.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

class RecipeList extends ConsumerWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = TextEditingController();

    String _extractRecipeIdFromEvent(String event) {
      final startingPoint = event.lastIndexOf('documents.');
      final endPoint = event.lastIndexOf('.create');
      return event.substring(startingPoint + 10, endPoint);
    }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                CustomButton(
                  label: 'メイン',
                  color: Colors.blue,
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                CustomButton(
                  label: 'サイド',
                  color: Colors.red,
                  onPressed: () {
                    // Handle 'メイン' button press
                  },
                ),
                SizedBox(width: 8),
                CustomButton(
                  label: 'スープ',
                  color: Colors.green,
                  onPressed: () {
                    // Handle 'メイン' button press
                  },
                ),
                SizedBox(width: 8),
                CustomButton(
                  label: 'その他',
                  color: Colors.yellow,
                  onPressed: () {
                    // Handle 'メイン' button press
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ref.watch(getRecipesProvider).when(
                  data: (recipes) {
                    return ref.watch(getLatestRecipeProvider).when(
                          data: (data) {
                            if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.recipesCollection}.documents.*.create',
                            )) {
                              final recipeId =
                                  _extractRecipeIdFromEvent(data.events[0]);

                              var recipe = recipes.firstWhere(
                                  (element) => element.id == recipeId);
                              final recipeIndex = recipes.indexOf(recipe);
                              recipes.removeWhere(
                                  (element) => element.id == recipeId);

                              recipe = Recipe.fromMap(data.payload);
                              recipes.insert(recipeIndex, recipe);
                            } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.recipesCollection}.documents.*.update',
                            )) {
                              final recipeId =
                                  _extractRecipeIdFromEvent(data.events[0]);
                              var recipe = recipes.firstWhere(
                                  (element) => element.id == recipeId);
                              final recipeIndex = recipes.indexOf(recipe);
                              recipes.removeWhere(
                                  (element) => element.id == recipeId);

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
                ),
          )
        ],
      ),
    );
  }


}
