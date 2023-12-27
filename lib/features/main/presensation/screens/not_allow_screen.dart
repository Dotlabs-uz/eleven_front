import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/page_not_allowed_widget.dart';
import 'package:eleven_crm/core/components/search_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/drawer_widget.dart';
import '../../../../core/components/floating_menu_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/menu_constants.dart';
import '../../../../core/utils/route_constants.dart';
import '../../../auth/presentation/cubit/login_cubit.dart';
import '../../domain/entity/top_menu_entity.dart';
import '../cubit/menu/menu_cubit.dart';
import '../cubit/top_menu_cubit/top_menu_cubit.dart';
import '../widget/my_icon_button.dart';

class NotAllowScreen extends StatefulWidget {
  const NotAllowScreen({Key? key}) : super(key: key);

  @override
  State<NotAllowScreen> createState() => _NotAllowScreenState();
}

class _NotAllowScreenState extends State<NotAllowScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
   body: Center(child: PageNotAllowedWidget()),
    );
  }
}

