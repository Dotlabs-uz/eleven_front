import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/products/domain/usecases/filial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/products/domain/entity/filial_entity.dart';
import '../../features/products/presensation/cubit/filial/filial_cubit.dart';
import '../../get_it/locator.dart';
import '../entities/field_entity.dart';

class FilialFieldWidget extends StatefulWidget {
  const FilialFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.onChange,
    this.enabled = true,
    this.elementId,
  }) : super(key: key);
  final bool enabled;
  final FieldEntity fieldEntity;
  final Function(FilialEntity)? onChange;
  final int? elementId;

  @override
  State<FilialFieldWidget> createState() => _FilialFieldWidgetState();
}

class _FilialFieldWidgetState extends State<FilialFieldWidget> {
  late FilialCubit filialCubit;
  @override
  void initState() {
    filialCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => filialCubit,
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
  final Function(FilialEntity)? onChange;
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

  FilialEntity serviceEntity = FilialEntity.empty();
  List<FilialEntity> listData = [];

  final FilialCubit filialCubit = locator();
  final GetFilials getCustomer = locator();

  FilialEntity? selectedItem;
  bool enabled = true;

  @override
  void initState() {
    initialize();
    // listenController();

    super.initState();
  }

  initialize() {
    BlocProvider.of<FilialCubit>(context).load(
      search: "",
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

  Future<List<FilialEntity>> _getData(filter) async {
    List<FilialEntity> listData = [];
    final data = await getCustomer.call(GetFilialParams(
      searchText: filter,
      page: 1,
    ));

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
        child: BlocConsumer<FilialCubit, FilialState>(
          listener: (context, state) {
            if (state is FilialLoaded) {
              listData = state.result.results;

              if (widget.fieldEntity.val != null ) {


                // log("Widget.field ${widget.fieldEntity.val}");
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

              filialCubit.init();
            }
            if (state is FilialSaved) {
              if (mounted) {
                Future.delayed(
                  Duration.zero,
                  () => setState(() {
                    listData.insert(0, state.data);
                  }),
                );
              }

              filialCubit.init();
            }
          },
          builder: (context, state) {
            return DropdownSearch<FilialEntity>(
              items: listData,
              enabled: enabled,

              asyncItems: (text) async {
                if (text.isNotEmpty) {
                  return _getData(text);
                }
                return [];
              },
              itemAsString: (FilialEntity c) => c.name,
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
                  labelText: "filial".tr().toUpperCase(),
                  hintText: "filial".tr(),
                ),
              ),
              onChanged: (FilialEntity? data) {
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
