import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/domain/Usecases/confirm_pass_usecase.dart';
import 'package:admin/domain/Usecases/login_usercase.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(LoginParams params);
  Future<Either<Failure, void>> changePassword(ChangePasswordParams params);
  Future<Either<Failure, void>> confirmCurrentPassword(
      ChangePasswordParams params);

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> validateToken();
}
