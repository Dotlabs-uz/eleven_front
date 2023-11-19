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
import '../utils/app_colors.dart';
import '../utils/assets.dart';

class BarberFieldMultiSelectWidget extends StatefulWidget {
  const BarberFieldMultiSelectWidget({
    Key? key,
    required this.fieldEntity,
    this.onChange,
    this.elementId,
    this.enabled = true,

  }) : super(key: key);
  final bool enabled;
  final FieldEntity fieldEntity;
  final Function(List<String>)? onChange;
  final String? elementId;

  @override
  State<BarberFieldMultiSelectWidget> createState() => _BarberFieldMultiSelectWidgetState();
}

class _BarberFieldMultiSelectWidgetState extends State<BarberFieldMultiSelectWidget> {
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
  final Function(List<String>)? onChange;
  final String? elementId;

  const _ContentWidget({
    Key? key,
    required this.fieldEntity,
    this.onChange,
    required this.enabled,
    required this.elementId,
  }) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  final TextEditingController controllerSearch = TextEditingController();

  BarberEntity serviceEntity = BarberEntity.empty();
  List<BarberEntity> listData = [];
    List<BarberEntity> listSelectedBarbers = [];

  final BarberCubit filialCubit = locator();
  final GetBarber getBarbers = locator();

  bool enabled = true;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {

    BlocProvider.of<BarberCubit>(context).load(
      "",
    );

    enabled = widget.enabled;
  }

  static String previousId = "";

  @override
  void didUpdateWidget(_ContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.elementId != null) {
      final String newId = widget.elementId!;

      if (newId != previousId) {
        previousId = newId;
        initialize();
      }
    }
  }

  initializeSelectedList(List<BarberEntity> listData) {


    final  List<String> listIds = List.from(widget.fieldEntity.val);



    print("List id's ${listIds}");
    print("List data len ${listData.length}");


    for (var element in listData) {


      print("listIds.contains(element.id) ${listIds.contains(element.id)}");
      print("Element id ${element.id}");
      if(listIds.contains(element.id)) {
        listSelectedBarbers.add(element);
      }



    }


    print("List element ${listSelectedBarbers.length}");



    setState(() {

    });
    return listSelectedBarbers;
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

              listData.removeWhere((element) => element.isCurrentFilial == false);

              if (widget.fieldEntity.val != null) {

              listSelectedBarbers =   initializeSelectedList(listData);

              }

              filialCubit.init();
            }
          },
          builder: (context, state) {
            return DropdownSearch<BarberEntity>.multiSelection(
              items: listData,
              enabled: enabled,

              asyncItems: (text) async {
                if (text.isNotEmpty) {
                  return _getData(text);
                }
                return [];
              },
              itemAsString: (BarberEntity c) => "${c.firstName} ${c.lastName}",
              selectedItems: listSelectedBarbers ,



              popupProps: PopupPropsMultiSelection.menu(
                showSelectedItems: true,
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
                validationWidgetBuilder: (context, item){
                  return Row(children: [...item.map((e) => Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Text(
                      "${e.firstName} ${e.lastName}",
                      style: TextStyle(
                      ),


                    ),
                  ))],);

                },
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
              onChanged: (List<BarberEntity>? data) {
                log("Data $data");

                if (data != null) {

                  listSelectedBarbers = data;
                  final List<String > listData = List.from(widget.fieldEntity.val );
                  for (var element in listSelectedBarbers) {

                    if(!listData.contains(element.id))  {
                      listData.add(element.id);
                    }
                  }

                  widget.fieldEntity.val   = listData;

                  widget.onChange?.call(listData);
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
