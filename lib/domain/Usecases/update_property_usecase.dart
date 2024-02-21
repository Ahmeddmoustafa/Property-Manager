import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdatePropertyUsecase implements UseCase<void, UpdatePropertyParams> {
  final PropertyRepository propertyRepository;

  UpdatePropertyUsecase({required this.propertyRepository});

  @override
  Future<Either<Failure, void>> call(UpdatePropertyParams property) =>
      propertyRepository.updateProperty(property);
}

class UpdatePropertyParams extends Equatable {
  final List<int> updatedIndices;
  final PropertyModel model;

  UpdatePropertyParams({required this.updatedIndices, required this.model});

  @override
  List<Object?> get props => [updatedIndices, model];
}
