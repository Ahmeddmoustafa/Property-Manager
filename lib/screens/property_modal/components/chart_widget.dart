import 'package:admin/constants.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/screens/property_modal/property_modal_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PropertyChart extends StatelessWidget {
  const PropertyChart({super.key, required this.propertyModel});
  final PropertyModel propertyModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: getChartData(),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  formatPrice(double.parse(propertyModel.paid)) + "M",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                SizedBox(height: defaultPadding),
                Text(
                    "of ${formatPrice(double.parse(propertyModel.price))}M EGP"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getChartData() {
    return [
      PieChartSectionData(
        color: ColorManager.Green,
        value: double.parse(propertyModel.paid),
        showTitle: false,
        radius: 14,
      ),
      PieChartSectionData(
        color: Color(0xFFFFA113),
        value: double.parse(propertyModel.price) -
            propertyModel.calculateInstallments(),
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
        value: 0,
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

  String formatPrice(double price) {
    String formattedPrice = (price / 1000000).toStringAsFixed(2);

    // Remove trailing zeros and decimal point if necessary
    formattedPrice = formattedPrice.replaceAll(RegExp(r'0*$'), '');
    formattedPrice = formattedPrice.replaceAll(RegExp(r'\.$'), '');

    return formattedPrice;
  }
}
