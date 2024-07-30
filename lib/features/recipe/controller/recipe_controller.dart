import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/api/recipe_api.dart';
import 'package:papa_mama_recipe/core/utils.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

final recipeControllerProvider = StateNotifierProvider<RecipeController, bool>(
  (ref) {
    return RecipeController(
      ref: ref,
      recipeAPI: ref.watch(recipeAPIProvider),
    );
  },
);

final getRecipesProvider = FutureProvider((ref) {
  final recipeController = ref.watch(recipeControllerProvider.notifier);
  return recipeController.getRecipes();
});

final getLatestRecipesProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(recipeAPIProvider);
  return tweetAPI.getLatestRecipes();
});

final searchRecipesProvider =
    FutureProvider.family<List<Recipe>, SearchType<String, int>>(
  (ref, searchType) async {
    final recipeName = searchType.recipeName;
    final recipeType = searchType.recipeType;
    final recipeController = ref.watch(recipeControllerProvider.notifier);
    final recipes =
        await recipeController.searchRecipes(recipeName, recipeType);
    return recipes;
  },
);

class SearchType<String, int> {
  late final String recipeName;
  late final int recipeType;

  SearchType(String searchWord, int recipeType);
}

// final watchRecipesRealtimeProvider = StreamProvider((ref) {
//   final recipeAPI = ref.watch(recipeAPIProvider);
//   return recipeAPI.watchRecipesRealtime();
// });

class RecipeController extends StateNotifier<bool> {
  final RecipeAPI _recipeAPI;
  final Ref _ref;
  RecipeController({
    required Ref ref,
    required RecipeAPI recipeAPI,
  })  : _ref = ref,
        _recipeAPI = recipeAPI,
        super(false);

  // Stream<List<Document>> watchRecipesRealtime() {
  //   return _recipeAPI.watchRecipesRealtime();
  // }

  Future<List<Recipe>> getRecipes() async {
    final recipeList = await _recipeAPI.getRecipes();
    return recipeList.map((recipe) => Recipe.fromMap(recipe.data)).toList();
  }

  void shareRecipe({
    required Recipe recipe,
    required BuildContext context,
  }) async {
    state = true;
    Recipe recipeEntry = recipe.copyWith();
    final res = await _recipeAPI.shareRecipe(recipeEntry);
    res.fold((l) => showSnackBar(context, l.message), (r) {});
    state = false;
  }

  Future<List<Recipe>> searchRecipes(String recipeName, int recipeType) async {
    final recipes = await _recipeAPI.searchRecipes(recipeName, recipeType);
    return recipes.map((e) => Recipe.fromMap(e.data)).toList();
  }
}
