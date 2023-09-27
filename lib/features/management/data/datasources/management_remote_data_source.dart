

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../model/customer_model.dart';
import '../model/customer_results_model.dart';
import '../model/employee_model.dart';
import '../model/employee_results_model.dart';

abstract class ManagementRemoteDataSource {

  // ================ CUSTOMER CRUD ================ //


  Future<CustomerResultsModel> getCustomer(int page, String searchText,
      String? ordering, String? startDate, String? endDate,);


  Future<CustomerModel> saveCustomer(CustomerModel data);

  Future<bool> deleteCustomer(int id);


// ================ EMPLOYEE CRUD ================ //

  Future<EmployeeResultsModel> getEmployee(int page, String searchText,);


  Future<EmployeeModel> saveEmployee(EmployeeModel data);

  Future<bool> deleteEmployee(int id);


}

class ManagementRemoteDataSourceImpl extends ManagementRemoteDataSource {
  ManagementRemoteDataSourceImpl(this._client);

  final ApiClient _client;


  // ================ CUSTOMER CRUD ================ //


  @override
  Future<CustomerResultsModel> getCustomer(int page, String searchText,
      String? ordering, String? startDate, String? endDate) async {
    // final response = await _client.get(
    //     '${ApiConstants.customer}/?search=$searchText&ordering=$ordering&page=$page${startDate != null ? "&start_date=$startDate" : ""}${endDate != null ? "&end_date=$endDate" : ""}');
    // final results = CustomerResultsModel.fromJson(response);
    //
    // return results;


    final data =  CustomerResultsModel(count: 3, pageCount: 3, results:const [
       CustomerModel(id: 1, fullName: "fullName",  phoneNumber: "+998931231212", ordersCount: 3),
        CustomerModel(id: 2, fullName: "fullName",  phoneNumber: "+998931231212", ordersCount: 43),
        CustomerModel(id: 3, fullName: "fullName",  phoneNumber: "+998931231212", ordersCount: 345),
    ]);



    return data;

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



  // ================ EMPLOYEE CRUD ================ //


  @override
  Future<EmployeeResultsModel> getEmployee(int page, String searchText,) async {
    // final response = await _client.get(
    //     '${ApiConstants.customer}/?search=$searchText&ordering=$ordering&page=$page${startDate != null ? "&start_date=$startDate" : ""}${endDate != null ? "&end_date=$endDate" : ""}');
    // final results = CustomerResultsModel.fromJson(response);
    //
    // return results;


    final data =  EmployeeResultsModel(count: 3, pageCount: 3, results: [
      EmployeeModel(id: 1, fullName: "fullName", createdAt: DateTime.now().toString(),phoneNumber: "+998931231212", shopName: "address", schedule: []),
      EmployeeModel(id: 2, fullName: "fullName", createdAt: DateTime.now().toString(), phoneNumber: "+998931231212", shopName: "address", schedule: []),
      EmployeeModel(id: 3, fullName: "fullName", createdAt: DateTime.now().toString(), phoneNumber: "+998931231212", shopName: "address", schedule: []),
    ]);



    return data;

  }

  @override
  Future<EmployeeModel> saveEmployee(EmployeeModel data) async {
    dynamic response;
    if (data.id == 0) {
      response = await _client.post(ApiConstants.employee, params: data.toJson());
    } else {
      response =
          await _client.put('${ApiConstants.employee}${data.id}/', params: data.toJson());
    }
    return EmployeeModel.fromJson(response);
  }


  @override
  Future<bool> deleteEmployee(int id) async {
    final response = await _client.deleteWithBody('${ApiConstants.employee}$id/');
    return response['success'] ?? false;
  }

}
