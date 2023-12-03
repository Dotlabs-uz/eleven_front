import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/core/utils/constants.dart';
import 'package:eleven_crm/features/main/domain/entity/order_for_client_history_entity.dart';
import 'package:eleven_crm/features/main/presensation/cubit/show_client_orders_history/show_client_orders_history_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientOrdersHistoryMenuWidget extends StatefulWidget {
  const ClientOrdersHistoryMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ClientOrdersHistoryMenuWidget> createState() =>
      _ClientOrdersHistoryMenuWidgetState();
}

class _ClientOrdersHistoryMenuWidgetState
    extends State<ClientOrdersHistoryMenuWidget> {
  static bool isFirstTime = true;

  @override
  void initState() {
    isFirstTime = true;
    super.initState();
  }

  @override
  void dispose() {
    isFirstTime = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowClientOrdersHistoryCubit,
        ShowClientOrdersHistoryHelper>(
      builder: (context, state) {
        if (isFirstTime) {
          BlocProvider.of<CustomerCubit>(context).loadCustomer(state.clientId);

          isFirstTime = false;
        }
        return Container(
          width: MediaQuery.of(context).size.width - Constants.sideMenuWidth - Constants.orderFormWidth,
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
          child: BlocBuilder<CustomerCubit, CustomerState>(
            builder: (context, state) {
              if (state is CustomerByIdLoaded) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    _topSection(context),
                    const SizedBox(height: 20),
                    ...state.entity.orders.map((e) => _HistoryItem(entity: e)),
                  ],
                );
              }

              return const Center(
                child: LoadingCircle(),
              );
            },
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
              BlocProvider.of<ShowClientOrdersHistoryCubit>(context).disable();
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xff6750A4),
            ),
          ),
          Text(
            "clientOrdersHistory".tr(),
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

class _HistoryItem extends StatelessWidget {
  final OrderForClientEntity entity;
  const _HistoryItem({
    Key? key,
    required this.entity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffF3F1F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              DateFormat("yyyy-MM-dd hh:mm:ss").format(entity.createdAt),
            ),
          ),
          Flexible(
            child: Text("${entity.barberName} | ${entity.barberPhone}"),
          ),
          ...entity.services.map(
            (e) => Flexible(child: Text(e.name)),
          ),
          Flexible(
            child: Text("${entity.price}сум | ${entity.duration}мин"),
          ),
          if (entity.fromSite)
            const Icon(
              Icons.cloud,
              color: Colors.black,
            ),
        ],
      ),
    );
  }
}
