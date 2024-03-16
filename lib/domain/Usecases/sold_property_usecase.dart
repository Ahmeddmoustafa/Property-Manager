import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class SoldPropertyUsecase implements UseCase<void, PropertyModel> {
  final PropertyRepository propertyRepository;

  SoldPropertyUsecase({required this.propertyRepository});

  @override
  Future<Either<Failure, void>> call(PropertyModel property) =>
      propertyRepository.soldProperty(property);
}
