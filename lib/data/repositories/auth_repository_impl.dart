import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/local/app_preferences.dart';
import 'package:admin/data/remote/auth_remote_source.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/login_usercase.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteDataSource = AuthRemoteSource();

  @override
  Future<Either<Failure, void>> login(LoginParams params) async {
    try {
      final String response =
          await remoteDataSource.login(params.email, params.password);
      AppPreferences.setToken(response);
      print(await AppPreferences.getToken());
      return Right("");
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return Right("");
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken() async {
    try {
      final String token = await AppPreferences.getToken();
      await remoteDataSource.validateToken();
      return Right(true);
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }
}
