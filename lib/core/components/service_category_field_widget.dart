import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:eleven_crm/features/products/domain/usecases/service_product_category.dart';
import 'package:eleven_crm/features/products/presensation/cubit/service_product_category/service_product_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../get_it/locator.dart';
import '../constants/drop_down_decoration.dart';
import '../entities/field_entity.dart';

class ServiceCategoryFieldWidget extends StatefulWidget {
  const ServiceCategoryFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.onChange,
    this.enabled = true,
    this.elementId,
  }) : super(key: key);
  final bool enabled;
  final FieldEntity fieldEntity;
  final Function(ServiceProductCategoryEntity)? onChange;
  final int? elementId;

  @override
  State<ServiceCategoryFieldWidget> createState() =>
      _ServiceCategoryFieldWidgetState();
}

class _ServiceCategoryFieldWidgetState
    extends State<ServiceCategoryFieldWidget> {
  late ServiceProductCategoryCubit serviceProductCategoryCubit;
  @override
  void initState() {
    serviceProductCategoryCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceProductCategoryCubit,
      child: _ContentWidget(
        fieldEntity: widget.fieldEntity,
        onChange: widget.onChange,
        enabled: widget.enabled,
        elementId: widget.elementId,
      ),
    );
  }
}

class _ContentWidget extends StatefulWidget {
  final FieldEntity fieldEntity;
  final bool enabled;
  final Function(ServiceProductCategoryEntity)? onChange;
  final int? elementId;

  const _ContentWidget({
    Key? key,
    required this.fieldEntity,
    this.onChange,
    required this.enabled,
    this.elementId,
  }) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  final TextEditingController controllerSearch = TextEditingController();

  ServiceProductCategoryEntity serviceEntity =
      ServiceProductCategoryEntity.empty();
  List<ServiceProductCategoryEntity> listData = [];

  final ServiceProductCategoryCubit serviceProductCategoryCubit = locator();
  final GetServiceProductCategory getCustomer = locator();

  ServiceProductCategoryEntity? selectedItem;
  bool enabled = true;

  @override
  void initState() {
    initialize();
    // listenController();

    super.initState();
  }

  initialize() {
    BlocProvider.of<ServiceProductCategoryCubit>(context).load("");

    enabled = widget.enabled;
  }

  static int previousId = -1;

  @override
  void didUpdateWidget(_ContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.elementId != null) {
      final int newId = widget.elementId!;

      if (newId != previousId) {
        previousId = newId;
        initialize();
      }
    }
  }

  Future<List<ServiceProductCategoryEntity>> _getData(filter) async {
    List<ServiceProductCategoryEntity> listData = [];
    final data = await getCustomer.call(GetServiceProductCategoryParams(
      searchText: filter,
      page: 1,
      fetchGlobal: true,
    ));

    data.fold(
      (l) => debugPrint("error ${l.errorMessage}"),
      (r) => listData = r.results,
    );

    return listData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 40,
        child: BlocConsumer<ServiceProductCategoryCubit,
            ServiceProductCategoryState>(
          listener: (context, state) {
            if (state is ServiceProductCategoryLoaded) {
              listData = state.data;

              if (widget.fieldEntity.val != null) {
                selectedItem = listData.firstWhereOrNull(
                        (e) => e.id == widget.fieldEntity.val.id) ??
                    listData.first;
                widget.fieldEntity.val = selectedItem;
                Future.delayed(
                  Duration.zero,
                  () {
                    if (mounted) {
                      widget.onChange?.call(selectedItem!);
                    }
                  },
                );
              }

              serviceProductCategoryCubit.init();
            }
            if (state is ServiceProductCategorySaved) {
              debugPrint("State is $state");

              if (mounted) {
                Future.delayed(
                  Duration.zero,
                  () => setState(() {
                    listData.insert(0, state.data);
                  }),
                );
              }

              serviceProductCategoryCubit.init();
            }
          },
          builder: (context, state) {
            return DropdownSearch<ServiceProductCategoryEntity>(
              items: listData,
              enabled: enabled,

              asyncItems: (text) async {
                if (text.isNotEmpty) {
                  return _getData(text);
                }
                return [];
              },
              itemAsString: (ServiceProductCategoryEntity c) => c.name,
              selectedItem: selectedItem,

              popupProps: PopupPropsMultiSelection.menu(
                showSelectedItems: true,

                // validationWidgetBuilder: (context, item) {
                //   return Container(
                //     color: Colors.blue[200],
                //     height: 56,=
                //     child: Align(
                //       alignment: Alignment.center,
                //       child: MaterialButton(
                //         child: Text('OK'),
                //         onPressed: () {},
                //       ),
                //     ),
                //   );
                // },
                itemBuilder: (context, item, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      left: 10,
                      top: 5,
                    ),
                    child: Text(
                      item.name,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  );
                },

                showSearchBox: true,

                searchFieldProps: TextFieldProps(
                  controller: controllerSearch,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controllerSearch.clear(),
                    ),
                  ),
                ),
              ),
              // dropdownButtonProps: DropdownButtonProps(
              //   color: Colors.red,
              //   icon: const Icon(Icons.add),
              //   onPressed: () {
              //     CustomerEntity customerEntity = CustomerEntity.empty();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => DataPage(
              //           fields: customerEntity.getFields(),
              //           saveData: () {
              //             getItInstance<CustomerCubit>().saveData(customerEntity);
              //           },
              //         ),
              //       ),
              //     );
              //   },
              // ),
              compareFn: (item, selectedItem) => (item.id == selectedItem.id),

              dropdownDecoratorProps: DropDownDecoration.dropDownColor(
              'serviceProductCategoryFieldLabelText'.tr(),
              "serviceProductCategoryFieldLabelText".tr().toUpperCase(),
              widget.fieldEntity.isRequired,
            ),
              onChanged: (ServiceProductCategoryEntity? data) {
                log("Data $data");

                if (data != null) {
                  widget.fieldEntity.val = data;

                  widget.onChange?.call(data);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
