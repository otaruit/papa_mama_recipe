import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/constants/appwrite_constants.dart';
import 'package:papa_mama_recipe/features/recipe/controller/recipe_controller.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_card.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

class StreamRecipeList extends ConsumerStatefulWidget {
  final int recipeType;
  final String searchWord;
  StreamRecipeList(
      {Key? key, required this.recipeType, required this.searchWord})
      : super(key: key);

  @override
  _StreamRecipeListState createState() => _StreamRecipeListState();
}

class _StreamRecipeListState extends ConsumerState<StreamRecipeList> {
  @override
  Widget build(BuildContext context) {
    final searchType = SearchType(widget.searchWord, widget.recipeType);

    return ref.watch(getRecipesProvider).when(
        data: (recipes) {
 
          return ref.watch(getLatestRecipesProvider).when(
                data: (data) {
                  if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.recipesCollection}.documents.*.create',
                  )) {
                    recipes.insert(0, Recipe.fromMap(data.payload));
                  } else if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.recipesCollection}.documents.*.update',
                  )) {
                    // get id of original recipe
                    final startingPoint =
                        data.events[0].lastIndexOf('documents.');
                    final endPoint = data.events[0].lastIndexOf('.update');
                    final recipeId =
                        data.events[0].substring(startingPoint + 10, endPoint);

                    var recipe = recipes
                        .where((element) => element.id == recipeId)
                        .first;

                    final recipeIndex = recipes.indexOf(recipe);
                    recipes.removeWhere((element) => element.id == recipeId);

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
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
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
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader()
        );
  }
}
