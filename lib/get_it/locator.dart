import 'package:eleven_crm/features/auth/domain/usecases/change_password.dart';
import 'package:eleven_crm/features/main/presensation/cubit/data_form/data_form_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/menu/menu_cubit.dart';
import 'package:eleven_crm/features/management/data/datasources/management_remote_data_source.dart';
import 'package:eleven_crm/features/management/domain/repositories/management_repository.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:http/http.dart';

import '../core/api/api_client.dart';
import '../core/utils/storage_service.dart';
import '../features/auth/data/datasources/authentication_local_data_source.dart';
import '../features/auth/data/datasources/authentication_remote_data_source.dart';
import '../features/auth/data/repositories/authentication_repository_impl.dart';
import '../features/auth/domain/repositories/authentication_repository.dart';
import '../features/auth/domain/usecases/auth.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/logout_user.dart';
import '../features/auth/presentation/cubit/auth/auth_cubit.dart';
import '../features/auth/presentation/cubit/login_cubit.dart';
import '../features/main/data/datasources/main_remote_data_source.dart';
import '../features/main/data/repository/main_repository_impl.dart';
import '../features/main/domain/repository/main_repository.dart';
import 'package:get_it/get_it.dart';

import '../features/main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../features/management/data/repositories/management_repository_impl.dart';
import '../features/management/domain/usecases/customer.dart';

final locator = GetIt.I;

void setup() {
  // ================ BLoC / Cubit ================ //

  locator.registerFactory(() => LoginCubit(
        loginUser: locator(),
        logoutUser: locator(),
        passwordChange: locator(),
      ));
  locator.registerFactory(() => MenuCubit());
  locator.registerFactory(() => TopMenuCubit());
  locator.registerFactory(() => AuthCubit(
        locator(),
      ));

  locator.registerFactory(() => CustomerCubit(getData: locator(), saveData: locator(), deleteData: locator(),
  ));
  locator.registerFactory(() => DataFormCubit(
  ));

  // ================ UseCases ================ //

  // Auth
  locator.registerLazySingleton<LoginUser>(() => LoginUser(locator()));
  locator.registerLazySingleton<LogoutUser>(() => LogoutUser(locator()));
  locator.registerLazySingleton<LogginedUser>(() => LogginedUser(locator()));
  locator
      .registerLazySingleton<ChangePassword>(() => ChangePassword(locator()));

  // Main

  // Management
  locator.registerLazySingleton<GetCustomer>(() => GetCustomer(locator()));
  locator.registerLazySingleton<DeleteCustomer>(() => DeleteCustomer(locator()));
  locator.registerLazySingleton<SaveCustomer>(() => SaveCustomer(locator()));


  // Order

  // Privacy

  // Driver

  // ================ Repository / Datasource ================ //

  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      locator(),
      locator(),
    ),
  );

  locator.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(
      locator(),
    ),
  );
  locator.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(),
  );

  locator.registerLazySingleton<MainRepository>(
    () => MainRepositoryImpl(
      locator(),
    ),
  );

  locator.registerLazySingleton<MainRemoteDataSource>(
    () => MainRemoteDataSourceImpl(
      locator(),
    ),
  );


  // locator.registerLazySingleton<MainLocalDataSource>(
  //   () => MainLocalDataSourceImpl(),
  // );

  locator.registerLazySingleton<ManagementRepository>(
        () => ManagementRepositoryImpl(
      locator(),
    ),
  );

  locator.registerLazySingleton<ManagementRemoteDataSource>(
        () => ManagementRemoteDataSourceImpl(
      locator(),
    ),
  );

  // ================ Core ================ //

  locator.registerLazySingleton<Client>(() => Client());

  locator
      .registerLazySingleton<ApiClient>(() => ApiClient(locator(), locator()));

  locator.registerLazySingleton<StorageService>(() => StorageService());


  // ================ External ================ //

  // locator.registerLazySingleton(() => StorageService());
}
