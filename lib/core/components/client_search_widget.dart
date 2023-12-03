// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:eleven_crm/features/management/domain/entity/customer_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../utils/assets.dart';

class ClientSearchWidget extends StatefulWidget {
  final Function(String) onNameSubmit;
  final Function(String) onPhoneSubmit;
  final String label;

  const ClientSearchWidget({
    Key? key,
    required this.onNameSubmit,
    required this.onPhoneSubmit,
    required this.label,
  }) : super(key: key);

  @override
  State<ClientSearchWidget> createState() => _ClientSearchWidgetState();
}

class _ClientSearchWidgetState extends State<ClientSearchWidget> {
  List<String> listPhones = [];
  List<String> listNames = [];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: false,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Text(widget.label),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (context, state) {
                    if (state is CustomerLoaded) {
                      listNames =
                          state.data.map((e) => e.fullName.toString()).toList();
                    }

                    return SearchAnchor(
                      viewShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      viewConstraints:
                          const BoxConstraints(maxWidth: 100, minWidth: 100),
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          trailing: [],

                          controller: controller,
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
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
                          onSubmitted: (nameQuery) {
                            print("Name query $nameQuery");
                            BlocProvider.of<CustomerCubit>(context)
                                .load(nameQuery);
                          },
                          leading: const SizedBox(),
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {

                        return List<ListTile>.generate(listNames.length, (int index) {
                          final String item = listNames[index];

                          return ListTile(
                            title: FittedBox(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                controller.closeView(item);
                              });
                            },
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (context, state) {
                    if (state is CustomerLoaded) {
                      listPhones = state.data
                          .map((e) => e.phoneNumber.toString())
                          .toList();
                    }

                    return SearchAnchor(
                      viewShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      viewConstraints:
                          const BoxConstraints(maxWidth: 100, minWidth: 100),
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          trailing: [],
                          controller: controller,
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
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
                            controller.openView();
                            BlocProvider.of<CustomerCubit>(context)
                                .load("&phone=$phoneQuery");
                          },
                          leading: const SizedBox(),
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        return List<ListTile>.generate(listPhones.length,
                            (int index) {
                          final String item = listPhones[index];
                          return ListTile(
                            title: FittedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                controller.closeView(item);
                              });
                            },
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
