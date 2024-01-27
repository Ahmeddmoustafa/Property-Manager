import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetProperties implements UseCase<List<PropertyModel>, NoParams> {
  final PropertyRepository propertyRepository;

  GetProperties({required this.propertyRepository});

  @override
  Future<Either<Failure, List<PropertyModel>>> call(NoParams params) =>
      propertyRepository.getProperties();
}
