import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/features/recipe/controller/recipe_controller.dart';
import 'package:papa_mama_recipe/features/recipe/widget/recipe_card.dart';

class YourRecipeListWidget extends StatelessWidget {
  final String selectedCategory;

  const YourRecipeListWidget({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return ref.watch(watchRecipesRealtimeProvider).when(
              data: (recipes) {
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
              loading: () => const Loader(),
            );
      },
    );
  }
}
