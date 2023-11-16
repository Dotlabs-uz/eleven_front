import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/assets.dart';
import '../../../../get_it/locator.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../../products/presensation/cubit/service_product_category/service_product_category_cubit.dart';
import '../cubit/select_services/select_services_cubit.dart';
import '../cubit/show_select_services/show_select_services_cubit.dart';

class SelectServiceDialogWidget extends StatefulWidget {
  const SelectServiceDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectServiceDialogWidget> createState() =>
      _SelectServiceDialogWidgetState();
}

class _SelectServiceDialogWidgetState extends State<SelectServiceDialogWidget> {
  List<ServiceProductCategoryEntity> listServiceCategories = [];
  List<ServiceProductEntity> listSelectedServices = [];

  late SelectServicesCubit selectServicesCubit;

  static bool isFirstTime = true;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    selectServicesCubit = locator();
    BlocProvider.of<ServiceProductCategoryCubit>(context)
        .load("", fetchGlobal: isFirstTime);

    isFirstTime = false;
  }

  addGlobalSelectedServicesToLocal(List<ServiceProductEntity> listData) {
    if (mounted) {
      Future.delayed(
        Duration.zero,
        () {
          setState(() => listSelectedServices = listData);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowSelectServicesCubit, ShowSelectedServiceHelper>(
      builder: (context, state) {
        addGlobalSelectedServicesToLocal(state.selectedServices);

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
                          onTap: () =>
                              BlocProvider.of<ServiceProductCategoryCubit>(
                                      context)
                                  .load(
                            "",
                            fetchGlobal: true,
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () =>
                              BlocProvider.of<ShowSelectServicesCubit>(context)
                                  .disable(),
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
                    child: BlocConsumer<ServiceProductCategoryCubit,
                        ServiceProductCategoryState>(
                      listener: (context, state) {
                        if (state is ServiceProductCategoryLoaded) {
                          if (mounted) {
                            Future.delayed(
                              Duration.zero,
                              () {
                                setState(() {
                                  listServiceCategories = state.data;
                                });
                              },
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is ServiceProductCategoryLoading) {
                          return LoadingCircle();
                        }

                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = listServiceCategories[index];

                            // return const SizedBox();
                            return Column(
                              children: [
                                _serviceProductCategoryCard(category.name),
                                const SizedBox(height: 10),
                                GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      category.services.length, (index) {
                                    final service = category.services[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (listSelectedServices
                                            .contains(service)) {
                                          BlocProvider.of<SelectServicesCubit>(
                                            context,
                                          ).remove(service: service);
                                        } else {
                                          BlocProvider.of<SelectServicesCubit>(
                                            context,
                                          ).save(service: service);
                                        }
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, right: 10),
                                        child: _ServiceProductCard(
                                          isSelected: listSelectedServices
                                              .contains(service),
                                          color: service.sex == "men"
                                              ? Colors.blue
                                              : Colors.pink,
                                          item: service,
                                          image: Assets.tLogo,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
                          itemCount: listServiceCategories.length,
                        );
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
  static bool isSelected = false;

  @override
  void didUpdateWidget(covariant _ServiceProductCard oldWidget) {
    if (isSelected != widget.isSelected) {
      isSelected = widget.isSelected;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.black45.withOpacity(0.4) : widget.color,
        borderRadius: BorderRadius.circular(8),

      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0.3, child: Image.asset(widget.image, fit: BoxFit.cover,)),
        if(!widget.isSelected)  Container(decoration: BoxDecoration(
            color: widget.color.withOpacity(0.4),

          ),),
          Column(
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
              const SizedBox(height: 10),
              Text(
                "${widget.item.duration} мин",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
