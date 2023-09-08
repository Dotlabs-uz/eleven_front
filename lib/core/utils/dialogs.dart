

class Dialogs {
  // static exitDialog({
  //   required BuildContext context,
  //   required Function() onExit,
  // }) {fl
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100.w
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(height: 33.h),
  //             Container(
  //               height: 123.r,
  //               width: 123.r,
  //               decoration: BoxDecoration(
  //                 color: const Color(0xffFA3E3E).withOpacity(0.75),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Center(
  //                 child: SvgPicture.asset(
  //                   Assets.tWarningIcon,
  //                   height: 60.h,
  //                   width: 60.w,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 15.h),
  //             Text(
  //               'Exit'.tr(),
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontFamily: "Nunito",
  //                 fontSize: 18.sp,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             SizedBox(height: 10.h),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Text(
  //                 'DoYouReallyWantToExit'.tr(),
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontFamily: "Nunito",
  //                   color: const Color(0xff696969),
  //                   fontSize: 14.sp,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 66.h),
  //             SizedBox(
  //               height: 34.h,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Expanded(
  //                     child: ButtonWidget(
  //                       title: 'Back'.tr(),
  //                       onTap: () => Navigator.pop(context),
  //                       color: const Color(0xffABACAE),
  //                     ),
  //                   ),
  //                   SizedBox(width: 15.w),
  //                   Expanded(
  //                     child: ButtonWidget(
  //                       title: 'Exit'.tr(),
  //                       color: const Color(0xffFA3E3E).withOpacity(0.75),
  //                       onTap: () {
  //                         onExit.call();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}