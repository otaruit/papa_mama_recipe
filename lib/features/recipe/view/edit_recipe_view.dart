import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/features/recipe/controller/recipe_controller.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  static Route route(Recipe? recipe) {
    return MaterialPageRoute(
      builder: (context) => CreateRecipeScreen(
        initialRecipe: recipe,
      ),
    );
  }

  final Recipe? initialRecipe;

  CreateRecipeScreen({Key? key, this.initialRecipe}) : super(key: key);

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  late TextEditingController recipeNameController;
  late TextEditingController seasoningController;
  late TextEditingController ingredientController;
  late int recipeType = 0;
  List<String> ingredients = []; // 材料のリスト

  @override
  void initState() {
    super.initState();
    recipeNameController =
        TextEditingController(text: widget.initialRecipe?.recipeName ?? '');
    seasoningController =
        TextEditingController(text: widget.initialRecipe?.seasoning ?? '');
    ingredientController = TextEditingController(text: '');
    if (widget.initialRecipe != null) {
      recipeType = widget.initialRecipe!.recipeType;
      ingredients.addAll(widget.initialRecipe!.ingredients);
    }
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    seasoningController.dispose();
    ingredientController.dispose();
    super.dispose();
  }

  void addIngredient() {
    if (ingredientController.text.isNotEmpty) {
      setState(() {
        ingredients.add(ingredientController.text);
        ingredientController.clear();
      });
    }
  }

  void removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void shareRecipe() {
    final recipeName =
        recipeNameController.text.isNotEmpty ? recipeNameController.text : '';
    final seasoning =
        seasoningController.text.isNotEmpty ? seasoningController.text : '';

    final recipeEntry = Recipe(
      id: widget.initialRecipe?.id ?? '',
      uid: widget.initialRecipe?.uid ?? '',
      ingredients: ingredients,
      recipeName: recipeName,
      seasoning: seasoning,
      recipeType: recipeType,
      memo: '',
    );

    ref
        .read(recipeControllerProvider.notifier)
        .shareRecipe(recipe: recipeEntry, context: context);
    Navigator.pop(context);
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
        title: Text(widget.initialRecipe != null ? 'レシピ編集' : 'レシピ作成'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'レシピ名',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: recipeNameController,
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              const Text(
                '材料',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16.0),
              // 材料のリストを表示
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...ingredients.asMap().entries.map((entry) {
                    final index = entry.key;
                    final ingredient = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => removeIngredient(index),
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ingredientController,
                          decoration: InputDecoration(
                            labelText: '材料を追加',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: addIngredient,
                        child: const Text('登録'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                '調味料',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: seasoningController,
                maxLines: 4, // 複数行入力可能にする
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: shareRecipe,
                child: const Text('投稿する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
