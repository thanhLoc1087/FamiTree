// import 'package:famitree/src/core/constants/colors.dart';
// import 'package:flutter/material.dart';

// class FormBackground extends StatelessWidget {
//   final List<Widget> children;
//   final VoidCallback? onClose;
//   final EdgeInsets padding;
//   final CrossAxisAlignment crossAxisAlignment;
//   final EdgeInsets margin;
//   final Color? mainColor;

//   const FormBackground({
//     super.key,
//     required this.children,
//     required this.onClose,
//     this.padding = const EdgeInsets.only(top: 34, bottom: 38),
//     this.margin = EdgeInsets.zero,
//     this.crossAxisAlignment = CrossAxisAlignment.start,
//     this.mainColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: AppColor.background,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           constraints: const BoxConstraints(maxWidth: 600),
//           padding: padding,
//           margin: margin,
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: crossAxisAlignment,
//               children: children,
//             ),
//           ),
//         ),
//         onClose == null
//             ? const SizedBox()
//             : Positioned(
//                 right: 6 + margin.right,
//                 top: 6 + margin.top,
//                 child: IconButton(
//                   onPressed: onClose,
//                   icon: Icon(
//                     Icons.close_rounded,
//                     color: mainColor ?? AppColor.text,
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }
