// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/services/debouncer_service.dart';
import 'package:eleven_crm/core/utils/field_formatters.dart';
import 'package:eleven_crm/features/management/domain/entity/customer_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientSearchWidget extends StatefulWidget {
  final Function(String) onNameChanged;
  final Function(int) onPhoneChanged;
  final Function() onHistoryTap;
  final bool enableHistoryButton;
  final String label;
  final String clientName;
  final int clientPhone;

  const ClientSearchWidget({
    Key? key,
    required this.enableHistoryButton,
    required this.onHistoryTap,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.clientPhone,
    required this.clientName,
    required this.label,
  }) : super(key: key);

  @override
  State<ClientSearchWidget> createState() => _ClientSearchWidgetState();
}

class _ClientSearchWidgetState extends State<ClientSearchWidget> {
  List<CustomerEntity> listCustomers = [];
  final SearchController searchControllerName = SearchController();
  final SearchController searchControllerPhone = SearchController();
  final _debouncer = DebouncerService(milliseconds: 400);

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    BlocProvider.of<CustomerCubit>(context).load("");
    searchControllerName.text = widget.clientName;
    searchControllerPhone.text = widget.clientPhone.toString();
  }

  @override
  void dispose() {
    searchControllerName.dispose();
    searchControllerPhone.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  _update() {
    if (mounted) {
      Future.delayed(
        Duration.zero,
        () {
          setState(() {
            if (listCustomers.length == 1) {
              final element = listCustomers.first;
              widget.onNameChanged.call(element.fullName);
              widget.onPhoneChanged.call(element.phoneNumber);
              searchControllerName.text = element.fullName;
              searchControllerPhone.text = element.phoneNumber.toString();

            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: false,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF3F1F8),
          border: Border.all(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.enableHistoryButton)
                  IconButton(
                    onPressed: () {
                      widget.onHistoryTap.call();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                  ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Nunito",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: SearchAnchor(
                      searchController: searchControllerName,
                      viewShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      viewConstraints: const BoxConstraints(
                        maxWidth: 130,
                        minWidth: 130,
                        maxHeight: 400,
                      ),
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          trailing: [],
                          controller: controller,
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          hintText: "name".tr(),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          side: const MaterialStatePropertyAll<BorderSide>(
                            BorderSide.none,
                          ),
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          ),
                          onTap: () {
                            controller.openView();
                            BlocProvider.of<CustomerCubit>(context)
                                .load(controller.text);
                          },
                          onChanged: (nameQuery) => controller.openView(),
                          leading: const SizedBox(),
                          inputFormatters: [],
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        _debouncer(() {
                          widget.onNameChanged.call(controller.text);
                          BlocProvider.of<CustomerCubit>(context)
                              .load(controller.text);
                        });

                        return BlocBuilder<CustomerCubit, CustomerState>(
                          builder: (context, state) {
                            print("state $state");
                            if (state is CustomerLoaded) {
                              listCustomers = state.data;
                              print("List customers ${listCustomers.length}");

                              _update();

                              BlocProvider.of<CustomerCubit>(context).init();
                            }

                            return ListView(
                              children: List<ListTile>.generate(
                                  listCustomers.length, (int index) {
                                final CustomerEntity item =
                                    listCustomers[index];

                                return ListTile(
                                  title: Text(
                                    item.fullName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      controller.closeView(item.fullName);
                                      searchControllerPhone.text =
                                          item.phoneNumber.toString();

                                      widget.onNameChanged.call(item.fullName);
                                      widget.onPhoneChanged
                                          .call(item.phoneNumber);
                                    });
                                  },
                                );
                              }),
                            );
                          },
                        );
                      },
                      listItemInMenu: listCustomers,
                      inputFormatters: [],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: SearchAnchor(
                      searchController: searchControllerPhone,
                      viewShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      viewConstraints: const BoxConstraints(
                        maxWidth: 130,
                        minWidth: 130,
                        maxHeight: 400,
                      ),
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          trailing: [],
                          controller: controller,
                          hintText: "phone".tr(),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          side: const MaterialStatePropertyAll<BorderSide>(
                            BorderSide.none,
                          ),
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          ),
                          onTap: () => controller.openView(),
                          onChanged: (phoneQuery) => controller.openView(),
                          leading: const SizedBox(),
                          inputFormatters: [FieldFormatters.phoneMaskFormatter],
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {

                        if(controller.text.isEmpty)  {
                          controller.text = "998";
                        }
                        _debouncer(() {
                          widget.onPhoneChanged
                              .call(int.parse(FieldFormatters.phoneMaskFormatter.unmaskText(controller.text)));


                          // controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);

                          BlocProvider.of<CustomerCubit>(context)
                              .load("&phone=${controller.text}");
                        });

                        return BlocBuilder<CustomerCubit, CustomerState>(
                          builder: (context, state) {
                            if (state is CustomerLoaded) {
                              listCustomers = state.data;

                              _update();

                              BlocProvider.of<CustomerCubit>(context).init();
                            }
                            return ListView(
                              shrinkWrap: true,
                              children: List<ListTile>.generate(
                                  listCustomers.length, (int index) {
                                final CustomerEntity item =
                                    listCustomers[index];

                                return ListTile(
                                  title: FittedBox(
                                    child: Text(
                                      FieldFormatters.phoneMaskFormatter.maskText(item.phoneNumber.toString().replaceAll("998", "")),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      controller.closeView(

                                          FieldFormatters.phoneMaskFormatter.maskText(item.phoneNumber.toString().replaceAll("998", ""))
                                          );
                                      searchControllerName.text = item.fullName;
                                      print(
                                          "search controller name ${item.fullName}");
                                      widget.onPhoneChanged
                                          .call(item.phoneNumber);

                                      widget.onNameChanged.call(item.fullName);
                                    });
                                  },
                                );
                              }),
                            );
                          },
                        );
                      },
                      listItemInMenu: listCustomers,
                      inputFormatters: [FieldFormatters.phoneMaskFormatter],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
