import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/loading_circle.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../../products/presensation/cubit/service_product/service_product_cubit.dart';

class BarberProfileServicesBody extends StatefulWidget {
  final BarberEntity barberEntity;
  const BarberProfileServicesBody({Key? key, required this.barberEntity})
      : super(key: key);

  @override
  State<BarberProfileServicesBody> createState() =>
      _BarberProfileServicesBodyState();
}

class _BarberProfileServicesBodyState extends State<BarberProfileServicesBody> {
  final List<ServiceProductEntity> listSelectedServices = [];

  @override
  void initState() {
    BlocProvider.of<ServiceProductCubit>(context).load("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProductCubit, ServiceProductState>(
      builder: (context, state) {
        if (state is ServiceProductLoaded) {
          final listData = state.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                ...listData.map(
                  (e) {
                    final barberHasInServices =
                        e.listBarberId.contains(widget.barberEntity.id);

                    if (barberHasInServices) {
                      listSelectedServices.add(e);
                    }
                    return _ServiceItem(
                      productEntity: e,
                      barberHasInServices: barberHasInServices,
                      onChangeChecker: (value) {
                        if (value) {
                          listSelectedServices.add(e);
                        } else {
                          if (listSelectedServices.contains(e)) {
                            listSelectedServices.remove(e);
                          }
                        }
                      },
                    );
                  },
                )
              ],
            ),
          );
        } else if (state is ServiceProductError) {
          return Center(child: Text(state.message));
        }
        return const LoadingCircle();
      },
    );
  }
}

class _ServiceItem extends StatefulWidget {
  final ServiceProductEntity productEntity;
  final bool barberHasInServices;
  final Function(bool)? onChangeChecker;
  const _ServiceItem(
      {Key? key,
      required this.productEntity,
      required this.barberHasInServices,
      this.onChangeChecker})
      : super(key: key);

  @override
  State<_ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<_ServiceItem> {
  bool barberHasInServices = false;
  @override
  void initState() {
    barberHasInServices = widget.barberHasInServices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.productEntity.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Checkbox(
          value: barberHasInServices,
          activeColor: AppColors.accent,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              barberHasInServices = value;
            });
            widget.onChangeChecker?.call(barberHasInServices);
          },
        ),
        SizedBox(
          width: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              const Text("|"),
              const SizedBox(width: 10),
              Text("${widget.productEntity.duration} мин"),
              const SizedBox(width: 10),
              const Text("|"),
              const SizedBox(width: 10),
              Text(
                widget.productEntity.sex.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
