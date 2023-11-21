import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/loading_circle.dart';
import '../../../../core/components/success_flash_bar.dart';
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
    List<ServiceProductEntity> listData = [];

  @override
  void initState() {
    BlocProvider.of<ServiceProductCubit>(context).load("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<ServiceProductCubit, ServiceProductState>(
          listener: (context, state) {
            if (state is ServiceProductLoaded) {
       listData =      state.data;


            }
            if (state is BarberServiceProductSaved) {
              SuccessFlushBar("change_success".tr()).show(context);
              BlocProvider.of<ServiceProductCubit>(context).load("");
            }  else if (state is ServiceProductError) {
              ErrorFlushBar("change_error".tr(args: [state.message]))
                  .show(context);
            }
          },
          builder: (context, state) {
            if (state is ServiceProductLoading) {
              return const LoadingCircle();
            }


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
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          _ServiceItem(
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
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                        ],
                      );
                    },
                  )
                ],
              ),
            );

          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ServiceProductCubit>(context)
                      .saveServicesToBarber(
                    services: listSelectedServices,
                    barberId: widget.barberEntity.id,
                  );

                  listSelectedServices.clear();

                },
                child: Text(
                  "save".tr(),
                ),
              ),
            ),
          ],
        ),
      ],
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
