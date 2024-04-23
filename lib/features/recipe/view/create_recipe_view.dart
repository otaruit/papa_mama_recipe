import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/constants/ui_constants.dart';
import 'package:papa_mama_recipe/features/recipe/controller/recipe_controller.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  static route(Recipe recipe) => MaterialPageRoute(
        builder: (context) => CreateRecipeScreen(
          initialRecipe: recipe,
        ),
      );
  final Recipe? initialRecipe;

  CreateRecipeScreen({Key? key, this.initialRecipe}) : super(key: key);

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  late TextEditingController recipeNameController;
  late TextEditingController ingredientsController;
  final List<String> ingredientsList = List.empty();
  late TextEditingController seasoningController;
  late TextEditingController memoController;
  late int recipeType;
  bool isAtLeastOneSelected = false;

  late List<bool> _selections;


  void _selectButton(int index) {
    // ボタンが選択されたときに他のボタンの選択状態をリセット
    setState(() {
      for (int i = 0; i < _selections.length; i++) {
        _selections[i] = (i == index); // インデックスが選択されたボタンの場合にtrueにする
      }
    });
  }


  @override
  void initState() {
    super.initState();
    recipeNameController =
        TextEditingController(text: widget.initialRecipe?.recipeName ?? '');
    ingredientsController = TextEditingController(text: '');
    seasoningController =
        TextEditingController(text: widget.initialRecipe?.seasoning ?? '');
    memoController =
        TextEditingController(text: widget.initialRecipe?.memo ?? '');

    _selections = [false, false, false, false];
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    ingredientsController.dispose();
    seasoningController.dispose();
    memoController.dispose();
    super.dispose();
  }

  void shareRecipe() {
    final recipeName =
        recipeNameController.text.isNotEmpty ? recipeNameController.text : '0';
    final ingredients = ingredientsList;
    final seasoning =
        seasoningController.text.isNotEmpty ? seasoningController.text : '0';
    final memo = memoController.text.isNotEmpty ? memoController.text : '0';

    final recipeEntry = Recipe(
      id: widget.initialRecipe?.id ?? '',
      uid: widget.initialRecipe?.uid ?? '',
      recipeName: recipeName,
      ingredients: ingredients,
      seasoning: seasoning,
      memo: memo,
      recipeType: recipeType,
    );

    ref
        .read(recipeControllerProvider.notifier)
        .shareRecipe(recipe: recipeEntry, context: context);
    Navigator.pop(context);
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
            icon: Icon(Icons.close, size: 30),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'レシピ名',
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: recipeNameController,
                    ),
                    Text(
                      'レシピ種別',
                      textAlign: TextAlign.left,
                    ),
                    ToggleButtons(
                      children: [
                        Text('Button 1'),
                        Text('Button 2'),
                        Text('Button 3'),
                        Text('Button 4'),
                      ],
                      isSelected: _selections,
                      onPressed: (int index) {
                        _selectButton(index);
                      },
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      borderColor: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                      borderWidth: 2,
                      selectedBorderColor: Colors.blue,
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
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '調味料',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: seasoningController,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: null,
                      child: Text('投稿する'),
                    ),
                  ])),
        ));
  }
}
