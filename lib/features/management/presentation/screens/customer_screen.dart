import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/data_form.dart';
import '../../../../core/components/data_table_with_form_widget.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/loading_circle.dart';
import '../../../../core/components/page_selector_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../core/components/search_field.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/hive_box_keys_constants.dart';
import '../../../../get_it/locator.dart';
import '../../../main/presensation/cubit/data_form/data_form_cubit.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../../main/presensation/widget/my_icon_button.dart';
import '../../domain/entity/customer_entity.dart';
import '../cubit/customer/customer_cubit.dart';
import 'package:collection/collection.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late CustomerCubit customerCubit;

  @override
  void initState() {
    customerCubit = locator<CustomerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerCubit>(
          create: (context) => customerCubit,
        ),
      ],
      child: ContentWidget(
        customerCubit: customerCubit,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({
    Key? key,
    required this.customerCubit,
  }) : super(key: key);
  final CustomerCubit customerCubit;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late bool isFormVisible;
  bool isSearch = false;
  int regIndex = 0;
  static int dataCount = 0;
  static int pageCount = 0;
  final GlobalKey<DataFormWidgetState> _formKey = GlobalKey();
  late List<CustomerEntity> customers;
  late CustomerEntity activeData;

  late List<PlutoRow> selectedRows;
  late PlutoRow selectedRow;
  late List<PlutoRow> rows;
  late PlutoGridStateManager stateManager;

  var filter = "";

  bool isOrganisation = false;

  void _saveData() {
    BlocProvider.of<CustomerCubit>(context)
        .save(customer: CustomerEntity.fromFields());
  }

  void _deleteData(CustomerEntity customerEntity) async {
    if (await confirm(
      super.context,
      title: const Text('confirming').tr(),
      content: const Text('deleteConfirm').tr(),
      textOK: const Text('yes').tr(),
      textCancel: const Text('cancel').tr(),
    )) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<CustomerCubit>(context).delete(entity: customerEntity);
    }
  }

  void _editData(CustomerEntity data) {
    BlocProvider.of<DataFormCubit>(context).editData(data.getFields());

    if (ResponsiveBuilder.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataPage(
            // fields: data.getFields(),
            saveData: _saveData,
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

    activeData = CustomerEntity.empty();
    customers = [];

      BlocProvider.of<CustomerCubit>(context).load("");
    _setWidgetTop();
  }

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {
    if (event.isRow) {
      if (event.isChecked ?? false) {
        selectedRows.add(event.row!);
      } else {
        selectedRows.removeWhere((element) => element == event.row!);
      }
    } else {
      selectedRows.clear();
      stateManager.checkedRows.forEach((element) {
        selectedRows.add(element);
      });

      print(stateManager.checkedRows.length);
    }
  }

  _setWidgetTop() {
    final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      [
        MyIconButton(
          onPressed: () => setState(() => isSearch = !isSearch),
          icon: const Icon(Icons.search),
        ),
        MyIconButton(
          onPressed: () {
            activeData = CustomerEntity.empty();
            _editData(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {
          },
          icon: const Icon(
            Icons.filter_alt,
          ),
        ),
        MyIconButton(
            onPressed: () {
              BlocProvider.of<CustomerCubit>(context).load(
                "",
              );
            },
            icon: const Icon(Icons.refresh)),
      ],
    );
  }

  fetch(
    int page,
  ) async {
    BlocProvider.of<CustomerCubit>(context).load("", page: page);
  }

  initCubit() {
    BlocProvider.of<CustomerCubit>(context).init();
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
                              BlocProvider.of<CustomerCubit>(context).load(
                                value,
                              );
                            },
                          )
                        : const SizedBox(),
                  ),
                  BlocConsumer<CustomerCubit, CustomerState>(
                    listener: (context, state) {
                      if (state is CustomerLoaded) {
                        customers = state.data;
                        dataCount = state.dataCount;
                      }

                      {
                        if (state is CustomerSaved) {
                          SuccessFlushBar("change_success".tr()).show(context);
                        } else if (state is CustomerDeleted) {
                          SuccessFlushBar("data_deleted".tr()).show(context);
                        } else if (state is CustomerError) {
                          ErrorFlushBar(
                                  "change_error".tr(args: [state.message]))
                              .show(context);
                        }
                      }
                      ;
                    },
                    builder: (context, state) {
                      if (state is CustomerLoading) {
                        return const Expanded(child: LoadingCircle());
                      } else {
                        if (state is CustomerSaved) {
                          activeData = state.data;
                          BlocProvider.of<DataFormCubit>(context)
                              .editData(activeData.getFields());
                          var ind = customers.indexWhere(
                              (element) => element.id == activeData.id);
                          if (ind >= 0) {
                            customers[ind] = activeData;
                          } else {
                            customers.insert(0, activeData);
                          }
                          initCubit();
                        } else if (state is CustomerDeleted) {
                          var id = state.id;
                          isFormVisible = false;

                          var ind = customers
                              .indexWhere((element) => element.id == id);
                          if (ind >= 0) {
                            customers
                                .removeWhere((element) => element.id == id);
                          }
                          initCubit();
                        }
                        return Expanded(
                          child: DataTableWithForm(
                            data: customers,
                            isEmpty: customers.isEmpty,

                            onDelete: (id) {
                              // print("Delete data ${id}");
                              final elementToDelete =
                                  customers.firstWhereOrNull(
                                      (element) => element.id == id);

                              if (elementToDelete != null) {
                                print(
                                    "Element to delete is not null ${elementToDelete.id}");
                                _deleteData(elementToDelete);
                              }
                            },
                            pageCount: pageCount,
                            isFormVisible: isFormVisible,
                            screenKey: HiveBoxKeysConstants.customerColumnSizes,

                            onTap: (data) {
                              print("data $data");
                              if (data != null) {
                                ;
                                selectedRow = data!;
                                final entity =
                                    CustomerEntity.fromRow(selectedRow);
                                activeData = entity;
                                _editData(entity);
                              }
                            },
                            // onChanged: (data) {
                            //
                            // selectedRow = data;
                            // BlocProvider.of<CustomerCubit>(context)
                            //     .save(
                            //         customer: CustomerEntity.fromRow(
                            //             selectedRow));
                            // },
                            form: DataFormWidget(
                              key: _formKey,
                              closeForm: () {
                                setState(() {
                                  isFormVisible = false;
                                });
                              },
                              // fields: activeData.getFields(),
                              saveData: _saveData,
                            ),
                          ),
                        );
                      }

                    },
                  ),
                  BlocBuilder<CustomerCubit, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomerLoaded) {
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
                                    BlocProvider.of<CustomerCubit>(context)
                                        .load(
                                      "",
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
              ));
  }
}
