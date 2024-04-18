import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/core/day_of_the_week_get.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';
import 'package:papa_mama_recipe/theme/pallete.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  Widget _buildItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 55,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              // Use Expanded instead of Flexible to fill remaining space
              child: Text(
                value,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(height: 8), // Spacing between label and value
        Container(
          height: 1,
          color: Colors.yellow, // Color of the underline
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            // Navigator.push(context, CreateRecipeScreen.route(recipe));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Pallete.blueColor,
                    ),
                    child: Center(
                      child: Text(
                        'メイン',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    recipe.recipeName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8), // Spacing between recipeName and ingredients
              _buildItem(label: '材料', value: _getFirstIngredient()),
              SizedBox(height: 8), // Spacing between ingredients and seasoning
              _buildItem(label: '調味料', value: recipe.seasoning ?? ''),
            ],
          ),
        ));
  }

  String _getFirstIngredient() {
    if (recipe.ingredients.isNotEmpty) {
      return recipe.ingredients[0];
    }
    return ''; // Return empty string if ingredients list is empty
  }
}
