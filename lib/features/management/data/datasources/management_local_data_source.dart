import 'package:hive/hive.dart';

import '../../../../core/utils/hive_box_keys_constants.dart';
import '../../../../core/utils/hive_box_names_constants.dart';
import '../model/customer_results_model.dart';

abstract class ManagementLocalDataSource {
  // ================ Customer  ================ //

  Future<CustomerResultsModel?> getCustomerResult(
    String searchText,
  );

  Future<bool> saveCustomerResult(CustomerResultsModel data);
}

class ManagementLocalDataSourceImpl extends ManagementLocalDataSource {
  @override
  Future<CustomerResultsModel?> getCustomerResult(String searchText) async {
    final devicesBox = await Hive.openBox(
      HiveBoxNamesConstants.customerResultBox,
    );

    final response = devicesBox.get(HiveBoxKeysConstants.customerResult);
    if (response == null) return null;
    final result = CustomerResultsModel.fromJson(response);

    return result;
  }

  @override
  Future<bool> saveCustomerResult(CustomerResultsModel data) async {
    try {
      final customerBox = await Hive.openBox(
        HiveBoxNamesConstants.customerResultBox,
      );

      await customerBox.put(HiveBoxKeysConstants.customerResult, data.toJson());

      return true;
    } catch (error) {
      return false;
    }
  }
}
