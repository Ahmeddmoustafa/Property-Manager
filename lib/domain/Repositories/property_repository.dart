import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/notpaid_usecase.dart';
import 'package:admin/domain/Usecases/update_property_usecase.dart';
import 'package:dartz/dartz.dart';

abstract class PropertyRepository {
  Future<Either<Failure, List<PropertyModel>>> getProperties();
  Future<Either<Failure, void>> setNotPaid(SetNotPaidParams params);
  Future<Either<Failure, void>> updateProperty(UpdatePropertyParams property);
  Future<Either<Failure, void>> createProperty(PropertyModel property);
}
