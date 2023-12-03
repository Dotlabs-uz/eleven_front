import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/main/presensation/cubit/show_order_history/show_order_history_cubit.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../get_it/locator.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../../products/presensation/cubit/service_product_category/service_product_category_cubit.dart';
import '../cubit/select_services/select_services_cubit.dart';
import '../cubit/show_select_services/show_select_services_cubit.dart';

class OrderHistoryMenuWidget extends StatelessWidget {
  const OrderHistoryMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowOrderHistoryCubit, ShowOrderHistoryHelper>(
      builder: (context, state) {
        return Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(-10, 10),
                blurRadius: 16,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            children: [
              _topSection(context),
              const SizedBox(height: 20),
              _MessageOrderCardWidget(
                  dateTime: state.createdAt,
                  clientName: state.clientName,
                  clientPhone: state.clientPhone,
                  fromSite: state.fromSite,),
            ],
          ),
        );
      },
    );
  }

  _topSection(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xffF3F1F9),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              BlocProvider.of<ShowOrderHistoryCubit>(context).disable();
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xff6750A4),
            ),
          ),
          Text(
            "orderHistory".tr(),
            style: const TextStyle(
              color: Color(0xff6750A4),
              fontFamily: "Nunito",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageOrderCardWidget extends StatefulWidget {
  final DateTime dateTime;
  final String clientName;
  final String clientPhone;
  final bool fromSite;
  const _MessageOrderCardWidget({
    Key? key,
    required this.dateTime,
    required this.clientName,
    required this.clientPhone,
    required this.fromSite,
  }) : super(key: key);

  @override
  State<_MessageOrderCardWidget> createState() =>
      _MessageOrderCardWidgetState();
}

class _MessageOrderCardWidgetState extends State<_MessageOrderCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffF3F1F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topSelection(),
          SizedBox(height: 5),
          Text(
            "${widget.clientName} ${widget.clientPhone}",
            style: const TextStyle(
              color: Color(0xff6750A4),
              fontFamily: "Nunito",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.fromSite)
            Text(
              "clientCreatedOrderFromSite".tr(),
              style: const TextStyle(
                color: Color(0xff6750A4),
                fontFamily: "Nunito",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  _topSelection() {
    return Text(
      "${"createdAt".tr()} ${DateFormat("yyyy-MM-dd hh:mm:ss").format(widget.dateTime)}",
      style: const TextStyle(
        color: Color(0xff6750A4),
        fontFamily: "Nunito",
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
