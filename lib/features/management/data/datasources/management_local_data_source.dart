import 'package:flutter/foundation.dart';
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
    final customerBox = await Hive.openBox(
      HiveBoxNamesConstants.customerResultBox,
    );

    final json = await customerBox.get(HiveBoxKeysConstants.customerResult);

    debugPrint("Box json clients $json");
    if (json == null) return null;
    final result = CustomerResultsModel.fromJson(Map<String,dynamic>.from(json));

    return result;
  }

  @override
  Future<bool> saveCustomerResult(CustomerResultsModel data) async {
    final customerBox = await Hive.openBox(
      HiveBoxNamesConstants.customerResultBox,
    );

    await customerBox.put(HiveBoxKeysConstants.customerResult, data.toJson());

    return true;
  }
}
