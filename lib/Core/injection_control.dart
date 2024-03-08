import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/cubit/auth/login_cubit.dart';
import 'package:admin/cubit/change_password/change_password_cubit.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/data/local/property_local_source.dart';
import 'package:admin/data/remote/auth_remote_source.dart';
import 'package:admin/data/remote/property_remote_source.dart';
import 'package:admin/data/repositories/auth_repository_impl.dart';
import 'package:admin/data/repositories/property_repository_impl.dart';
import 'package:admin/domain/Repositories/auth_repository.dart';
import 'package:admin/domain/Repositories/property_repository.dart';
import 'package:admin/domain/Usecases/change_pass_usecase.dart';
import 'package:admin/domain/Usecases/confirm_pass_usecase.dart';
import 'package:admin/domain/Usecases/create_property_usecase.dart';
import 'package:admin/domain/Usecases/login_usercase.dart';
import 'package:admin/domain/Usecases/logout_usecase.dart';
import 'package:admin/domain/Usecases/notpaid_usecase.dart';
import 'package:admin/domain/Usecases/token_usecase.dart';
import 'package:admin/domain/Usecases/update_property_usecase.dart';
import 'package:admin/domain/Usecases/property_usecase.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
//   // **************** EXTERNAL PACKAGES ************************//
//   final hive = await Hive.openBox<BookModel>("Book");
//   sl.registerLazySingleton<Box>(() => hive);

//   final sharedprefs = await SharedPreferences.getInstance();
//   sl.registerLazySingleton<SharedPreferences>(() => sharedprefs);

//   sl.registerLazySingleton<http.Client>(() => http.Client());

//   // *************************** CORES **************************//

//   sl.registerLazySingleton<InternetConnectionChecker>(
//     () => InternetConnectionChecker(),
//   );

//   //********************************************************* */

  sl.registerLazySingleton<PropertyLocalSource>(
    () => PropertyLocalSource(),
  );
  sl.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSource(),
  );
  sl.registerLazySingleton<PropertyRemoteSource>(
    () => PropertyRemoteSource(),
  );

//   sl.registerLazySingleton<BookRemoteDataSource>(
//     () => BookRemoteDataSourceImpl(
//       client: sl(),
//     ),
//   );

//   sl.registerLazySingleton<NetworkInfo>(
//     () => NetworkInfoImpl(
//       internetConnectionChecker: sl(),
//     ),
//   );

  sl.registerLazySingleton<PropertyRepository>(
    () => PropertyRepositoryImpl(
        propertyLocalSource: sl(), propertyRemoteSource: sl()),
  );
  //AUTH DEPENDENCIES
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  sl.registerLazySingleton<GetProperties>(
    () => GetProperties(
      propertyRepository: sl(),
    ),
  );
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<ConfirmCurrentPasswordUseCase>(
    () => ConfirmCurrentPasswordUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<TokenUsecase>(
    () => TokenUsecase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<CreatePropertyUsecase>(
    () => CreatePropertyUsecase(
      propertyRepository: sl(),
    ),
  );
  sl.registerLazySingleton<UpdatePropertyUsecase>(
    () => UpdatePropertyUsecase(
      propertyRepository: sl(),
    ),
  );
  sl.registerLazySingleton<SetNotPaidUsecase>(
    () => SetNotPaidUsecase(
      propertyRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => PropertyCubit(
      getProperties: sl(),
      setNotPaidUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => ChangePasswordCubit(
      changePasswordUseCase: sl(),
      confirmCurrentPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => LoginCubit(
      tokenUsecase: sl(),
      loginUsecase: sl(),
      logoutUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => AddPropertyCubit(
      createPropertyUsecase: sl(),
    ),
  );
  sl.registerFactory(() => PropertyModalCubit(
        updatePropertyUsecase: sl(),
      ));

//   //final sharedprefs = await SharedPreferences.getInstance();
//   // final bookRepo = BookRepositoryImpl(
//   //   bookLocalDataSourceImpl: BookLocalDataSourceImpl(prefs: sharedprefs),
//   //   bookRemoteDataSourceImpl: BookRemoteDataSourceImpl(client: http.Client()),
//   //   networkInfo:
//   //       NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker()),
//   // );

//   // final getBook = GetBook(bookRepository: bookRepo);

//   // final cubit = BookCubit(appBooks: getBook);

//   // return cubit;
}
