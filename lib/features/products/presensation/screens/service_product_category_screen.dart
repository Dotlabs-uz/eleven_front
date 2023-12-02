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
import '../../../../core/utils/hive_box_keys_constants.dart';
import '../../../../get_it/locator.dart';
import '../../../main/domain/entity/top_menu_entity.dart';
import '../../../main/presensation/cubit/data_form/data_form_cubit.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../../main/presensation/widget/my_icon_button.dart';
import 'package:collection/collection.dart';

import '../../domain/entity/service_product_category_entity.dart';
import '../cubit/service_product_category/service_product_category_cubit.dart';

class ServiceProductCategoryScreen extends StatefulWidget {
  const ServiceProductCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ServiceProductCategoryScreen> createState() =>
      _ServiceProductCategoryScreenState();
}

class _ServiceProductCategoryScreenState
    extends State<ServiceProductCategoryScreen> {
  late ServiceProductCategoryCubit serviceProductCategoryCubit;

  @override
  void initState() {
    serviceProductCategoryCubit = locator<ServiceProductCategoryCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServiceProductCategoryCubit>(
          create: (context) => serviceProductCategoryCubit,
        ),
      ],
      child: ContentWidget(
        serviceProductCategoryCubit: serviceProductCategoryCubit,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final ServiceProductCategoryCubit serviceProductCategoryCubit;
  const ContentWidget({
    Key? key,
    required this.serviceProductCategoryCubit,
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
  late List<ServiceProductCategoryEntity> serviceProducts;
  late ServiceProductCategoryEntity activeData;

  late List<PlutoRow> selectedRows;
  late List<PlutoRow> rows;
  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  var filter = "";

  void _saveData() {
    BlocProvider.of<ServiceProductCategoryCubit>(context)
        .save(customer: ServiceProductCategoryEntity.fromFields());
  }

  void _deleteData(ServiceProductCategoryEntity customerEntity) async {
    if (await confirm(
      super.context,
      title: const Text('confirming').tr(),
      content: const Text('deleteConfirm').tr(),
      textOK: const Text('yes').tr(),
      textCancel: const Text('cancel').tr(),
    )) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ServiceProductCategoryCubit>(context)
          .delete(entity: customerEntity);
    }
  }

  void _editData(ServiceProductCategoryEntity data) {
    BlocProvider.of<DataFormCubit>(context).editData(data.getFields());

    if (ResponsiveBuilder.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataPage(
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

    activeData = ServiceProductCategoryEntity.empty();
    serviceProducts = [];

    BlocProvider.of<ServiceProductCategoryCubit>(context).load("");
    _setWidgetTop();
  }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      TopMenuEntity(
        searchCubit: widget.serviceProductCategoryCubit,
        iconList: [
          MyIconButton(
            onPressed: () {
              activeData = ServiceProductCategoryEntity.empty();
              _editData(activeData);
            },
            icon: const Icon(Icons.add_box_rounded),
          ),
          MyIconButton(
              onPressed: () {
                BlocProvider.of<ServiceProductCategoryCubit>(context).load(
                  "",
                );
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
    );
  }

  fetch(
    int page,
  ) async {
    BlocProvider.of<ServiceProductCategoryCubit>(context).load("", page: page);
  }

  initCubit() {
    BlocProvider.of<ServiceProductCategoryCubit>(context).init();
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
                      BlocProvider.of<ServiceProductCategoryCubit>(context)
                          .load(
                        value,
                      );
                    },
                  )
                : const SizedBox(),
          ),
          BlocConsumer<ServiceProductCategoryCubit,
              ServiceProductCategoryState>(
            listener: (context, state) {
              if (state is ServiceProductCategoryLoaded) {
                serviceProducts = state.data;
                dataCount = state.dataCount;
              }

              {
                if (state is ServiceProductCategorySaved) {
                  SuccessFlushBar("change_success".tr()).show(context);
                } else if (state is ServiceProductCategoryDeleted) {
                  SuccessFlushBar("data_deleted".tr()).show(context);
                } else if (state is ServiceProductCategoryError) {
                  ErrorFlushBar("change_error".tr(args: [state.message]))
                      .show(context);
                }
              }
            },
            builder: (context, state) {
              if (state is ServiceProductCategoryLoading) {
                return const Expanded(child: LoadingCircle());
              } else {
                if (state is ServiceProductCategorySaved) {
                  activeData = state.data;
                  isFormVisible = false;

                  // BlocProvider.of<DataFormCubit>(context)
                  //     .editData(activeData.getFields());
                  var ind = serviceProducts
                      .indexWhere((element) => element.id == activeData.id);
                  if (ind >= 0) {
                    serviceProducts[ind] = activeData;
                  } else {
                    serviceProducts.insert(0, activeData);
                  }
                  initCubit();
                } else if (state is ServiceProductCategoryDeleted) {
                  var id = state.id;
                  isFormVisible = false;

                  var ind =
                      serviceProducts.indexWhere((element) => element.id == id);
                  if (ind >= 0) {
                    serviceProducts.removeWhere((element) => element.id == id);
                  }
                  initCubit();
                }
                return Expanded(
                  child: DataTableWithForm(
                    data: serviceProducts,
                    isEmpty: serviceProducts.isEmpty,
                    onDelete: (id) {
                      final elementToDelete = serviceProducts.firstWhereOrNull(
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
                        final entity =
                            ServiceProductCategoryEntity.fromRow(selectedRow);
                        activeData = entity;
                        _editData(entity);
                      }
                    },
                    form: DataFormWidget(
                      key: _formKey,
                      closeForm: () {
                        setState(() {
                          isFormVisible = false;
                        });
                      },
                      saveData: _saveData,
                    ),
                  ),
                );
              }
            },
          ),
          BlocBuilder<ServiceProductCategoryCubit, ServiceProductCategoryState>(
            builder: (context, state) {
              if (state is ServiceProductCategoryLoaded) {
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
                            BlocProvider.of<ServiceProductCategoryCubit>(
                                    context)
                                .load(
                              "",
                              page: value,
                            );
                          },
                        ),
                      ),
                    const SizedBox(width: 10),
                    serviceProducts.isEmpty
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
