import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/main/presensation/cubit/select_services/select_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/main/presensation/cubit/show_select_services/show_select_services_cubit.dart';
import '../../features/products/domain/entity/service_product_entity.dart';
import '../entities/field_entity.dart';

class SelectServicesWidget extends StatefulWidget {
  final FieldEntity fieldEntity;
  final Function(List<ServiceProductEntity>) onChanged;
  const SelectServicesWidget({
    Key? key,
    required this.onChanged,
    required this.fieldEntity,
  }) : super(key: key);

  @override
  State<SelectServicesWidget> createState() => SelectServicesWidgetState();
}

class SelectServicesWidgetState extends State<SelectServicesWidget> {
  final List<ServiceProductEntity> selectedServices = [];

  doSelectServiceActionByState(SelectServicesHelper state) {
    if (mounted) {
      Future.delayed(
        Duration.zero,
        () {
          final data = state.data;
          final action = state.action;

          if (data != null) {
            if (action == SelectedServicesAction.remove) {
              selectedServices.remove(data);
            }
            if (action == SelectedServicesAction.add) {
              selectedServices.add(data);
            }
          }

          widget.onChanged.call(selectedServices);
          // widget.fieldEntity.val = selectedServices;

          setState(() {});
          BlocProvider.of<SelectServicesCubit>(context).init();
        },
      );
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    print("Widget field entity ${widget.fieldEntity.val}");
    selectedServices.addAll(widget.fieldEntity.val);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<SelectServicesCubit, SelectServicesHelper>(
        builder: (context, state) {
          if (state.data != null) {
            doSelectServiceActionByState(state);
          }

          return Column(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    print("Selected services len ${selectedServices.length}");
                    BlocProvider.of<ShowSelectServicesCubit>(context)
                        .enable(selectedServices);
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.blueGrey.shade300,
                      //     Colors.blueGrey.shade200
                      //   ],
                      // ),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "selectServices".tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  children: List.generate(selectedServices.length, (index) {
                    final service = selectedServices[index];

                    return _serviceSelectedItem(service);
                  }),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  _serviceSelectedItem(ServiceProductEntity serviceProductEntity) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(
        color: serviceProductEntity.sex == "male" ? Colors.blue : Colors.pink,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        "${serviceProductEntity.name} ${"sex".tr()}:${serviceProductEntity.sex.tr()}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
