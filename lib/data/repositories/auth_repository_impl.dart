import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/remote/auth_remote_source.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/login_usercase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, void>> login(LoginParams params) async {
    try {
      final AuthRemoteSource remoteDataSource = AuthRemoteSource();
      await remoteDataSource.login(params.email, params.password);
      return Right("");
    } on FirebaseException catch (err) {
      return Left(ServerFailure(msg: err.message!));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      final AuthRemoteSource remoteSource = AuthRemoteSource();
      await remoteSource.logout();
      return Right("");
    } on FirebaseException catch (err) {
      return Left(ServerFailure(msg: err.message!));
    }
  }
}
