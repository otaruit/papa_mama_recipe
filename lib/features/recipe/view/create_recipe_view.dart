// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:papa_mama_recipe/common/loading_page.dart';
// import 'package:papa_mama_recipe/core/day_of_the_week_get.dart';
// import 'package:papa_mama_recipe/models/recipe_model.dart';

// class CreateRecipeScreen extends ConsumerStatefulWidget {
//   static route(Recipe recipe) => MaterialPageRoute(
//         builder: (context) => CreateRecipeScreen(
//           initialRecipe: recipe,
//         ),
//       );
//   final Recipe? initialRecipe;

//   CreateRecipeScreen({Key? key, this.initialRecipe}) : super(key: key);

//   @override
//   _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
// }

// class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
//   late TextEditingController mainRecipeController;
//   late TextEditingController sideRecipeController;
//   late TextEditingController soupController;
//   late TextEditingController othersController;
//   bool isAtLeastOneSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     mainRecipeController =
//         TextEditingController(text: widget.initialRecipe?.mainDish ?? '');
//     sideRecipeController =
//         TextEditingController(text: widget.initialRecipe?.sideDish ?? '');
//     soupController =
//         TextEditingController(text: widget.initialRecipe?.soup ?? '');
//     othersController =
//         TextEditingController(text: widget.initialRecipe?.others ?? '');
//   }

//   @override
//   void dispose() {
//     mainRecipeController.dispose();
//     sideRecipeController.dispose();
//     soupController.dispose();
//     othersController.dispose();
//     super.dispose();
//   }

//   void shareRecipe() {
//     final mainRecipe =
//         mainRecipeController.text.isNotEmpty ? mainRecipeController.text : '0';
//     final sideRecipe =
//         sideRecipeController.text.isNotEmpty ? sideRecipeController.text : '0';
//     final soup = soupController.text.isNotEmpty ? soupController.text : '0';
//     final others =
//         othersController.text.isNotEmpty ? othersController.text : '0';

//     final recipeEntry = Recipe(
//       id: widget.initialRecipe?.id ?? '',
//       dayOfTheWeek: widget.initialRecipe?.dayOfTheWeek ?? 0,
//       mainDish: mainRecipe,
//       sideDish: sideRecipe,
//       soup: soup,
//       others: others,
//       uid: widget.initialRecipe?.uid ?? '',
//     );

//     ref
//         .read(recipeControllerProvider.notifier)
//         .shareRecipe(recipe: recipeEntry, context: context);
//     Navigator.pop(context);
//   }

//   bool areDropdownsEmpty() {
//     return mainRecipeController.text.isEmpty &&
//         sideRecipeController.text.isEmpty &&
//         soupController.text.isEmpty &&
//         othersController.text.isEmpty;
//   }

//   Widget _buildDropdownSet(String label, TextEditingController controller) {
//     List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
//     String? selectedValue = controller.text.isNotEmpty ? controller.text : null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//             value: controller.text.isEmpty ? null : controller.text,
//             items: [controller.text, 'Option 2', 'Option 3']
//                 .map((String value) => DropdownRecipeItem<String>(
//                       value: value,
//                       child: Text(value),
//                     ))
//                 .toList(),
//             onChanged: (String? value) {
//               setState(() {
//                 controller.text = value ?? '';
//                 isAtLeastOneSelected = true;
//               });
//             },
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               isDense: true,
//             ),
//             validator: (value) {
//               if (dropdownItems.contains(value)) {
//                 return null;
//               } else {
//                 return '選択した値は無効です';
//               }
//             })
//       ],
//     );
//   }

//   Widget _buildRegistrationButton() {
//     return ElevatedButton(
//       onPressed: isAtLeastOneSelected ? shareRecipe : null,
//       child: Text('登録'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(recipeControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.initialRecipe != null
//             ? VariableTransFormation.getDayOfTheWeek(
//                 widget.initialRecipe!.dayOfTheWeek)
//             : '新規作成'),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.close, size: 30),
//         ),
//         actions: [
//           IconButton(
//             onPressed: null,
//             icon: Icon(Icons.delete_outline_outlined),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Loader()
//           : SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildDropdownSet('メイン', mainRecipeController),
//                     SizedBox(height: 16),
//                     _buildDropdownSet('サイド', sideRecipeController),
//                     SizedBox(height: 16),
//                     _buildDropdownSet('汁物', soupController),
//                     SizedBox(height: 16),
//                     _buildDropdownSet('その他', othersController),
//                     SizedBox(height: 16),
//                     _buildRegistrationButton(), // 登録ボタンを追加
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ProviderScope(
//       child: CreateRecipeScreen(),
//     ),
//   ));
// }
