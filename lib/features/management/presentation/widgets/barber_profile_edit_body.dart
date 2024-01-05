import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/entities/field_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/barber/barber_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/button_widget.dart';
import '../../../../core/components/data_phone_number_field_widget.dart';
import '../../../../core/components/data_text_field_widget.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/filial_field_widget.dart';
import '../../../../core/components/success_flash_bar.dart';

class BarberProfileEditBody extends StatefulWidget {
  final BarberEntity barberEntity;
  const BarberProfileEditBody({Key? key, required this.barberEntity})
      : super(key: key);

  @override
  State<BarberProfileEditBody> createState() => _BarberProfileEditBodyState();
}

class _BarberProfileEditBodyState extends State<BarberProfileEditBody> {
  late Map<String, FieldEntity<dynamic>> fields;

  @override
  void initState() {
    fields = widget.barberEntity.getFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BarberCubit, BarberState>(
      listener: (context, state) {
        if (state is BarberSaved) {
          SuccessFlushBar("change_success".tr()).show(context);
        } else if (state is BarberError) {
          ErrorFlushBar("change_error".tr(args: [state.message])).show(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            DataTextFieldWidget(fieldEntity: fields['firstName']!),
            DataTextFieldWidget(fieldEntity: fields['lastName']!),
            // DataTextFieldWidget(fieldEntity: fields['login']!),
            // DataTextFieldWidget(fieldEntity: fields['password']!),
            FilialFieldWidget(fieldEntity: fields['filial']!),
            DataPhoneNumberFieldWidget(fieldEntity: fields['phone']!),
            const SizedBox(height: 10),
            ButtonWidget(
              text: "save".tr(),
              onPressed: () {
                final editedBarber =  BarberEntity.fromFields();
                BlocProvider.of<BarberCubit>(context)
                    .save(barber:editedBarber);

                },
            ),
          ],
        ),
      ),
    );
  }
}
