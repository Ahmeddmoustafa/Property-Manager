import 'dart:js_util';

import 'package:admin/constants.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyChart extends StatelessWidget {
  const PropertyChart({super.key, required this.propertyModel});
  final PropertyModel propertyModel;

  @override
  Widget build(BuildContext context) {
    final PropertyModalCubit cubit = context.read<PropertyModalCubit>();
    final double paid =
        propertyModel.paid + cubit.upcomingToPaid + cubit.notpaidToPaid;
    final double notpaid = propertyModel.notPaid - cubit.notpaidToPaid;
    // propertyModel.calculatePaidInstallments();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: getChartData(context, paid, notpaid),
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
                Text("of ${chartFormatPrice(propertyModel.price)} EGP"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getChartData(
      BuildContext context, double paid, double notpaid) {
    final PropertyModalCubit cubit = context.read<PropertyModalCubit>();
    return [
      PieChartSectionData(
        color: ColorManager.Green,
        value: paid,
        showTitle: false,
        radius: 14,
      ),
      PieChartSectionData(
        color: Color(0xFFFFA113),
        value: propertyModel.price -
            propertyModel.paid -
            propertyModel.notPaid -
            cubit.upcomingToPaid,
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
        value: notpaid,
        showTitle: false,
        radius: 14,
      ),
    ];
  }
  // PieChartSectionData(
  //   color: primaryColor.withOpacity(0.1),
  //   value: 25,
  //   showTitle: false,
  //   radius: 13,
  // ),
}
