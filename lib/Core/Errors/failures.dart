import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  final String msg;

  ServerFailure({required this.msg});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CachFailure extends Failure {
  @override
  List<Object?> get props => throw UnimplementedError();
}
