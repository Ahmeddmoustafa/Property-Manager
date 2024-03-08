import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String msg;

  Failure({required this.msg});
}

class ServerFailure extends Failure {
  final String msg;

  ServerFailure({required this.msg}) : super(msg: '');
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CachFailure extends Failure {
  CachFailure({required super.msg});

  @override
  List<Object?> get props => throw UnimplementedError();
}
