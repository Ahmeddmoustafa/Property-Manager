import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/screens/dashboard/components/no_data.dart';
import 'package:admin/screens/dashboard/components/properties_table_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class MyPropertiesWidget extends StatefulWidget {
  final double width;
  const MyPropertiesWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  State<MyPropertiesWidget> createState() => _MyPropertiesWidgetState();
}

class _MyPropertiesWidgetState extends State<MyPropertiesWidget> {
  @override
  void initState() {
    super.initState();
    // if (context.read<PropertyCubit>().selectedCategory == -1) ;
    // BlocProvider.of<PropertyCubit>(context).getPropertiesByCategory(0);
  }

  @override
  Widget build(BuildContext context) {
    final PropertyCubit propertyCubit = context.read<PropertyCubit>();
    return FutureBuilder(
      future: propertyCubit.getPropertiesByCategory(0),
      builder: (context, snapshot) => Container(
        width: widget.width,
        margin: EdgeInsets.only(bottom: defaultPadding),
        // padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "My Properties",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SizedBox(
              child: BlocBuilder<PropertyCubit, PropertyState>(
                builder: (context, state) {
                  if (propertyCubit.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!propertyCubit.loading &&
                      state.properties.isEmpty &&
                      !propertyCubit.hasError) {
                    return NoDataWidget();
                  }
                  return PropertiesTableWidget(
                    width: widget.width,
                    properties: state.properties,
                  );
                  // return DataTable(
                  //   columnSpacing: defaultPadding,
                  //   dataRowMinHeight: AppSize.s100,
                  //   dataRowMaxHeight: AppSize.s100,
                  //   // minWidth: 600,
                  //   columns: [
                  //     DataColumn(
                  //       label: Text("Property Description"),
                  //     ),
                  //     DataColumn(
                  //       label: Text(
                  //         "Price in EGP",
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //     DataColumn(
                  //       label: Text("Date"),
                  //     ),
                  //     DataColumn(
                  //       label: Text("Buyer Name"),
                  //     ),
                  //   ],
                  //   rows: List.generate(
                  //     state.properties.length,
                  //     (index) => recentFileDataRow(
                  //         context, state.properties[index], index),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DataRow recentFileDataRow(
//     BuildContext context, PropertyModel fileInfo, int index) {
//   final String price = fileInfo.price;
//   // int length = price.length;
//   return DataRow(
//     cells: [
//       DataCell(
//         Row(
//           children: [
//             SvgPicture.asset(
//               context.read<PropertyCubit>().icon,
//               colorFilter: ColorFilter.mode(
//                   context.read<PropertyCubit>().categoryColor, BlendMode.srcIn),
//               height: 30,
//               width: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//               child: Text(
//                 fileInfo.description,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//       DataCell(Text(
//         formatPrice(double.parse(price)),
//         overflow: TextOverflow.ellipsis,
//       )),
//       DataCell(Text(
//         fileInfo.installments[0].date.toString(),
//         overflow: TextOverflow.ellipsis,
//       )),
//       DataCell(Text(
//         fileInfo.buyerName,
//         overflow: TextOverflow.ellipsis,
//       )),
//     ],
//   );
// }


