
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../model/customer_model.dart';
import '../model/customer_results_model.dart';

abstract class ManagementRemoteDataSource {
  Future<CustomerResultsModel> getCustomer(int page, String searchText,
      String? ordering, String? startDate, String? endDate,);


  Future<CustomerModel> saveCustomer(CustomerModel data);

  Future<bool> deleteCustomer(int id);

}

class ManagementRemoteDataSourceImpl extends ManagementRemoteDataSource {
  ManagementRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  //===Crud Customer========
  @override
  Future<CustomerResultsModel> getCustomer(int page, String searchText,
      String? ordering, String? startDate, String? endDate) async {
    // final response = await _client.get(
    //     '${ApiConstants.customer}/?search=$searchText&ordering=$ordering&page=$page${startDate != null ? "&start_date=$startDate" : ""}${endDate != null ? "&end_date=$endDate" : ""}');
    // final results = CustomerResultsModel.fromJson(response);
    //
    // return results;

    return CustomerResultsModel(count: 3, pageCount: 3, results: [
      CustomerModel(id: 1, fullName: "fullName", createdAt: DateTime.now().toString(), updatedAt: DateTime.now().toString(), phoneNumber: "+998931231212", address: "address"),
      CustomerModel(id: 2, fullName: "fullName", createdAt: DateTime.now().toString(), updatedAt: DateTime.now().toString(), phoneNumber: "+998931231212", address: "address"),
      CustomerModel(id: 3, fullName: "fullName", createdAt: DateTime.now().toString(), updatedAt: DateTime.now().toString(), phoneNumber: "+998931231212", address: "address"),
    ]);
  }

  @override
  Future<CustomerModel> saveCustomer(CustomerModel data) async {
    dynamic response;
    if (data.id == 0) {
      response = await _client.post(ApiConstants.customer, params: data.toJson());
    } else {
      response =
          await _client.put('${ApiConstants.customer}${data.id}/', params: data.toJson());
    }
    return CustomerModel.fromJson(response);
  }


  @override
  Future<bool> deleteCustomer(int id) async {
    final response = await _client.deleteWithBody('${ApiConstants.customer}$id/');
    return response['success'] ?? false;
  }

}
