import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/local/app_preferences.dart';
import 'package:admin/data/local/property_local_source.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/data/remote/property_remote_source.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyLocalSource propertyLocalSource;
  final PropertyRemoteSource propertyRemoteSource;

  PropertyRepositoryImpl({
    required this.propertyRemoteSource,
    required this.propertyLocalSource,
  });

  @override
  Future<Either<Failure, List<PropertyModel>>> getProperties() async {
    // throw UnimplementedError();
    try {
      bool updated = await AppPreferencess.isUpdated();
      // the app is up to date with the remote DB, so no need to fetch again
      if (!updated) {
        final List<PropertyModel> list =
            await propertyLocalSource.getProperties();
        return right(list);

        // remote DB has changed then fetch data again
      } else {
        final List<PropertyModel> models =
            await propertyRemoteSource.getProperties();
        await propertyLocalSource.addProperties(models);
        print("GOT THE DATA");
        await AppPreferencess.updateAppStatus(false, DateTime.now());
        return right(models);
      }
    } catch (err) {
      return left(ServerFailure(msg: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setNotPaid(PropertyModel property) {
    // TODO: implement setNotPaid
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setPaid(PropertyModel property) {
    // TODO: implement setPaid
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> createProperty(PropertyModel property) async {
    try {
      await propertyRemoteSource.createProperty(property);
      AppPreferencess.updateAppStatus(true, DateTime.now());
      return Right("");
    } on FirebaseException catch (err) {
      return Left(ServerFailure(msg: err.message.toString()));
    }
  }
}
