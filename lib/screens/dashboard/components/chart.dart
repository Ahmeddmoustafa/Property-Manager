import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class StorageChart extends StatelessWidget {
  const StorageChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PropertyCubit cubit = BlocProvider.of<PropertyCubit>(context);
    final String paid = cubit.calculatePaidProperties();
    final String all = cubit.calculateAllProperties();
    final String upcoming = cubit.calculateUpcomingProperties();
    final String notpaid = cubit.calculateNotPaidProperties();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: getChartData(paid, upcoming, notpaid),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  chartFormatPrice(paid) + "",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                SizedBox(height: defaultPadding),
                Text("of ${chartFormatPrice(all)} EGP")
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getChartData(
      String paid, String upcoming, String notpaid) {
    if (double.parse(paid) == 0 &&
        double.parse(upcoming) == 0 &&
        double.parse(notpaid) == 0) {
      return [
        PieChartSectionData(
          color: ColorManager.DarkGrey,
          value: 100,
          showTitle: false,
          radius: 14,
        ),
      ];
    }
    return [
      PieChartSectionData(
        color: ColorManager.Green,
        value: double.parse(paid),
        showTitle: false,
        radius: 14,
      ),
      PieChartSectionData(
        color: Color(0xFFFFA113),
        value: double.parse(upcoming),
        showTitle: false,
        radius: 14,
      ),
      // PieChartSectionData(
      //   color: Color(0xFFFFCF26),
      //   value: 10,
      //   showTitle: false,
      //   radius: 14,
      // ),
      PieChartSectionData(
        color: Color(0xFFEE2727),
        value: double.parse(notpaid),
        showTitle: false,
        radius: 14,
      ),
      // PieChartSectionData(
      //   color: primaryColor.withOpacity(0.1),
      //   value: 25,
      //   showTitle: false,
      //   radius: 13,
      // ),
    ];
  }
}

List<PieChartSectionData> paiChartSelectionData = [
  PieChartSectionData(
    color: ColorManager.Green,
    value: 25,
    showTitle: false,
    radius: 14,
  ),
  PieChartSectionData(
    color: Color(0xFFFFA113),
    value: 20,
    showTitle: false,
    radius: 14,
  ),
  // PieChartSectionData(
  //   color: Color(0xFFFFCF26),
  //   value: 10,
  //   showTitle: false,
  //   radius: 14,
  // ),
  PieChartSectionData(
    color: Color(0xFFEE2727),
    value: 15,
    showTitle: false,
    radius: 14,
  ),
  // PieChartSectionData(
  //   color: primaryColor.withOpacity(0.1),
  //   value: 25,
  //   showTitle: false,
  //   radius: 13,
  // ),
];
