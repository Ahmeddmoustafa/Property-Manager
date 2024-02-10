import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:admin/screens/dashboard/components/no_data.dart';
import 'package:admin/screens/my_properties/components/properties_table_widget.dart';
import 'package:admin/screens/my_properties/components/reminder_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

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
      future: propertyCubit.getPropertiesByCategory(index: 0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "My Properties",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: BlocBuilder<PropertyCubit, PropertyState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          DropdownButton<String>(
                            value: propertyCubit.sortBy,
                            onChanged: (String? newValue) {
                              propertyCubit.selectSortCriteria(newValue!);
                              // Implement your sorting logic based on selectedSortOption
                            },
                            icon: SizedBox.shrink(),
                            alignment: Alignment.center,
                            items: <String>[
                              AppStrings.SortByPrice,
                              AppStrings.SortByPaidAmount,
                              AppStrings.SortByDate,
                              "Default"
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: ColorManager.White, fontSize: 12),
                                ),
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding * 0.5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: ColorManager.White)),
                              child: InkWell(
                                onTap: () => propertyCubit.toggleSort(),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward,
                                      color: propertyCubit.ascending
                                          ? ColorManager.White
                                          : ColorManager.LightGrey,
                                      size: 15,
                                    ),
                                    Icon(
                                      Icons.arrow_upward,
                                      color: propertyCubit.ascending
                                          ? ColorManager.LightGrey
                                          : ColorManager.White,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
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

  Future<void> showReminderDialog() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ColorManager.BackgroundColor,
        clipBehavior: Clip.antiAlias,
        insetAnimationDuration: const Duration(milliseconds: 500),
        insetAnimationCurve: Curves.easeIn,
        child: ReminderScreen(),
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


