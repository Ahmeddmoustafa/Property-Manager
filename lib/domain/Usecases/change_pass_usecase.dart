import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/confirm_pass_usecase.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository authRepository;

  ChangePasswordUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) =>
      authRepository.changePassword(params);
}
