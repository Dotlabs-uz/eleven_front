import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/customer_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/management/domain/usecases/customer.dart';
import '../../features/management/presentation/cubit/customer/customer_cubit.dart';
import '../../get_it/locator.dart';
import '../entities/field_entity.dart';

class ClientFieldWidget extends StatefulWidget {
  const ClientFieldWidget({
    Key? key,
    this.fieldEntity,
    this.onChange,
    this.enabled = true,
    this.elementId,
  }) : super(key: key);
  final bool enabled;
  final FieldEntity? fieldEntity;
  final Function(CustomerEntity)? onChange;
  final int? elementId;

  @override
  State<ClientFieldWidget> createState() => _ClientFieldWidgetState();
}

class _ClientFieldWidgetState extends State<ClientFieldWidget> {
  late CustomerCubit customerCubit;
  @override
  void initState() {
    customerCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => customerCubit,
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
  final FieldEntity? fieldEntity;
  final bool enabled;
  final Function(CustomerEntity)? onChange;
  final int? elementId;

  const _ContentWidget({
    Key? key,
    this.fieldEntity,
    this.onChange,
    required this.enabled,
    this.elementId,
  }) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  final TextEditingController controllerSearch = TextEditingController();

  CustomerEntity serviceEntity = CustomerEntity.empty();
  List<CustomerEntity> listData = [];

  final CustomerCubit filialCubit = locator();
  final GetCustomer getCustomer = locator();

  CustomerEntity? selectedItem;
  bool enabled = true;

  @override
  void initState() {
    initialize();
    // listenController();

    super.initState();
  }

  initialize() {
    BlocProvider.of<CustomerCubit>(context).load(
      "",
    );

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

  Future<List<CustomerEntity>> _getData(filter) async {
    List<CustomerEntity> listData = [];
    final data = await getCustomer.call(const CustomerParams(page: 1));

    data.fold(
      (l) => print("error ${l.errorMessage}"),
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
        child: BlocConsumer<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerLoaded) {
              listData = state.data;

              if (widget.fieldEntity != null) {
                if (widget.fieldEntity!.val != null) {
                  selectedItem = listData.firstWhereOrNull(
                          (e) => e.id == widget.fieldEntity!.val) ??
                      listData.first;
                  widget.fieldEntity!.val = selectedItem;
                  Future.delayed(
                    Duration.zero,
                    () {
                      if (mounted) {
                        widget.onChange?.call(selectedItem!);
                      }
                    },
                  );
                }
              }

              filialCubit.init();
            }
          },
          builder: (context, state) {
            return DropdownSearch<CustomerEntity>(
              items: listData,
              enabled: enabled,

              asyncItems: (text) async {
                if (text.isNotEmpty) {
                  return _getData(text);
                }
                return [];
              },
              itemAsString: (CustomerEntity c) => c.fullName,
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
                      item.fullName,
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
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: widget.fieldEntity != null
                      ? widget.fieldEntity!.isRequired
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(
                              color: Colors.green,
                            ))
                          : null
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                  labelText: "customer".tr().toUpperCase(),
                  hintText: "customer".tr(),
                ),
              ),
              onChanged: (CustomerEntity? data) {
                log("Data $data");

                if (data != null) {
                  if (widget.fieldEntity != null) {
                    widget.fieldEntity!.val = data.id;
                  }

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
