// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/customer_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientSearchWidget extends StatefulWidget {
  final Function(String) onNameChanged;
  final Function(int) onPhoneChanged;
  final String label;
  final String clientName;
  final int clientPhone;

  const ClientSearchWidget({
    Key? key,
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
    super.dispose();
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
            Text(widget.label, style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Nunito",
            ),),

            const SizedBox(height: 10),
            BlocBuilder<CustomerCubit, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoaded) {
                  listCustomers = state.data;
                }
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: SearchAnchor(
                          searchController: searchControllerName,
                          viewShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          viewConstraints:
                              const BoxConstraints(maxWidth: 130, minWidth: 130),
                          builder:
                              (BuildContext context, SearchController controller) {
                            return SearchBar(
                              trailing: [],
                              controller: controller,
                              backgroundColor:
                              MaterialStateProperty.all(  Colors.white),
                              hintText: "name".tr(),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStatePropertyAll<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Colors.black26
                                  ),
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
                              onChanged: (nameQuery) => controller.openView(),
                              leading: const SizedBox(),
                            );
                          },
                          suggestionsBuilder:
                              (BuildContext context, SearchController controller)   {

                            widget.onNameChanged.call(controller.text);
                            BlocProvider.of<CustomerCubit>(context)
                                .load(controller.text);



                            return List<ListTile>.generate(listCustomers.length,
                                (int index) {
                              final CustomerEntity item = listCustomers[index];

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
                                  });
                                },
                              );
                            });
                          },
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
                          viewConstraints:
                          const BoxConstraints(maxWidth: 130, minWidth: 130),
                          builder:
                              (BuildContext context, SearchController controller) {
                            return SearchBar(
                              trailing: [],
                              controller: controller,
                              hintText: "phone".tr(),

                              backgroundColor:
                                  MaterialStateProperty.all(  Colors.white),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStatePropertyAll<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1,
                                      color: Colors.black26
                                  ),
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
                              onChanged: (phoneQuery) {
                                print("Phone query $phoneQuery");

                                controller.openView();
                                BlocProvider.of<CustomerCubit>(context)
                                    .load("&phone=$phoneQuery");


                              },
                              leading: const SizedBox(),
                            );
                          },
                          suggestionsBuilder:
                              (BuildContext context, SearchController controller) {
                                widget.onPhoneChanged.call(int.parse(controller.text));

                                BlocProvider.of<CustomerCubit>(context)
                                .load(controller.text);

                            return List<ListTile>.generate(listCustomers.length,
                                (int index) {
                              final CustomerEntity item = listCustomers[index];

                              return ListTile(
                                title: FittedBox(
                                  child: Text(
                                    item.phoneNumber.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    controller
                                        .closeView(item.phoneNumber.toString());
                                    searchControllerName.text = item.fullName;
                                    print("search controller name ${item.fullName}")
;                                    widget.onPhoneChanged.call(item.phoneNumber);

                                  });
                                },
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
