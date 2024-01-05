import 'package:eleven_crm/core/components/page_not_allowed_widget.dart';
import 'package:flutter/material.dart';


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
