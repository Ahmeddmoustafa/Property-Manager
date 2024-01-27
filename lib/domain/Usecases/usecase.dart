import 'package:admin/Core/Errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<type, params> {
  Future<Either<Failure, type>>? call(params params) {
    return null;
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}
