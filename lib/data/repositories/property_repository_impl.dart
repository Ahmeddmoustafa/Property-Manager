import 'package:admin/Core/Errors/failures.dart';
import 'package:admin/data/local/app_preferences.dart';
import 'package:admin/data/local/property_local_source.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/data/remote/property_remote_source.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/notpaid_usecase.dart';
import 'package:admin/domain/Usecases/update_property_usecase.dart';
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
      // bool updated = await AppPreferences.isLocalUpdated();
      // the app is up to date with the remote DB, so no need to fetch again
      // if (false) {
      //   print("Still less than 30 mins");
      //   final List<PropertyModel> list =
      //       await propertyLocalSource.getProperties();
      //   return right(list);

      //   // 30 MINUTES passed, then fetch data again
      // } else {
      final List<PropertyModel> models =
          await propertyRemoteSource.getProperties();
      await propertyLocalSource.addProperties(models);
      print("GOT THE DATA");
      await AppPreferences.updateAppStatus();
      return right(models);
      // }
    } catch (err) {
      print(err.toString());
      return left(ServerFailure(msg: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setNotPaid(SetNotPaidParams params) async {
    try {
      //Update local and remote DB for consistency
      // params.forEach((param) async {
      // });
      await propertyRemoteSource.setPropertyNotPaid(params);
      // await propertyLocalSource.updateProperties(params);
      // AppPreferences.updateAppStatus();
      return Right("");
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProperty(
      UpdatePropertyParams params) async {
    try {
      print("repo called");
      //Update local and remote DB for consistency
      await propertyRemoteSource.updateProperty(params);
      await propertyLocalSource.updateProperty(params.model);
      return Right("");
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProperty(PropertyModel property) async {
    try {
      final PropertyModel model =
          await propertyRemoteSource.createProperty(property);
      await propertyLocalSource.addProperty(model);
      return Right("");
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> soldProperty(PropertyModel property) async {
    try {
      final PropertyModel model =
          await propertyRemoteSource.soldProperty(property);
      // await propertyLocalSource.addProperty(model);
      return Right("");
    } catch (err) {
      return Left(ServerFailure(msg: err.toString()));
    }
  }
}
