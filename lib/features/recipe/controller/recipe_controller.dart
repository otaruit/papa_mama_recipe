import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/api/recipe_api.dart';
import 'package:papa_mama_recipe/core/utils.dart';
import 'package:papa_mama_recipe/features/auth/controller/auth_controller.dart';
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

final watchRecipesRealtimeProvider = StreamProvider((ref) {
  final recipeAPI = ref.watch(recipeAPIProvider);
  return recipeAPI.watchRecipesRealtime();
});

final getRecipeByIdProvider = FutureProvider.family((ref, String id) async {
  final recipeController = ref.watch(recipeControllerProvider.notifier);
  return recipeController.getRecipeById(id);
});


class RecipeController extends StateNotifier<bool> {
  final RecipeAPI _recipeAPI;
  final Ref _ref;
  RecipeController({
    required Ref ref,
    required RecipeAPI recipeAPI,
  })  : _ref = ref,
        _recipeAPI = recipeAPI,
        super(false);

  Stream<List<Document>> watchRecipesRealtime() {
    return _recipeAPI.watchRecipesRealtime();
  }

  Future<List<Recipe>> searchRecipesByName(String recipeName) async {
    final users = await _recipeAPI.searchRecipesByName(recipeName);
    return users.map((e) => Recipe.fromMap(e.data)).toList();
  }

  Future<List<Recipe>> getRecipes() async {
    final recipeList = await _recipeAPI.getRecipes();
    return recipeList.map((recipe) => Recipe.fromMap(recipe.data)).toList();
  }

  Future<Recipe> getRecipeById(String id) async {
    final recipe = await _recipeAPI.getRecipeById(id);
    return Recipe.fromMap(recipe.data);
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
}
