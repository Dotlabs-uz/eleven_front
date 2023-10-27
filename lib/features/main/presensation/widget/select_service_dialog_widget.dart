import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:eleven_crm/features/products/presensation/cubit/service_product_category/service_product_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../core/utils/assets.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../cubit/select_services/select_services_cubit.dart';
import '../cubit/show_select_services/show_select_services_cubit.dart';

class SelectServiceDialogWidget extends StatefulWidget {
  const SelectServiceDialogWidget({Key? key}) : super(key: key);

  @override
  State<SelectServiceDialogWidget> createState() =>
      _SelectServiceDialogWidgetState();
}

class _SelectServiceDialogWidgetState extends State<SelectServiceDialogWidget> {
  List<ServiceProductEntity> listSelectedServices = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    BlocProvider.of<ServiceProductCategoryCubit>(context).load(
      "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowSelectServicesCubit, ShowSelectedServiceHelper>(
      builder: (context, state) {
        if (state.show == true) {
          if (mounted) {
            Future.delayed(
              Duration.zero,
              () {
                setState(() {
                  listSelectedServices.addAll(state.selectedServices);
                });
              },
            );
          }
        }

        return Container(
          color: Colors.black.withOpacity(0.4),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 600,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<ShowSelectServicesCubit>(context)
                                .disable();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<ServiceProductCategoryCubit,
                        ServiceProductCategoryState>(
                      builder: (context, state) {
                        if (state is ServiceProductCategoryLoaded) {
                          final listData = state.data;
                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final category = listData[index];

                              // return const SizedBox();
                              return _serviceCategoryWidgetServices(category);
                            },
                            itemCount: listData.length,
                          );
                        }
                        return const LoadingCircle();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _serviceCategoryWidgetServices(
      ServiceProductCategoryEntity productCategoryEntity) {
    return Column(
      children: [
        _serviceProductCategoryCard(productCategoryEntity.name),
        const SizedBox(height: 10),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 10,
          ),
          shrinkWrap: true,
          itemCount: productCategoryEntity.services.length,
          itemBuilder: (BuildContext context, int index) {
            final item = productCategoryEntity.services[index];
            return GestureDetector(
              onTap: () {
                if (listSelectedServices.contains(item)) {
                  BlocProvider.of<SelectServicesCubit>(context).remove(
                    service: item,
                  );
                  listSelectedServices.remove(item);
                } else {
                  BlocProvider.of<SelectServicesCubit>(context).save(
                    service: item,
                  );
                  listSelectedServices.add(item);
                }
                setState(() {});
              },
              child: _ServiceProductCard(
                color: Colors.blue,
                item: item,
                image: Assets.tLogo,
                isSelected: listSelectedServices.contains(item),
              ),
            );
          },
        ),
      ],
    );
  }

  _serviceProductCategoryCard(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.blue,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _ServiceProductCard extends StatefulWidget {
  final Color color;
  final ServiceProductEntity item;
  final String image;
  final bool isSelected;

  const _ServiceProductCard({
    Key? key,
    required this.color,
    required this.item,
    required this.image,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<_ServiceProductCard> createState() => _ServiceProductCardState();
}

class _ServiceProductCardState extends State<_ServiceProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            widget.isSelected ? Colors.black45.withOpacity(0.4) : widget.color,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          opacity: 0.1,
          fit: BoxFit.cover,
          image: AssetImage(
            widget.image,
          ),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.item.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
