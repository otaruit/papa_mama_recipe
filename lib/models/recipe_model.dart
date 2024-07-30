import 'package:flutter/foundation.dart';

@immutable
class Recipe {
  final String id;
  final String recipeName;
  final List<String> ingredients;
  final String seasoning;
  final String memo;
  final String uid;
  final int recipeType;
  Recipe({
    required this.id,
    required this.recipeName,
    required this.ingredients,
    required this.seasoning,
    required this.memo,
    required this.uid,
    required this.recipeType,
  });

  Recipe copyWith({
    String? id,
    String? recipeName,
    List<String>? ingredients,
    String? seasoning,
    String? memo,
    String? uid,
    int? recipeType,
  }) {
    return Recipe(
      id: id ?? this.id,
      recipeName: recipeName ?? this.recipeName,
      ingredients: ingredients ?? this.ingredients,
      seasoning: seasoning ?? this.seasoning,
      memo: memo ?? this.memo,
      uid: uid ?? this.uid,
      recipeType: recipeType ?? this.recipeType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recipeName': recipeName,
      'ingredients': ingredients,
      'seasoning': seasoning,
      'memo': memo,
      'uid': uid,
      'recipeType': recipeType,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['\$id'] ?? '',
      recipeName: map['recipeName'] ?? '',
      ingredients: List<String>.from((map['ingredients'])),
      seasoning: map['seasoning'] ?? '',
      memo: map['memo'] ?? '',
      uid: map['uid'] ?? '',
      recipeType: map['recipeType'].toInt() ?? 0,
    );
  }
}
