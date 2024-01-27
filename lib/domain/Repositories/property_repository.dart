import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:dartz/dartz.dart';

abstract class PropertyRepository {
  Future<Either<Failure, List<PropertyModel>>> getProperties();
  Future<Either<Failure, void>> setNotPaid(PropertyModel property);
  Future<Either<Failure, void>> setPaid(PropertyModel property);
  Future<Either<Failure, void>> createProperty(PropertyModel property);
}
