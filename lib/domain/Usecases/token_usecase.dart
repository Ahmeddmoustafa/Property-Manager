import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class TokenUsecase implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  TokenUsecase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      authRepository.validateToken();
}
