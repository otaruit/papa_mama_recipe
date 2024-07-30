import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:papa_mama_recipe/constants/appwrite_constants.dart';
import 'package:papa_mama_recipe/core/failure.dart';
import 'package:papa_mama_recipe/core/providers.dart';
import 'package:papa_mama_recipe/core/type_defs.dart';
import 'package:papa_mama_recipe/models/recipe_model.dart';

final recipeAPIProvider = Provider((ref) {
  return RecipeAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IRecipeAPI {
  FutureEither<Document> shareRecipe(Recipe recipe);
  Future<List<Document>> getRecipes();
  // Stream<List<Document>> watchRecipesRealtime();
  Stream<RealtimeMessage> getLatestRecipes();
  Future<List<Document>> searchRecipes(String recipeName, int recipeType);
}

class RecipeAPI implements IRecipeAPI {
  final Databases _db;
  final Realtime _realtime;
  RecipeAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareRecipe(Recipe recipe) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.recipesCollection,
        documentId: recipe.id,
        data: recipe.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getRecipes() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.recipesCollection,
      queries: [
        // Query.orderAsc('dayOfTheWeek'),
        // Query.between('dayOfTheWeek', 0, 6)
      ],
    );
    return documents.documents;
  }

  // @override
  // Stream<List<Document>> watchRecipesRealtime() {
  //   final channel =
  //       _realtime.subscribe(['database.your_database_id.collections.recipes']);

  //   return channel.stream.map<List<Document>>((message) {
  //     final List<Document> documents =
  //         (message as RealtimeMessage).payload as List<Document>;
  //     return documents;
  //   });
  // }

  @override
  Stream<RealtimeMessage> getLatestRecipes() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.recipesCollection}.documents'
    ]).stream;
  }

  @override
  Future<List<Document>> searchRecipes(
      String recipeName, int recipeType) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.recipesCollection,
      queries: [
        Query.search('recipeName', recipeName),
        Query.equal('recipeType', recipeType)
      ],
    );
    return documents.documents;
  }
}
