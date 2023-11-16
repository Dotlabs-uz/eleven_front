import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/usecases/barber.dart';
import 'package:eleven_crm/features/management/presentation/cubit/barber/barber_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/management/domain/entity/barber_entity.dart';
import '../../get_it/locator.dart';
import '../constants/drop_down_decoration.dart';
import '../entities/field_entity.dart';
import '../utils/assets.dart';

class BarberFieldWidget extends StatefulWidget {
  const BarberFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.onChange,
    this.enabled = true,
    this.elementId,
  }) : super(key: key);
  final bool enabled;
  final FieldEntity fieldEntity;
  final Function(BarberEntity)? onChange;
  final int? elementId;

  @override
  State<BarberFieldWidget> createState() => _BarberFieldWidgetState();
}

class _BarberFieldWidgetState extends State<BarberFieldWidget> {
  late BarberCubit barberCubit;
  @override
  void initState() {
    barberCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => barberCubit,
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
  final Function(BarberEntity)? onChange;
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

  BarberEntity serviceEntity = BarberEntity.empty();
  List<BarberEntity> listData = [];

  final BarberCubit filialCubit = locator();
  final GetBarber getBarbers = locator();

  BarberEntity? selectedItem;
  bool enabled = true;

  @override
  void initState() {
    initialize();
    // listenController();

    super.initState();
  }

  initialize() {
    BlocProvider.of<BarberCubit>(context).load(
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

  Future<List<BarberEntity>> _getData(filter) async {
    List<BarberEntity> listData = [];
    final data = await getBarbers.call(GetBarberParams(
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
        child: BlocConsumer<BarberCubit, BarberState>(
          listener: (context, state) {
            if (state is BarberLoaded) {
              listData = state.data.results;

              if (widget.fieldEntity.val != null) {
                selectedItem = listData
                    .firstWhereOrNull((e) => e.id == widget.fieldEntity.val);
listData.removeWhere((element) => element.isCurrentFilial == false);

                if (selectedItem != null) {
                  widget.fieldEntity.val = selectedItem!.id;
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
            return DropdownSearch<BarberEntity>(
              items: listData,
              enabled: enabled,

              asyncItems: (text) async {
                if (text.isNotEmpty) {
                  return _getData(text);
                }
                return [];
              },
              itemAsString: (BarberEntity c) => "${c.firstName} ${c.lastName}",
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 34,
                          width: 34,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: item.avatar.isEmpty
                                ? const DecorationImage(
                                    image: AssetImage(
                                      Assets.tAvatarPlaceHolder,
                                    ),
                                    fit: BoxFit.cover)
                                : DecorationImage(
                                    image: NetworkImage(
                                      item.avatar,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${item.firstName} ${item.lastName}",
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${item.phone}",
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                'barber'.tr(),
                "barber".tr().toUpperCase(),
                widget.fieldEntity.isRequired,
              ),
              onChanged: (BarberEntity? data) {
                log("Data $data");

                if (data != null) {
                  widget.fieldEntity.val = data.id;

                  widget.onChange?.call(data);
                } else {
                  print("Data == null");
                }
              },
            );
          },
        ),
      ),
    );
  }
}
