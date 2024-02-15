// Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(Icons.arrow_left),
//               onPressed: () => null,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 (widget.properties.length / 50).ceil(),
//                 (index) {
//                   if (index > 3 &&
//                       (widget.properties.length / 50).ceil() > 7 &&
//                       index != (widget.properties.length / 50).ceil() - 1)
//                     return Text(
//                       ".",
//                       textAlign: TextAlign.center,
//                     );
//                   return Container(
//                     margin:
//                         EdgeInsets.symmetric(horizontal: defaultPadding * 0.25),
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStatePropertyAll(ColorManager.DarkGrey),
//                       ),
//                       onPressed: () => null,
//                       child: Text(
//                         index.toString(),
//                         style: TextStyle(color: ColorManager.White),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.arrow_right),
//               onPressed: () => null,
//             ),
//           ],
//         )