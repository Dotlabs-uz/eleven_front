import 'package:eleven_crm/features/management/data/model/barber_model.dart';
import 'package:eleven_crm/features/management/data/model/weekly_schedule_results_model.dart';
import 'package:eleven_crm/features/management/domain/entity/weekly_schedule_results_entity.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../products/data/model/service_product_model.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../presentation/widgets/employee_schedule_widget.dart';
import '../model/barber_results_model.dart';
import '../model/weekly_schedule_item_model.dart';
import '../model/customer_model.dart';
import '../model/customer_results_model.dart';
import '../model/employee_model.dart';
import '../model/employee_results_model.dart';
import '../model/employee_schedule_model.dart';
import '../model/manager_model.dart';
import '../model/manager_resutls_model.dart';

abstract class ManagementRemoteDataSource {
  // ================ CUSTOMER CRUD ================ //

  Future<CustomerResultsModel> getCustomer(
    int page,
    String searchText,
    String? ordering,
    String? startDate,
    String? endDate,
  );

  Future<CustomerModel> getCustomerById(String id );
  Future<CustomerModel> saveCustomer(CustomerModel data);

  Future<bool> deleteCustomer(String id);

// ================ EMPLOYEE CRUD ================ //

  Future<EmployeeResultsModel> getEmployee(
    int page,
    String searchText,
  );

  Future<EmployeeModel> getEmployeeEntity(
      String employeeId,
      );

  Future<EmployeeModel> saveEmployee(EmployeeModel data);

  Future<bool> deleteEmployee(String id);

  // ================ MANAGER CRUD ================ //

  Future<ManagerResultsModel> getManager(
    int page,
    String searchText,
  );

  Future<ManagerModel> saveManager(ManagerModel data);

  Future<bool> deleteManager(String id);

// ================ BARBERS CRUD ================ //

  Future<BarberResultsModel> getBarber(
    int page,
    String searchText,
    String? ordering,
  );

  Future<BarberModel> saveBarber(BarberModel data);
  Future<bool> saveEmployeeSchedule(List<FieldSchedule> data);

  Future<bool> deleteBarber(String id);

  Future<bool> saveEmployeeWeeklySchedule(
      WeeklyScheduleResultsModel resultsModel, String employeeId);
}

class ManagementRemoteDataSourceImpl extends ManagementRemoteDataSource {
  ManagementRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  // ================ CUSTOMER CRUD ================ //

  @override
  Future<CustomerResultsModel> getCustomer(int page, String searchText,
      String? ordering, String? startDate, String? endDate) async {
    final response = await _client.get(
        '${ApiConstants.clients}?page=$page${searchText.isNotEmpty ? "&name=$searchText" : ""}');
    final results = CustomerResultsModel.fromJson(response);

    return results;

    // final data = CustomerResultsModel(count: 3, pageCount: 3, results: const [
    //   CustomerModel(
    //     id: "",
    //     fullName: "fullName",
    //     phoneNumber: "+998931231212",
    //     ordersCount: 3,
    //   ),
    //   CustomerModel(
    //     id: "",
    //     fullName: "fullName",
    //     phoneNumber: "+998931231212",
    //     ordersCount: 43,
    //   ),
    //   CustomerModel(
    //     id: "",
    //     fullName: "fullName",
    //     phoneNumber: "+998931231212",
    //     ordersCount: 345,
    //   ),
    // ]);
    //
    // return data;
  }


  @override
  Future<CustomerModel> getCustomerById( String id,
      ) async {
    final response = await _client.get(
        '${ApiConstants.clients}/$id');
    final results = CustomerModel.fromJson(List.from(response['results']).first, isForOrder: false);

    return results;
  }

  @override
  Future<CustomerModel> saveCustomer(CustomerModel data) async {
    dynamic response;
    if (data.id.isEmpty) {
      response =
          await _client.post(ApiConstants.clients, params: data.toNewJson());
    } else {
      response = await _client.patch('${ApiConstants.clients}/${data.id}/',
          params: data.toJson());
    }
    return CustomerModel.fromJson(response);
  }

  @override
  Future<bool> deleteCustomer(String id) async {
    final response =
        await _client.deleteWithBody('${ApiConstants.clients}/$id/');
    return response['success'] ?? false;
  }

  // ================ EMPLOYEE CRUD ================ //

  @override
  Future<EmployeeResultsModel> getEmployee(
    int page,
    String searchText,
  ) async {
    final response = await _client.get(
        '${ApiConstants.employee}?page=$page${searchText.isNotEmpty ? "&firstName=$searchText" : ""}');
    final results = EmployeeResultsModel.fromJson(response);

    return results;

    // const data = EmployeeResultsModel(count: 3, pageCount: 3, results: [
    //   EmployeeModel(
    //       id: "",
    //       firstName: "firstName",
    //       role: "manager",
    //       phoneNumber: "+998931231212",
    //       schedule: [],
    //       lastName: 'Satt'),
    //   EmployeeModel(
    //       id: "",
    //       firstName: "Alex",
    //       role: "manager",
    //       phoneNumber: "+998931231212",
    //       schedule: [],
    //       lastName: 'Satt'),
    //   EmployeeModel(
    //     id: "",
    //     firstName: "Sammy",
    //     role: "manager",
    //     phoneNumber: "+998931231212",
    //     schedule: [],
    //     lastName: 'Satt',
    //   ),
    // ]);
    // return data;
  }

  @override
  Future<EmployeeModel> getEmployeeEntity(String employeeId) async {
    final response = await _client.get(
        '${ApiConstants.employee}/$employeeId');
    final results = EmployeeModel.fromJson(response);

    return results;

    // const data = EmployeeResultsModel(count: 3, pageCount: 3, results: [
    //   EmployeeModel(
    //       id: "",
    //       firstName: "firstName",
    //       role: "manager",
    //       phoneNumber: "+998931231212",
    //       schedule: [],
    //       lastName: 'Satt'),
    //   EmployeeModel(
    //       id: "",
    //       firstName: "Alex",
    //       role: "manager",
    //       phoneNumber: "+998931231212",
    //       schedule: [],
    //       lastName: 'Satt'),
    //   EmployeeModel(
    //     id: "",
    //     firstName: "Sammy",
    //     role: "manager",
    //     phoneNumber: "+998931231212",
    //     schedule: [],
    //     lastName: 'Satt',
    //   ),
    // ]);
    // return data;
  }

  @override
  Future<EmployeeModel> saveEmployee(EmployeeModel data) async {
    dynamic response;
    if (data.id.isEmpty) {
      response =
          await _client.post(ApiConstants.employee, params: data.toJson());
    } else {
      response = await _client.patch('${ApiConstants.employee}/${data.id}/',
          params: data.toJson());
    }
    return EmployeeModel.fromJson(response);
  }

  @override
  Future<bool> deleteEmployee(String id) async {
    final response =
        await _client.deleteWithBody('${ApiConstants.employee}/$id/');
    return response['success'] ?? false;
  }

  // ================ BARBER CRUD ================ //

  @override
  Future<bool> deleteBarber(String id) async {
    await _client.deleteWithBody("${ApiConstants.barbers}/$id");
    return true;
  }

  @override
  Future<BarberResultsModel> getBarber(
      int page, String searchText, String? ordering) async {
    final response = await _client.get(
      "${ApiConstants.barbers}?page=$page${searchText.isNotEmpty ? "&firstName=$searchText" : ""}${ordering ?? ""}",
    );
    final results = BarberResultsModel.fromJson(response);

    return results;
    // const data = BarberResultsModel(count: 10, pageCount: 10, results: [
    //   BarberModel(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     phoneNumber: "phoneNumber",
    //     filialId: "filialId",
    //     password: "password",
    //     login: "login",
    //   ),
    //   BarberModel(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     phoneNumber: "phoneNumber",
    //     filialId: "filialId",
    //     password: "password",
    //     login: "login",
    //   ),
    //   BarberModel(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     phoneNumber: "phoneNumber",
    //     filialId: "filialId",
    //     password: "password",
    //     login: "login",
    //   ),
    // ]);
    //
    // return data;
  }

  @override
  Future<bool> saveEmployeeWeeklySchedule(
      WeeklyScheduleResultsModel resultsModel, String employeeId) async {
    final params = {
      "weeklySchedule": resultsModel.schedule
          .map((e) => WeeklyScheduleItemModel.fromEntity(e).toJson()).toList(),
      "employeeId": employeeId,
    };

    print("params $params");
    await _client.post(ApiConstants.setBarberSchedule, params: params);
    return true;
  }

  @override
  Future<BarberModel> saveBarber(BarberModel data) async {
    dynamic response;
    if (data.id.isEmpty) {
      response =
          await _client.post(ApiConstants.barbers, params: data.toJson());
    } else {
      response = await _client.patch('${ApiConstants.barbers}/${data.id}/',
          params: data.toJson());
    }
    final results = BarberModel.fromJson(response);

    return results;
  }

  @override
  Future<bool> saveEmployeeSchedule(List<FieldSchedule> data) async {
    await _client.post(ApiConstants.employeeSchedule,
        params: {"schedule": data.map((e) => e.toJson()).toList()});

    return true;
  }
  // ================ MANAGER CRUD ================ //

  @override
  Future<bool> deleteManager(String id) async {
    await _client.deleteWithBody("${ApiConstants.managers}/$id");
    return true;
  }

  @override
  Future<ManagerResultsModel> getManager(int page, String searchText) async {
    final response = await _client.get(
      "${ApiConstants.managers}?page=$page${searchText.isNotEmpty ? "&firstName=$searchText" : ""}",
    );
    final results = ManagerResultsModel.fromJson(response);

    return results;
  }

  @override
  Future<ManagerModel> saveManager(ManagerModel data) async {
    dynamic response;
    if (data.id.isEmpty) {
      response =
          await _client.post(ApiConstants.managers, params: data.toJson());
    } else {
      response = await _client.patch('${ApiConstants.managers}/${data.id}/',
          params: data.toJson());
    }

    return ManagerModel.fromJson(response);
  }


}
