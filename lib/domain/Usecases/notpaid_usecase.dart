import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SetNotPaidUsecase implements UseCase<void, SetNotPaidParams> {
  final PropertyRepository propertyRepository;

  SetNotPaidUsecase({required this.propertyRepository});

  @override
  Future<Either<Failure, void>> call(SetNotPaidParams params) =>
      propertyRepository.setNotPaid(params);
}

class SetNotPaidParams extends Equatable {
  late List<Map<String, dynamic>> updatedData;
  late List<PropertyModel> models;

  SetNotPaidParams({
    required this.updatedData,
    required this.models,
  });

  @override
  List<Object?> get props => [
        updatedData,
      ];
}
