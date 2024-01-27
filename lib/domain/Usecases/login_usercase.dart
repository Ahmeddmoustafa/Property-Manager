import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUsecase implements UseCase<void, LoginParams> {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(LoginParams params) =>
      authRepository.login(params);
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
