import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/customer_field_widget.dart';
import 'package:eleven_crm/core/components/data_double_field_widget.dart';
import 'package:eleven_crm/core/components/data_text_field_widget.dart';
import 'package:eleven_crm/core/components/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/main/presensation/cubit/data_form/data_form_cubit.dart';
import '../entities/field_entity.dart';
import 'button_widget.dart';
import 'header_text.dart';

class DataPage extends StatelessWidget {
  const DataPage({
    Key? key,
    required this.saveData,
    this.onExit,
  }) : super(key: key);

  final Function() saveData;
  final Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            onExit?.call();
          },
        ),
        backgroundColor: Colors.blue,
        title: BlocBuilder<DataFormCubit, DataFormState>(
          builder: (context, state) {
            if (state is DataFormLoadedData) {
              return Row(children: [
                Expanded(child: HeaderText("ID: ${state.fields["id"]?.val}")),
              ]);
            }
            return const Text('Add').tr();
          },
        ),
      ),
      body: BlocBuilder<DataFormCubit, DataFormState>(
        builder: (context, state) {
          if (state is DataFormLoadedData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (!ResponsiveBuilder.isMobile(context))
                    const Expanded(flex: 1, child: SizedBox.shrink()),
                  Expanded(
                    flex: 1,
                    child: DataFormWidget(
                      closeForm: () => Navigator.pop(context),
                      // fields: state.fields,
                      saveData: saveData,
                      onExit: () => onExit?.call(),
                    ),
                  ),
                  if (!ResponsiveBuilder.isMobile(context))
                    const Expanded(flex: 1, child: SizedBox.shrink()),
                ],
              ),
            );
          }
          return const Text("No data ");
        },
      ),
    );
  }
}

class DataFormContentWidget extends StatefulWidget {
  final List<Widget> listWidget;

  final Function()? onExit;

  const DataFormContentWidget({
    Key? key,
    this.onExit,
    required this.listWidget,
  }) : super(key: key);

  @override
  State<DataFormContentWidget> createState() => _DataFormContentWidgetState();
}

class _DataFormContentWidgetState extends State<DataFormContentWidget> {
  Color pickerColor = Colors.red;
  late TextEditingController nameCotroller;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.listWidget,
        ),
      ),
    );
  }
}

class DataFormWidget extends StatefulWidget {
  final Function() saveData;
  final Function() closeForm;
  final Function()? onExit;
  final String? title;

  const DataFormWidget({
    Key? key,
    required this.saveData,
    required this.closeForm,
    this.onExit,
    this.title,
  }) : super(key: key);

  @override
  State<DataFormWidget> createState() => DataFormWidgetState();
}

class DataFormWidgetState extends State<DataFormWidget> {
  List<Widget> ctrlWidgets = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataFormCubit, DataFormState>(
      builder: (context, state) {
        if (state is DataFormLoadedData) {
          debugPrint("data form loadled ${state.fields.entries.first} ");
          _setParams(state.fields, widget.closeForm, widget.saveData);

          return DataFormContentWidget(
            listWidget: ctrlWidgets,
          );
        }
        return const SizedBox();
        // return Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Row(
        //     children: [
        //       if (!ResponsiveBuilder.isMobile(context))
        //         const Expanded(flex: 1, child: SizedBox.shrink()),
        //       Expanded(
        //         flex: 1,
        //         child: DataFormWidget(
        //           closeForm: () => Navigator.pop(context),
        //           fields: fields,
        //           saveData: saveData,
        //           onExit: () => onExit?.call(),
        //         ),
        //       ),
        //       if (!ResponsiveBuilder.isMobile(context))
        //         const Expanded(flex: 1, child: SizedBox.shrink()),
        //     ],
        //   ),
        // );
      },
    );
  }

  void _setParams(Map<String, FieldEntity> fields, Function() closeForm,
      Function() saveData) {
    ctrlWidgets.clear();
    ctrlWidgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 30,
          // width: 35,
          decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: BorderRadius.circular(50),
            // border: Border.all(color: Colors.white, width: 3),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                "${widget.title ?? "element".tr()} № ${fields['id']?.val ?? 0}",
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: closeForm,
          child: Text(
            'close'.tr(),
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    ));
    fields.forEach((key, field) {
      if (field.isForm) {
        const SizedBox(height: 5);
        if (field.label == 'id') {
        } else {
          if (field.type == Types.customers) {
            ctrlWidgets.add(CustomerFieldWidget(
              fieldEntity: field,
              onChanged: (val) {},
            ));
          } else if (field.type == Types.string) {
            ctrlWidgets.add(DataTextFieldWidget(
              fieldEntity: field,
            ));
          } else if (field.type == Types.double) {
            ctrlWidgets.add(DataDoubleFieldWidget(
              fieldEntity: field,
            ));
          } else if (field.type == Types.int) {
            ctrlWidgets.add(DataDoubleFieldWidget(
              fieldEntity: field,
            ));
          }
        }
      }
    });
    ctrlWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ButtonWidget(
          text: "save",
          onPressed: () => saveData.call(),
        ),
      ),
    );
  }
}

// [
//   // LabelFieldWidget(
//   //   label: "name".tr(),
//   //   hintText: "enterName".tr(),
//   //   controller: nameCotroller,
//   // ),
//   // LabelFieldWidget(
//   //   label: "description".tr(),
//   //   hintText: "enterDescription".tr(),
//   //   controller: descriptionController,
//   // ),
//   // const SizedBox(height: kSpacing),
//   // ElevatedButton(
//   //   onPressed: () {
//   //     showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           titlePadding: const EdgeInsets.all(0),
//   //           contentPadding: const EdgeInsets.all(0),
//   //           content: SingleChildScrollView(
//   //             child: MaterialPicker(
//   //               pickerColor: pickerColor,
//   //               onColorChanged: (color) {
//   //                 setState(() {
//   //                   //debugPrint("Colro selected $color");
//   //                   pickerColor = color;
//   //                 });
//   //               },
//   //               enableLabel: false,
//   //               portraitOnly: false,
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //   },
//   //   style: ElevatedButton.styleFrom(
//   //     primary: pickerColor,
//   //     shadowColor: pickerColor.withOpacity(1),
//   //     elevation: 10,
//   //   ),
//   //   child: Text(
//   //     'enterColor'.tr(),
//   //     style: TextStyle(
//   //         color: useWhiteForeground(pickerColor)
//   //             ? Colors.white
//   //             : Colors.black),
//   //   ),
//   // ),
//   const SizedBox(height: kSpacing),
//   Button(
//     text: "save".tr(),
//     onPressed: () {
//       // widget.expensetypeCubit.save(
//       //   expenseType: widget.expensetypeEntity.param(
//       //     name: nameCotroller.text,
//       //     color: pickerColor,
//       //     description: descriptionController.text,
//       //   ),
//       // );
//     },
//   ),
// ],
