import 'package:fpdart/fpdart.dart';
import 'package:papa_mama_recipe/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
