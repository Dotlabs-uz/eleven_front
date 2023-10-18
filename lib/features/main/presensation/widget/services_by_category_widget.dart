import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../products/domain/entity/service_product_category_entity.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../../products/presensation/cubit/service_product_category/service_product_category_cubit.dart';

class ServicesWithCategoriesWidget extends StatefulWidget {
  final Function(ServiceProductEntity) onSelect;
  final List<ServiceProductEntity> selectedItems;

  const ServicesWithCategoriesWidget(
      {Key? key, required this.onSelect, required this.selectedItems})
      : super(key: key);

  @override
  State<ServicesWithCategoriesWidget> createState() =>
      _ServicesWithCategoriesWidgetState();
}

class _ServicesWithCategoriesWidgetState
    extends State<ServicesWithCategoriesWidget> {
  List<ServiceProductCategoryEntity> serviceCategory = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProductCategoryCubit,
        ServiceProductCategoryState>(
      builder: (context, state) {
        if (state is ServiceProductCategoryLoaded) {
          serviceCategory = state.data;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...serviceCategory.map(
              (e) => _ServiceProductCategoryItemsWidget(
                entity: e,
                onSelect: widget.onSelect,
                listSelected: widget.selectedItems,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceProductCategoryItemsWidget extends StatefulWidget {
  final ServiceProductCategoryEntity entity;
  final Function(ServiceProductEntity) onSelect;
  final List<ServiceProductEntity> listSelected;
  const _ServiceProductCategoryItemsWidget({
    Key? key,
    required this.entity,
    required this.onSelect,
    required this.listSelected,
  }) : super(key: key);

  @override
  State<_ServiceProductCategoryItemsWidget> createState() =>
      _ServiceProductCategoryItemsWidgetState();
}

class _ServiceProductCategoryItemsWidgetState
    extends State<_ServiceProductCategoryItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            widget.entity.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...widget.entity.services.map((e) => _item(e)),
      ],
    );
  }

  Widget _item(ServiceProductEntity element) {
    return GestureDetector(
      onTap: () => widget.onSelect.call(element),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        color: widget.listSelected.contains(element)
            ? Colors.orange
            : Colors.white,
        child: Text(
          element.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
