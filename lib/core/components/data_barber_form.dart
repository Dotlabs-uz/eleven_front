import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/main/presensation/cubit/avatar/avatar_cubit.dart';
import '../entities/field_entity.dart';
import '../utils/assets.dart';
import 'button_widget.dart';
import 'data_phone_number_field_widget.dart';
import 'data_text_field_widget.dart';
import 'filial_field_widget.dart';

class DataBarberForm extends StatefulWidget {
  final Map<String, FieldEntity> fields;
  final Function() saveData;
  final Function() closeForm;

  const DataBarberForm({
    Key? key,
    required this.saveData,
    required this.closeForm,
    required this.fields,
  }) : super(key: key);

  @override
  State<DataBarberForm> createState() => DataBarberFormState();
}

class DataBarberFormState extends State<DataBarberForm> {
  File? _file;
  Uint8List webImage = Uint8List(8);
  _pickImage() async {
    final picker = ImagePicker();

    if (kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var bytes = await image.readAsBytes();
        setState(() {
          webImage = bytes;
          _file = File(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.closeForm,
                  child: Text(
                    'close'.tr(),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            widget.fields['id']?.val != null && widget.fields['id']?.val.isNotEmpty  ?   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_file != null)
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        _file = null;
                        webImage = Uint8List(8);
                      });
                    },
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      size: 30,
                      color: _file == null ? Colors.grey : Colors.blue,
                    ),
                  ),
                if (_file != null) const SizedBox(width: 20),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: _file == null
                            ?  widget.fields['avatar']!.val.toString().contains("placeholder.png")
                            ? Image.asset(Assets.tAvatarPlaceHolder)
                            : Image.network(widget.fields['avatar']?.val)
                            : Image.memory(
                                webImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _file != null
                      ? () {
                          List<int> list = webImage.cast();
                          BlocProvider.of<AvatarCubit>(context).setAvatar(
                              filePath: list,
                              userId: widget.fields['id']?.val,
                              role: "barbers");

                          debugPrint("Save ");
                        }
                      : () async {
                          _pickImage();
                        },
                  icon: Icon(
                    _file != null ? Icons.check_rounded : Icons.edit,
                    size: 30,
                  ),
                ),
              ],
            ) : const SizedBox(),
            const SizedBox(height: 20),
            DataTextFieldWidget(fieldEntity: widget.fields['firstName']!),
            DataTextFieldWidget(fieldEntity: widget.fields['lastName']!),
            // DataTextFieldWidget(fieldEntity: widget.fields['login']!),
            // DataTextFieldWidget(fieldEntity: widget.fields['password']!),
            DataPhoneNumberFieldWidget(fieldEntity: widget.fields['phone']!, id: widget.fields['id']?.val),
            FilialFieldWidget(fieldEntity: widget.fields['filial']!),
            const SizedBox(height: 10),
            ButtonWidget(
              text: "save".tr(),
              onPressed: () => widget.saveData.call(),
            ),
          ],
        ),
      ),
    );
  }
}
