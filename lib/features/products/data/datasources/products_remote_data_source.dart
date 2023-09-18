


import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../model/service_product_model.dart';
import '../model/service_results_product_model.dart';

abstract class ProductsRemoteDataSource {

  // ================ SERVICE PRODUCT CRUD ================ //


  Future<ServiceResultsProductModel> getServiceProducts(int page, String searchText,
      String? ordering,);


  Future<ServiceProductModel> saveServiceProduct(ServiceProductModel data);

  Future<bool> deleteServiceProduct(int id);



}

class ProductsRemoteDataSourceImpl extends ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._client);

  final ApiClient _client;


  // ================ SERVICE PRODUCT CRUD ================ //


  @override
  Future<ServiceResultsProductModel> getServiceProducts(int page, String searchText,
      String? ordering) async {
    // final response = await _client.get(
    //     '${ApiConstants.customer}/?search=$searchText&ordering=$ordering&page=$page${startDate != null ? "&start_date=$startDate" : ""}${endDate != null ? "&end_date=$endDate" : ""}');
    // final results = CustomerResultsModel.fromJson(response);
    //
    // return results;


    const  data =    ServiceResultsProductModel(count: 3, pageCount: 3, results:[
      ServiceProductModel(id: 1, name: "Укладка", price: 30, duration: 45, categoryId: 3, sex: 2),
      ServiceProductModel(id: 2, name: "Стрижка", price: 75, duration: 55, categoryId: 3, sex: 1),
      ServiceProductModel(id: 3, name: "Стрижка топором", price: 100, duration: 1, categoryId: 3, sex: 1),
    ]);



    return data;

  }

  @override
  Future<ServiceProductModel> saveServiceProduct(ServiceProductModel data) async {
    dynamic response;
    if (data.id == 0) {
      response = await _client.post(ApiConstants.customer, params: data.toJson());
    } else {
      response =
      await _client.put('${ApiConstants.customer}${data.id}/', params: data.toJson());
    }
    return ServiceProductModel.fromJson(response);
  }


  @override
  Future<bool> deleteServiceProduct(int id) async {
    final response = await _client.deleteWithBody('${ApiConstants.serviceProduct}$id/');
    return response['success'] ?? false;
  }





}
