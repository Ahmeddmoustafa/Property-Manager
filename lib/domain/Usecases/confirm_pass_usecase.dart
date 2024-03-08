import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ConfirmCurrentPasswordUseCase
    implements UseCase<void, ChangePasswordParams> {
  final AuthRepository authRepository;

  ConfirmCurrentPasswordUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) =>
      authRepository.confirmCurrentPassword(params);
}

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({required this.oldPassword, required this.newPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
