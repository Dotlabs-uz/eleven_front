import 'package:eleven_crm/features/auth/domain/usecases/change_password.dart';
import 'package:eleven_crm/features/main/domain/usecases/current_user.dart';
import 'package:eleven_crm/features/main/domain/usecases/not_working_hours.dart';
import 'package:eleven_crm/features/main/domain/usecases/photo.dart';
import 'package:eleven_crm/features/main/presensation/cubit/data_form/data_form_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/menu/menu_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order/not_working_hours/not_working_hours_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order/order_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/select_services/select_services_cubit.dart';
import 'package:eleven_crm/features/management/data/datasources/management_local_data_source.dart';
import 'package:eleven_crm/features/management/data/datasources/management_remote_data_source.dart';
import 'package:eleven_crm/features/management/domain/repositories/management_repository.dart';
import 'package:eleven_crm/features/management/domain/usecases/barber.dart';
import 'package:eleven_crm/features/management/domain/usecases/employee.dart';
import 'package:eleven_crm/features/management/domain/usecases/employee_schedule.dart';
import 'package:eleven_crm/features/management/domain/usecases/manager.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/employee/employee_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/manager/manager_cubit.dart';
import 'package:eleven_crm/features/management/presentation/provider/cross_in_employee_schedule_provider.dart';
import 'package:eleven_crm/features/products/domain/usecases/filial.dart';
import 'package:eleven_crm/features/products/domain/usecases/service_product_category.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;

import '../core/api/api_client.dart';
import '../core/api/api_client_http.dart';
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

import '../features/main/domain/usecases/order.dart';
import '../features/main/presensation/cubit/avatar/avatar_cubit.dart';
import '../features/main/presensation/cubit/current_user/current_user_cubit.dart';
import '../features/main/presensation/cubit/home_screen_form/home_screen_order_form_cubit.dart';
import '../features/main/presensation/cubit/locale/locale_cubit.dart';
import '../features/main/presensation/cubit/show_client_orders_history/show_client_orders_history_cubit.dart';
import '../features/main/presensation/cubit/show_order_history/show_order_history_cubit.dart';
import '../features/main/presensation/cubit/show_select_services/show_select_services_cubit.dart';
import '../features/main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../features/management/data/repositories/management_repository_impl.dart';
import '../features/management/domain/usecases/customer.dart';
import '../features/management/presentation/cubit/barber/barber_cubit.dart';
import '../features/management/presentation/cubit/employee_schedule/employee_schedule_cubit.dart';
import '../features/products/data/datasources/products_local_data_source.dart';
import '../features/products/data/datasources/products_remote_data_source.dart';
import '../features/products/data/repository/products_repository_impl.dart';
import '../features/products/domain/repository/products_repository.dart';
import '../features/products/domain/usecases/service_product.dart';
import '../features/products/presensation/cubit/filial/filial_cubit.dart';
import '../features/products/presensation/cubit/service_product/service_product_cubit.dart';
import '../features/products/presensation/cubit/service_product_category/service_product_category_cubit.dart';

final locator = GetIt.I;

void setup() {
  // ================ BLoC / Cubit ================ //

  locator.registerFactory(() => LoginCubit(
        loginUser: locator(),
        logoutUser: locator(),
        passwordChange: locator(),
      ));
  locator.registerFactory(() => AvatarCubit(locator()));
  locator.registerFactory(() => LocaleCubit());
  locator.registerFactory(() => MenuCubit());
  locator.registerFactory(() => TopMenuCubit());
  locator.registerFactory(() => DataFormCubit());
  locator.registerFactory(() => AuthCubit(locator()));
  locator.registerFactory(() => CurrentUserCubit(locator(), locator()));

  // Customer

  locator.registerFactory(() => CustomerCubit(
      getData: locator(),
      saveData: locator(),
      deleteData: locator(),
      getCustomerById: locator()));

  // Employee

  locator.registerFactory(() =>
      EmployeeCubit(locator(), locator(), locator(), locator(), locator()));
  locator.registerFactory(() => CrossInEmployeeScheduleProvider());
  locator.registerFactory(() => EmployeeScheduleCubit(
        locator(),
      ));

  // Service Product

  locator.registerFactory(() => ServiceProductCubit(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  // Service Product Category

  locator.registerFactory(
      () => ServiceProductCategoryCubit(locator(), locator(), locator()));

  locator.registerFactory(() => ShowClientOrdersHistoryCubit());
  locator.registerFactory(() => ShowOrderHistoryCubit());
  locator.registerFactory(() => ShowSelectServicesCubit());
  locator.registerFactory(() => SelectServicesCubit());

  // Barber

  locator.registerFactory(() => BarberCubit(locator(), locator(), locator()));

  // Filial

  locator.registerFactory(() => FilialCubit(locator()));

  // Not working hours

  locator.registerFactory(() => NotWorkingHoursCubit(locator()));

  // Manager

  locator.registerFactory(() => ManagerCubit(locator(), locator(), locator()));

  // Order

  locator.registerFactory(() => OrderCubit(
        locator(),
        locator(),
      ));
  locator.registerFactory(() => HomeScreenOrderFormCubit());
  locator.registerFactory(() => OrderFilterCubit());

  // ================ UseCases ================ //

  // Auth
  locator.registerLazySingleton<LoginUser>(() => LoginUser(locator()));
  locator.registerLazySingleton<LogoutUser>(() => LogoutUser(locator()));
  locator.registerLazySingleton<LogginedUser>(() => LogginedUser(locator()));
  locator.registerLazySingleton<SaveAvatar>(() => SaveAvatar(locator()));
  locator
      .registerLazySingleton<ChangePassword>(() => ChangePassword(locator()));

  // Main

  // Customer
  locator
      .registerLazySingleton<GetCustomerById>(() => GetCustomerById(locator()));
  locator.registerLazySingleton<GetCustomer>(() => GetCustomer(locator()));
  locator
      .registerLazySingleton<DeleteCustomer>(() => DeleteCustomer(locator()));
  locator.registerLazySingleton<SaveCustomer>(() => SaveCustomer(locator()));

  // Employee
  locator.registerLazySingleton<GetEmployee>(() => GetEmployee(locator()));
  locator.registerLazySingleton<GetEmployeeEntity>(
      () => GetEmployeeEntity(locator()));
  locator
      .registerLazySingleton<DeleteEmployee>(() => DeleteEmployee(locator()));
  locator.registerLazySingleton<SaveEmployee>(() => SaveEmployee(locator()));
  locator.registerLazySingleton<SaveEmployeeWeeklySchedule>(
      () => SaveEmployeeWeeklySchedule(locator()));

  // Product

  // Service Product
  locator.registerLazySingleton<GetServiceProduct>(
      () => GetServiceProduct(locator()));
  locator.registerLazySingleton<DeleteServiceProduct>(
      () => DeleteServiceProduct(locator()));
  locator.registerLazySingleton<SaveServiceProduct>(
      () => SaveServiceProduct(locator()));
  locator.registerLazySingleton<SaveBarberServiceProducts>(
      () => SaveBarberServiceProducts(locator()));

  // Service Product Category
  locator.registerLazySingleton<GetServiceProductCategory>(
      () => GetServiceProductCategory(locator()));
  locator.registerLazySingleton<DeleteServiceProductCategory>(
      () => DeleteServiceProductCategory(locator()));
  locator.registerLazySingleton<SaveServiceProductCategory>(
      () => SaveServiceProductCategory(locator()));

  // Barber
  locator.registerLazySingleton<GetBarber>(() => GetBarber(locator()));
  locator.registerLazySingleton<SaveBarber>(() => SaveBarber(locator()));
  locator.registerLazySingleton<DeleteBarber>(() => DeleteBarber(locator()));

  // Current user
  locator
      .registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(locator()));

  locator
      .registerLazySingleton<SaveCurrentUser>(() => SaveCurrentUser(locator()));

  // Filial

  locator.registerLazySingleton<GetFilials>(() => GetFilials(locator()));

  // Employee Schedule

  locator.registerLazySingleton<SaveEmployeeSchedule>(
      () => SaveEmployeeSchedule(locator()));

  // Not working hours

  locator.registerLazySingleton<SaveNotWorkingHours>(
      () => SaveNotWorkingHours(locator()));

  // Manager
  locator.registerLazySingleton<GetManager>(() => GetManager(locator()));
  locator.registerLazySingleton<SaveManager>(() => SaveManager(locator()));
  locator.registerLazySingleton<DeleteManager>(() => DeleteManager(locator()));

  // Order
  locator.registerLazySingleton<SaveOrder>(() => SaveOrder(locator()));
  locator.registerLazySingleton<DeleteOrder>(() => DeleteOrder(locator()));

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
      locator(),
    ),
  );

  locator.registerLazySingleton<ManagementRepository>(
    () => ManagementRepositoryImpl(
      locator(),
      locator(),
    ),
  );

  locator.registerLazySingleton<ManagementRemoteDataSource>(
    () => ManagementRemoteDataSourceImpl(
      locator(),
    ),
  );
  locator.registerLazySingleton<ManagementLocalDataSource>(
    () => ManagementLocalDataSourceImpl(),
  );

  locator.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      locator(),
      locator(),
    ),
  );

  locator.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(
      locator(),
    ),
  );

  locator.registerLazySingleton<ProductsLocalDataSource>(
    () => ProductsLocalDataSourceImpl(),
  );

  // ================ Core ================ //

  locator.registerLazySingleton<dio.Dio>(() => dio.Dio());
  locator.registerLazySingleton<Client>(() => Client());

  locator.registerLazySingleton<ApiClient>(
      () => ApiClientImpl(locator(), locator()));

  locator.registerLazySingleton<ApiClientHttp>(
      () => ApiClientHttpImpl(locator(), locator()));

  locator.registerLazySingleton<StorageService>(() => StorageService());

  // ================ External ================ //

  // locator.registerLazySingleton(() => StorageService());
}
