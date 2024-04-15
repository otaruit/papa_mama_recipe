import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:papa_mama_recipe/constants/appwrite_constants.dart';
import 'package:papa_mama_recipe/core/failure.dart';
import 'package:papa_mama_recipe/core/providers.dart';
import 'package:papa_mama_recipe/core/type_defs.dart';
import 'package:papa_mama_recipe/models/menu_model.dart';

final menuAPIProvider = Provider((ref) {
  return MenuAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IMenuAPI {
  FutureEither<Document> shareMenu(Menu menu);
  Future<List<Document>> getMenus();
  Stream<RealtimeMessage> getLatestMenu();
  Future<Document> getMenuById(String id);
}

class MenuAPI implements IMenuAPI {
  final Databases _db;
  final Realtime _realtime;
  MenuAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareMenu(Menu menu) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.menusCollection,
        documentId: ID.unique(),
        data: menu.toMap(),
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
  Future<List<Document>> getMenus() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.menusCollection,
      // queries: [
      //   Query.orderDesc('menuedAt'),
      // ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestMenu() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.menusCollection}.documents'
    ]).stream;
  }
  
  @override
  Future<Document> getMenuById(String id) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.menusCollection,
      documentId: id,
    );
  }


  
}
