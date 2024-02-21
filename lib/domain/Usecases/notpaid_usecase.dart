import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SetNotPaidUsecase implements UseCase<void, List<SetNotPaidParams>> {
  final PropertyRepository propertyRepository;

  SetNotPaidUsecase({required this.propertyRepository});

  @override
  Future<Either<Failure, void>> call(List<SetNotPaidParams> params) =>
      propertyRepository.setNotPaid(params);
}

class SetNotPaidParams extends Equatable {
  final List<int> notPaidIndices;
  final PropertyModel model;

  SetNotPaidParams({required this.notPaidIndices, required this.model});

  @override
  List<Object?> get props => [notPaidIndices, model];
}
