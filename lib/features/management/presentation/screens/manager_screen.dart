import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/manager_entity.dart';
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
import '../../../main/presensation/cubit/data_form/data_form_cubit.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../../main/presensation/widget/my_icon_button.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../cubit/manager/manager_cubit.dart';


class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  late ManagerCubit managerCubit;

  @override
  void initState() {
    managerCubit = locator<ManagerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ManagerCubit>(
          create: (context) => managerCubit,
        ),
      ],
      child: ContentWidget(
        managerCubit: managerCubit,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final ManagerCubit managerCubit;

  const ContentWidget({
    Key? key,
    required this.managerCubit,
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
  late List<ManagerEntity> customers;
  late ManagerEntity activeData;

  late List<PlutoRow> selectedRows;
  late List<PlutoRow> rows;
  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  var filter = "";

  void _saveData() {
    BlocProvider.of<ManagerCubit>(context)
        .save(employee: ManagerEntity.fromFields());
  }

  void _deleteData(ManagerEntity customerEntity) async {
    if (await confirm(
      super.context,
      title: const Text('confirming').tr(),
      content: const Text('deleteConfirm').tr(),
      textOK: const Text('yes').tr(),
      textCancel: const Text('cancel').tr(),
    )) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ManagerCubit>(context).delete(entity: customerEntity);
    }
  }

  void _editData(ManagerEntity data) {
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

    activeData = ManagerEntity.empty();
    customers = [];

    BlocProvider.of<ManagerCubit>(context).load();
    _setWidgetTop();
  }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      [
        MyIconButton(
          onPressed: () => setState(() => isSearch = !isSearch),
          icon: const Icon(Icons.search),
        ),
        MyIconButton(
          onPressed: () {
            activeData = ManagerEntity.empty();
            _editData(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.filter_alt,
          ),
        ),
        MyIconButton(
            onPressed: () {
              BlocProvider.of<ManagerCubit>(context).load();
            },
            icon: const Icon(Icons.refresh)),
      ],
    );
  }

  fetch(
    int page,
  ) async {
    BlocProvider.of<ManagerCubit>(context).load(search: "", page: page);
  }

  initCubit() {
    BlocProvider.of<ManagerCubit>(context).init();
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
                      BlocProvider.of<ManagerCubit>(context).load(
                        search: value,
                      );
                    },
                  )
                : const SizedBox(),
          ),
          BlocConsumer<ManagerCubit, ManagerState>(
            listener: (context, state) {
              if (state is ManagerLoaded) {
                customers = state.data;
                dataCount = state.dataCount;
              }

              {
                if (state is ManagerSaved) {
                  SuccessFlushBar("change_success".tr()).show(context);
                } else if (state is ManagerDeleted) {
                  SuccessFlushBar("data_deleted".tr()).show(context);
                } else if (state is ManagerError) {
                  ErrorFlushBar("change_error".tr(args: [state.message]))
                      .show(context);
                }
              }
            },
            builder: (context, state) {
              if (state is EmployeeLoading) {
                return const Expanded(child: LoadingCircle());
              } else {
                if (state is ManagerSaved) {
                  activeData = state.data;
                  BlocProvider.of<DataFormCubit>(context)
                      .editData(activeData.getFields());
                  var ind = customers
                      .indexWhere((element) => element.id == activeData.id);
                  if (ind >= 0) {
                    customers[ind] = activeData;
                  } else {
                    customers.insert(0, activeData);
                  }
                  initCubit();
                } else if (state is ManagerDeleted) {
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
                        final entity = ManagerEntity.fromRow(selectedRow);
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
                    ),
                  ),
                );
              }
            },
          ),
          BlocBuilder<ManagerCubit, ManagerState>(
            builder: (context, state) {
              if (state is ManagerLoaded) {
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
                            BlocProvider.of<ManagerCubit>(context).load(
                              search: "",
                              page: value,
                            );
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
