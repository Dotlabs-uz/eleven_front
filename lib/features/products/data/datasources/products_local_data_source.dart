
import 'package:hive/hive.dart';

import '../model/service_product_caregory_results_model.dart';

abstract class ProductsLocalDataSource {
  // ================ SERVICE PRODUCT CATEGORY CRUD ================ //

  Future<ServiceProductCategoryResultsModel?> getServiceProductCategory(
    String searchText,
    bool withServiceCategoryParsing,
  );

  Future<bool> saveServiceProductCategory(
      ServiceProductCategoryResultsModel  model,

      );

  Future<bool> deleteServiceProductCategory(String id);
}

class ProductsLocalDataSourceImpl extends ProductsLocalDataSource {
  @override
  Future<bool> deleteServiceProductCategory(String id)async  {
    final authenticationBox = await Hive.openBox('serviceProduct');
    authenticationBox.delete('productsCategories');

    return true;
  }

  @override
  Future<ServiceProductCategoryResultsModel?> getServiceProductCategory(
      String searchText, bool withServiceCategoryParsing) async {
    final authenticationBox = await Hive.openBox('serviceProduct');
    final json = await authenticationBox.get('productsCategories');

    if(json== null) return null;
    final data = ServiceProductCategoryResultsModel.fromJson(Map.from(json));

    return data;
  }

  @override
  Future<bool> saveServiceProductCategory(
      ServiceProductCategoryResultsModel model) async {
    final authenticationBox = await Hive.openBox('serviceProduct');
    await authenticationBox.put('productsCategories', model.toJson());

    return true;
  }
}
