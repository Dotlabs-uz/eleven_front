import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class CheckerWithTitleWidget extends StatefulWidget {
  
  final bool isActive;
  final String title;
  final Function(bool)? onChange;
  const CheckerWithTitleWidget({Key? key, required this.isActive, required this.title, this.onChange}) : super(key: key);

  @override
  State<CheckerWithTitleWidget> createState() => _CheckerWithTitleWidgetState();
}

class _CheckerWithTitleWidgetState extends State<CheckerWithTitleWidget> {
  
  bool isActive = true;
  
  
  @override
  void initState() {
    isActive = widget.isActive;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {

          isActive = !isActive;
          widget.onChange?.call(isActive);
        });
      },
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: AppColors.accent,
                ),),
            child: Center(
              child:  isActive ?    Icon(Icons.check, color: AppColors.accent,) :const SizedBox() ,
            ),
          ),

          const SizedBox(width: 10),

          Text(widget.title), // TODO Add style
        ],
      ),
    );
  }
}
