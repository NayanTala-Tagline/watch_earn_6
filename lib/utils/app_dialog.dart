// import 'package:btc_mining_tracker/widgets/app_input_field.dart';
// import 'package:btc_mining_tracker/widgets/gradient_text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../extension/ext_context.dart';
// import 'app_dimens.dart';
//
// void showUpdateNameDialog(
//     {required BuildContext context,
//       required TextEditingController controller,
//       required GlobalKey<FormState> key,
//       required VoidCallback onTap
//     }) {
//
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: const Color(0xFF1A1A1A), // Dark dialog background
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppDimens.r16),
//           side: const BorderSide(color: Colors.white10),
//         ),
//         child: Form(
//           key: key,
//           child: Padding(
//             padding: EdgeInsets.all(AppDimens.w20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   context.l10n.enterName,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: context.themeTextColors.descriptionColor,
//                     fontSize: AppDimens.sp14,
//                     fontWeight: FontWeight.w500
//                   ),
//                 ),
//                 SizedBox(height: AppDimens.h10),
//
//                 AppInputField(
//                   controller: controller ,
//                   keyboardType: TextInputType.text,
//                   textAlign: TextAlign.start,
//                   hintStyle: context.textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     fontSize: AppDimens.sp16,
//                     color: context.themeTextColors.hintTextColor,
//                   ),
//                   borderSide: BorderSide.none,
//                 ),
//                 SizedBox(height: AppDimens.h25),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () => context.pop(),
//                       child: Text(
//                         context.l10n.cancel,
//                         style: context.textTheme.bodyMedium?.copyWith(
//                           color: context.themeTextColors.descriptionColor,
//                           fontSize: AppDimens.sp18,
//                           fontWeight: FontWeight.w500
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: AppDimens.w10),
//                     GestureDetector(
//                       onTap: onTap,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: AppDimens.w10,
//                           vertical: AppDimens.h5
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(AppDimens.r8),
//                           border: Border.all(
//                             color: Colors.white30
//                           ),
//                           gradient: RadialGradient(
//                             center: const Alignment(0.7, 0.9),
//                             radius: 1.5,
//                             colors: [
//                               context.themeColors.orangeColor.withValues(alpha: 0.5),
//                               context.themeColors.redColor.withValues(alpha: 0.0),
//                             ],
//                             stops: const [0.0, 0.5],
//                           ),
//                         ),
//                         child: GradientText(
//                           context.l10n.update,
//                           fontSize: AppDimens.sp18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
