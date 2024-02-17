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
      // if 30 mins passed then we will fetch from the remote DB
      bool updated = await AppPreferences.isLocalUpdated();
      // the app is up to date with the remote DB, so no need to fetch again
      if (updated) {
        print("Still less than 30 mins");
        final List<PropertyModel> list =
            await propertyLocalSource.getProperties();
        return right(list);

        // 30 MINUTES passed, then fetch data again
      } else {
        final List<PropertyModel> models =
            await propertyRemoteSource.getProperties();
        await propertyLocalSource.addProperties(models);
        print("GOT THE DATA");
        await AppPreferences.updateAppStatus();
        return right(models);
      }
    } on FirebaseException catch (err) {
      return left(ServerFailure(msg: err.message!));
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
  Future<Either<Failure, void>> updateProperty(PropertyModel property) async {
    try {
      //Update local and remote DB for consistency
      await propertyRemoteSource.updateProperty(property);
      await propertyLocalSource.updateProperty(property);
      // AppPreferences.updateAppStatus();
      return Right("");
    } on FirebaseException catch (err) {
      return Left(ServerFailure(msg: err.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProperty(PropertyModel property) async {
    try {
      final PropertyModel model =
          await propertyRemoteSource.createProperty(property);
      print(" the new assigned id is ${model.id}");
      await propertyLocalSource.addProperty(model);
      // AppPreferences.updateAppStatus(true, DateTime.now());
      return Right("");
    } on FirebaseException catch (err) {
      return Left(ServerFailure(msg: err.message.toString()));
    }
  }
}
