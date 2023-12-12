import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/data_employee_form.dart';
import '../../../../core/components/data_form.dart';
import '../../../../core/components/data_table_with_form_widget.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/loading_circle.dart';
import '../../../../core/components/page_selector_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../core/components/search_field.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/hive_box_keys_constants.dart';
import '../../../../get_it/locator.dart';
import '../../../main/domain/entity/top_menu_entity.dart';
import '../../../main/presensation/cubit/data_form/data_form_cubit.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../../main/presensation/widget/my_icon_button.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../data/model/employee_model.dart';
import '../../domain/entity/employee_entity.dart';
import '../cubit/employee/employee_cubit.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late EmployeeCubit employeeCubit;

  @override
  void initState() {
    employeeCubit = locator<EmployeeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeCubit>(
          create: (context) => employeeCubit,
        ),
      ],
      child: ContentWidget(
        employeeCubit: employeeCubit,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final EmployeeCubit employeeCubit;

  const ContentWidget({
    Key? key,
    required this.employeeCubit,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late bool isFormVisible;
  bool isSearch = false;
  static int dataCount = 0;
  static int pageCount = 0;
  final GlobalKey<DataFormWidgetState> _formKey = GlobalKey();
  late List<EmployeeEntity> customers;
  late EmployeeEntity activeData;

  late List<PlutoRow> selectedRows;
  late List<PlutoRow> rows;
  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  var filter = "";

  void _saveData() {
    BlocProvider.of<EmployeeCubit>(context)
        .save(employee: EmployeeEntity.fromFields());
  }

  void _deleteData(EmployeeEntity customerEntity) async {
    if (await confirm(
      super.context,
      title: const Text('confirming').tr(),
      content: const Text('deleteConfirm').tr(),
      textOK: const Text('yes').tr(),
      textCancel: const Text('cancel').tr(),
    )) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<EmployeeCubit>(context).delete(entity: customerEntity);
    }
  }

  void _editData(EmployeeEntity data) {
    BlocProvider.of<DataFormCubit>(context).editData(data.getFields());

    if (ResponsiveBuilder.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: DataEmployeeForm(
              saveData: _saveData,
              closeForm: () => Navigator.pop(context),
              fields: data.getFields(),
              onBackFromProfile: () {
                BlocProvider.of<EmployeeCubit>(context).load("");
              },
            ),
          ),
        ),
      );
    } else {
      setState(() => isFormVisible = true);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    rows = [];
    selectedRows = [];
    isFormVisible = false;

    activeData = EmployeeEntity.empty();
    customers = [];

    BlocProvider.of<EmployeeCubit>(context).load("");
    _setWidgetTop();
  }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      TopMenuEntity(
        searchCubit: widget.employeeCubit,
        iconList: [
          MyIconButton(
            onPressed: () {
              activeData = EmployeeEntity.empty();
              _editData(activeData);
            },
            icon: const Icon(Icons.add_box_rounded),
          ),
          MyIconButton(
              onPressed: () {
                BlocProvider.of<EmployeeCubit>(context).load("");
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
    );
  }

  fetch(
    int page,
  ) async {
    BlocProvider.of<EmployeeCubit>(context).load("", page: page);
  }

  initCubit() {
    BlocProvider.of<EmployeeCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSearch
                ? SearchField(
                    onSearch: (value) {
                      BlocProvider.of<EmployeeCubit>(context).load(value);
                    },
                  )
                : const SizedBox(),
          ),
          BlocConsumer<EmployeeCubit, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeLoaded) {
                customers = state.data;
                dataCount = state.dataCount;
              }

              {
                if (state is EmployeeSaved) {
                  SuccessFlushBar("change_success".tr()).show(context);
                } else if (state is EmployeeDeleted) {
                  SuccessFlushBar("data_deleted".tr()).show(context);
                } else if (state is EmployeeError) {
                  ErrorFlushBar("change_error".tr(args: [state.message]))
                      .show(context);
                }
              }
            },
            builder: (context, state) {
              if (state is EmployeeLoading) {
                return const Expanded(child: LoadingCircle());
              } else {
                if (state is EmployeeSaved) {
                  activeData = EmployeeModel.fromEntity(state.data);
                  isFormVisible = false;

                  // BlocProvider.of<DataFormCubit>(context)
                  //     .editData(activeData.getFields());
                  var ind = customers
                      .indexWhere((element) => element.id == activeData.id);
                  if (ind >= 0) {
                    customers[ind] = activeData;
                  } else {
                    customers.insert(0, activeData);
                  }
                  initCubit();
                } else if (state is EmployeeDeleted) {
                  var id = state.id;
                  isFormVisible = false;

                  var ind = customers.indexWhere((element) => element.id == id);
                  if (ind >= 0) {
                    customers.removeWhere((element) => element.id == id);
                  }
                  initCubit();
                }
                return Expanded(
                  child: DataTableWithForm(
                    data: customers,
                    isEmpty: customers.isEmpty,
                    onDelete: (id) {
                      final elementToDelete = customers.firstWhereOrNull(
                        (element) => element.id == id,
                      );

                      if (elementToDelete != null) {
                        debugPrint(
                            "Element to delete is not null ${elementToDelete.id}");
                        _deleteData(elementToDelete);
                      }
                    },
                    pageCount: pageCount,
                    isFormVisible: isFormVisible,
                    screenKey: HiveBoxKeysConstants.customerColumnSizes,
                    onTap: (data) {
                      if (data != null) {
                        selectedRow = data!;
                        final entity = EmployeeEntity.fromRow(selectedRow);
                        activeData = entity;
                        _editData(entity);
                      }
                    },
                    form: DataEmployeeForm(
                      key: _formKey,
                      closeForm: () {
                        setState(() {
                          isFormVisible = false;
                        });
                      },
                      saveData: _saveData,
                      fields: activeData.getFields(),
                      onBackFromProfile: () {
                        BlocProvider.of<EmployeeCubit>(context).load("");
                      },
                    ),
                  ),
                );
              }
            },
          ),
          BlocBuilder<EmployeeCubit, EmployeeState>(
            builder: (context, state) {
              if (state is EmployeeLoaded) {
                pageCount = state.pageCount;
              }
              return Padding(
                padding: pageCount != 1 && pageCount != 0
                    ? const EdgeInsets.only(bottom: 5)
                    : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (pageCount != 1 && pageCount != 0)
                      Expanded(
                        child: PageSelectorWidget(
                          pageCount: pageCount,
                          onChanged: (value) {
                            BlocProvider.of<EmployeeCubit>(context)
                                .load("", page: value);
                          },
                        ),
                      ),
                    const SizedBox(width: 10),
                    customers.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${"DataCount".tr()}: ",
                                    ),
                                    TextSpan(
                                      text: "$dataCount",
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
