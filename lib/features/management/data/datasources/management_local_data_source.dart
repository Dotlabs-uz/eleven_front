// import 'package:hive/hive.dart';
//
// import '../../../../core/utils/hive_box_keys_constants.dart';
// import '../../../../core/utils/hive_box_names_constants.dart';
// import '../models/customer_model.dart';
// import '../models/customer_results_model.dart';
// import '../models/employee_results_model.dart';
// import '../models/provider_results_model.dart';
// import '../models/shop_resutls_model.dart';
//
// abstract class ManagementLocalDataSource {
//   // ================ Customer  ================ //
//
//   Future<CustomerResultsModel> getCustomerResult(String searchText,);
//
//   Future<bool> saveCustomerResult(CustomerResultsModel data);
//
//   Future<void> saveCustomerIdToDelete(int id,);
//
//   Future<List<int>> getCustomerIdToDelete();
//
//   Future<CustomerModel> saveCustomerNotSynced(CustomerModel model,);
//
//   Future<List<CustomerModel>> getCustomerNotSynced();
//
//   Future<void> deleteAllCustomerToDelete();
//
//   Future<void> deleteAllNotSyncedCustomer();
//
//   Future<bool> deleteCustomerNotSynced(CustomerModel model,);
//
//   // ================ Provider ================ //
//
//   Future<ProviderResultsModel> getProviderResult(String searchText,
//       bool? isActive,);
//
//   Future<void> saveProviderResult(ProviderResultsModel data);
//
//   // ================ Shop ================ //
//
//   Future<ShopResultsModel> getShopResult(String searchText,);
//
//   Future<void> saveShopResult(ShopResultsModel data);
//
//   // ================ Employee ================ //
//
//   Future<EmployeeResultsModel> getEmployeeResults(String searchText,);
//
//   Future<void> saveEmployeeResults(EmployeeResultsModel data);
// }
//
// class ManagementLocalDataSourceImpl extends ManagementLocalDataSource {
//   @override
//   Future<CustomerResultsModel> getCustomerResult(String searchText) async {
//     final devicesBox = await Hive.openBox<CustomerResultsModel>(
//       HiveBoxNamesConstants.customerResultBox,
//     );
//
//     final response = devicesBox.get(HiveBoxKeysConstants.customerResult);
//
//     debugPrint("Get Customers $response");
//
//     return Future.value(response);
//   }
//
//   @override
//   Future<bool> saveCustomerResult(CustomerResultsModel data) async {
//     try {
//       final customerBox = await Hive.openBox<CustomerResultsModel>(
//         HiveBoxNamesConstants.customerResultBox,
//       );
//
//       debugPrint("Customer save result ${data.count}");
//       await customerBox.put(HiveBoxKeysConstants.customerResult, data);
//
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }
//
//
//   @override
//   Future<void> deleteAllNotSyncedCustomer() async {
//     final notSyncedBox = await Hive.openBox<CustomerModel>(
//         HiveBoxNamesConstants.customerNotSynced);
//     await notSyncedBox.clear();
//   }
//
//   @override
//   Future<void> deleteAllCustomerToDelete() async {
//     final box = await Hive.openBox<int>(
//       HiveBoxNamesConstants.customerToDelete,
//     );
//     await box.clear();
//   }
//
//   @override
//   Future<bool> deleteCustomerNotSynced(CustomerModel model) async {
//     if (model.id != 0) {
//       saveCustomerIdToDelete(model.id);
//     }
//
//     // Delete from list not synced
//
//     final notSyncedBox = await Hive.openBox<CustomerModel>(
//       HiveBoxNamesConstants.customerNotSynced,
//     );
//
//     final listNotSynced = notSyncedBox.values.toList();
//
//     if (listNotSynced.isNotEmpty) {
//       final indexForDelete = listNotSynced.indexWhere(
//             (element) =>
//         element.region == model.region &&
//             element.phoneNumber == model.phoneNumber &&
//             element.createdAt == model.createdAt,
//       );
//
//       notSyncedBox.deleteAt(indexForDelete);
//     }
//
//     // Delete From results model
//
//     final resultModel = await getCustomerResult("");
//
//     final listResults = resultModel.results;
//
//     listResults.removeWhere(
//           (element) =>
//       element.region == model.region &&
//           element.phoneNumber == model.phoneNumber &&
//           element.createdAt == model.createdAt,
//     );
//
//     return await saveCustomerResult(resultModel);
//   }
//
//   @override
//   Future<List<int>> getCustomerIdToDelete() async {
//     final box = await Hive.openBox<int>(
//       HiveBoxNamesConstants.customerToDelete,
//     );
//
//     final listValues = box.values.toList();
//
//     return Future.value(listValues);
//   }
//
//   @override
//   Future<List<CustomerModel>> getCustomerNotSynced() async {
//     final paymentBox = await Hive.openBox<CustomerModel>(
//       HiveBoxNamesConstants.customerNotSynced,
//     );
//
//     final listValues = paymentBox.values.toList();
//
//     return Future.value(listValues);
//   }
//
//   @override
//   Future<void> saveCustomerIdToDelete(int id) async {
//     final box = await Hive.openBox<int>(
//       HiveBoxNamesConstants.customerToDelete,
//     );
//
//     box.add(id);
//   }
//
//   @override
//   Future<CustomerModel> saveCustomerNotSynced(CustomerModel model) async {
//     await _saveCustomer(model);
//
//     final paymentBox = await Hive.openBox<CustomerModel>(
//       HiveBoxNamesConstants.customerNotSynced,
//     );
//
//     paymentBox.add(model);
//
//     return model;
//   }
//
//   Future<bool> _saveCustomer(CustomerModel model,) async {
//     final resultModel = await getCustomerResult("");
//
//     final listPayments = resultModel.results;
//
//     listPayments.add(model);
//
//     return await saveCustomerResult(resultModel);
//   }
//
//   // ================ Shop CRUD ================ //
//
//   @override
//   Future<ShopResultsModel> getShopResult(String searchText) async {
//     final devicesBox = await Hive.openBox<ShopResultsModel>(
//       HiveBoxNamesConstants.shopResultBoxBox,
//     );
//
//     final response = devicesBox.get(HiveBoxKeysConstants.shopResult);
//
//     debugPrint("Get shop $response");
//
//     return Future.value(response);
//   }
//
//   @override
//   Future<void> saveShopResult(ShopResultsModel data) async {
//     final devicesBox = await Hive.openBox<ShopResultsModel>(
//       HiveBoxNamesConstants.shopResultBoxBox,
//     );
//
//     debugPrint("Shop save result ${data.count}");
//     await devicesBox.put(HiveBoxKeysConstants.shopResult, data);
//   }
//
//   // ================ Provider CRUD ================ //
//
//   @override
//   Future<ProviderResultsModel> getProviderResult(String searchText,
//       bool? isActive) async {
//     final devicesBox = await Hive.openBox<ProviderResultsModel>(
//       HiveBoxNamesConstants.providerResultBox,
//     );
//
//     final response = devicesBox.get(HiveBoxKeysConstants.providerResult);
//
//     debugPrint("Get shop $response");
//
//     if (response != null && isActive != null) {
//       response.results
//           .removeWhere((element) => element.isActive != element.isActive);
//     }
//
//     return Future.value(response);
//   }
//
//   @override
//   Future<void> saveProviderResult(ProviderResultsModel data) async {
//     final devicesBox = await Hive.openBox<ProviderResultsModel>(
//       HiveBoxNamesConstants.providerResultBox,
//     );
//
//     debugPrint("Shop save result ${data.count}");
//     await devicesBox.put(HiveBoxKeysConstants.providerResult, data);
//   }
//
//   @override
//   Future<EmployeeResultsModel> getEmployeeResults(String searchText) async {
//     final devicesBox = await Hive.openBox<EmployeeResultsModel>(
//       HiveBoxNamesConstants.employeeResultBox,
//     );
//
//     final response = devicesBox.get(HiveBoxKeysConstants.employeeResults);
//
//     return Future.value(response);
//   }
//
//   @override
//   Future<void> saveEmployeeResults(EmployeeResultsModel data) async {
//     final devicesBox = await Hive.openBox<EmployeeResultsModel>(
//       HiveBoxNamesConstants.employeeResultBox,
//     );
//
//     await devicesBox.put(HiveBoxKeysConstants.employeeResults, data);
//   }
// }
