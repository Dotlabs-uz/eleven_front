// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/main/presensation/cubit/data_form/data_form_cubit.dart';
import '../../features/management/domain/entity/customer_entity.dart';
import '../../features/management/domain/usecases/customer.dart';
import '../../features/management/presentation/cubit/customer/customer_cubit.dart';
import '../../get_it/locator.dart';
import '../entities/field_entity.dart';
import 'package:collection/collection.dart';
import 'data_form.dart';

class CustomerFieldWidget extends StatelessWidget {

  final bool enabled;
  final FieldEntity fieldEntity;
  final Function(CustomerEntity) onChanged;
  final Function()? onCreate;

  const CustomerFieldWidget({
    Key? key,
    required this.fieldEntity,
    required this.onChanged,
    this.enabled = true,
    this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomerFieldContent(
      fieldEntity: fieldEntity,
      onChanged: onChanged,
      enabled: enabled,
      onCreate: onCreate,
    );
  }
}

class CustomerFieldContent extends StatefulWidget {
  final FieldEntity fieldEntity;
  final bool enabled;
  final Function(CustomerEntity) onChanged;
  final Function()? onCreate;

  const CustomerFieldContent({
    Key? key,
    required this.fieldEntity,
    required this.onChanged,
    required this.enabled,
    this.onCreate,
  }) : super(key: key);

  @override
  State<CustomerFieldContent> createState() => _CustomerFieldContentState();
}

class _CustomerFieldContentState extends State<CustomerFieldContent> {
  final TextEditingController controllerSearch = TextEditingController();

  CustomerEntity customerEntity = CustomerEntity.empty();
  List<CustomerEntity> listData = [];

  final CustomerCubit customerCubit = locator();
  final GetCustomer getCustomer = locator();

  CustomerEntity? selectedItem;
  bool enabled = true;

  @override
  void initState() {
    BlocProvider.of<CustomerCubit>(context).load("");

    enabled = widget.enabled;
    super.initState();
  }

  Future<List<CustomerEntity>> _getData(filter) async {
    List<CustomerEntity> listData = [];
    final data = await getCustomer.call(CustomerParams(
      searchText: filter,
      page: 1,
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
        child: BlocConsumer<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerLoaded) {
              listData = state.data;
              selectedItem = listData.firstWhereOrNull(
                      (e) => e.id == widget.fieldEntity.val) ??
                  listData.first;
              widget.fieldEntity.val = selectedItem?.id;
              Future.delayed(
                Duration.zero,
                () {
                  if (mounted) {
                    widget.onChanged.call(selectedItem!);
                  }
                },
              );
              customerCubit.init();
            }
            if (state is CustomerSaved) {
              if (mounted) {
                Future.delayed(
                  Duration.zero,
                  () => setState(() {
                    listData.insert(0, state.data);
                  }),
                );
              }

              customerCubit.init();
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fullName,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.phoneNumber.replaceAll("+", ""),
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },

                containerBuilder: (context, popupWidget) {
                  return Column(
                    children: [
                      Expanded(child: popupWidget),
                      InkWell(
                        onTap: () {
                          final fields = Map<String, FieldEntity<dynamic>>.from(
                              CustomerEntity.empty().getFields());
                          BlocProvider.of<DataFormCubit>(context)
                              .editData(fields);

                          // FocusManager.instance.primaryFocus?.unfocus();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DataPage(
                                onExit: () {
                                  BlocProvider.of<CustomerCubit>(context)
                                      .load("");
                                },
                                saveData: () {
                                  BlocProvider.of<CustomerCubit>(context).save(
                                    customer: CustomerEntity.fromFields(),
                                  );
                                  widget.onCreate?.call();
                                },
                              ),
                            ),
                          );
                        },
                        child: Ink(
                          color: Colors.orange,
                          height: 56,
                          child: Center(
                            child: Text(
                              'Add'.tr(),
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  enabledBorder: widget.fieldEntity.isRequired
                      ? const OutlineInputBorder(
                          borderSide: BorderSide(
                          color: Colors.green,
                        ))
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                  labelText: "customer".tr().toUpperCase(),
                  hintText: "Выберите пользователя",
                ),
              ),
              onChanged: (CustomerEntity? data) {
                log("Data $data");

                widget.fieldEntity.val = data?.id;

                if (data != null) {
                  widget.onChanged(data);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
