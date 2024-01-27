import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUsecase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      authRepository.logout();
}
