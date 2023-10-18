import 'dart:developer';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../model/filial_results_model.dart';
import '../model/service_product_caregory_results_model.dart';
import '../model/service_product_category_model.dart';
import '../model/service_product_model.dart';
import '../model/service_results_product_model.dart';

abstract class ProductsRemoteDataSource {
  // ================ SERVICE PRODUCT CRUD ================ //

  Future<ServiceResultsProductModel> getServiceProducts(
    int page,
    String searchText,
    String? ordering,
  );

  Future<ServiceProductModel> saveServiceProduct(ServiceProductModel data);

  Future<bool> deleteServiceProduct(String id);

  // ================ FILIAL CRUD ================ //

  Future<FilialResultsModel> getFilials(
    int page,
    String searchText,
    String? ordering,
  );

  // ================ SERVICE PRODUCT CATEGORY CRUD ================ //

  Future<ServiceProductCategoryResultsModel> getServiceProductCategory(
    int page,
    String searchText,
    String? ordering,
  );

  Future<ServiceProductCategoryModel> saveServiceProductCategory(
      ServiceProductCategoryModel data);

  Future<bool> deleteServiceProductCategory(String id);
}

class ProductsRemoteDataSourceImpl extends ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  // ================ SERVICE PRODUCT CRUD ================ //

  @override
  Future<ServiceResultsProductModel> getServiceProducts(
      int page, String searchText, String? ordering) async {
    final response = await _client.get(
        '${ApiConstants.serviceProduct}/?page=$page${searchText.isNotEmpty ? "&name=$searchText" : ""}');
    final results = ServiceResultsProductModel.fromJson(response);

    return results;
    //
    //
    // const  data =    ServiceResultsProductModel(count: 3, pageCount: 3, results:[
    //   ServiceProductModel(id: "", name: "Укладка", price: "30", duration: "45", categoryId: "3", sex: "2"),
    //   ServiceProductModel(id: "", name: "Стрижка", price: "30", duration: "55", categoryId: "3", sex: "1"),
    //   ServiceProductModel(id: "", name: "Стрижка топором", price: "100", duration: "1", categoryId: "3", sex: "1"),
    // ]);
    //
    // return data;
  }

  @override
  Future<ServiceProductModel> saveServiceProduct(
      ServiceProductModel data) async {
    dynamic response;
    if (data.id.isEmpty) {
      response = await _client.post(ApiConstants.serviceProduct,
          params: data.toJson());
    } else {
      response = await _client.patch('${ApiConstants.serviceProduct}/${data.id}/',
          params: data.toJson());
    }
    return ServiceProductModel.fromJson(response);
  }

  @override
  Future<bool> deleteServiceProduct(String id) async {
    final response =
        await _client.deleteWithBody('${ApiConstants.serviceProduct}/$id/');
    return response['success'] ?? false;
  }

  // ================ SERVICE PRODUCT CATEGORY CRUD ================ //

  @override
  Future<ServiceProductCategoryResultsModel> getServiceProductCategory(
      int page, String searchText, String? ordering) async {
    final response = await _client.get(
      '${ApiConstants.serviceProductCategory}/?page=$page${searchText.isNotEmpty ? "&name=$searchText" : ""}',
    );
    final results = ServiceProductCategoryResultsModel.fromJson(response);

    return results;

    // const  data =    ServiceProductCategoryResultsModel(count: 3, pageCount: 3, results:[
    //   ServiceProductCategoryModel(id: "", name: "Укладка", services: [],),
    //   ServiceProductCategoryModel(id: "", name: "Стрижка", services: [],),
    // ]);
    // return data;
  }

  @override
  Future<ServiceProductCategoryModel> saveServiceProductCategory(
      ServiceProductCategoryModel data) async {
    dynamic response;
    if (data.id.isEmpty) {
      response = await _client.post(ApiConstants.serviceProductCategory,
          params: data.toJson());
    } else {
      response = await _client.patch(
          '${ApiConstants.serviceProductCategory}/${data.id}/',
          params: data.toJson());
    }
    return ServiceProductCategoryModel.fromJson(response);
  }

  @override
  Future<bool> deleteServiceProductCategory(String id) async {
    final response = await _client
        .deleteWithBody('${ApiConstants.serviceProductCategory}/$id/');
    return response['success'] ?? false;
  }

  // ================ Filial ================ //

  @override
  Future<FilialResultsModel> getFilials(
      int page, String searchText, String? ordering) async {
    final response = await _client.get(
      '${ApiConstants.filial}?page=$page${searchText.isNotEmpty ? "&name=$searchText" : ""}',
    );


    final results = FilialResultsModel.fromJson(response);


    log("Filials ${results.results.length}");
    return results;
  }
}
