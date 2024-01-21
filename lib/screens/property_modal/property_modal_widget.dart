import 'package:admin/constants.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:admin/screens/property_modal/components/property_chart.dart';
import 'package:admin/screens/property_modal/components/installment_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyModalWidget extends StatefulWidget {
  final PropertyModel propertyModel;
  const PropertyModalWidget({super.key, required this.propertyModel});

  @override
  State<PropertyModalWidget> createState() => _PropertyModalWidgetState();
}

class _PropertyModalWidgetState extends State<PropertyModalWidget> {
  @override
  void initState() {
    super.initState();
    context.read<PropertyModalCubit>().openPropety(widget.propertyModel);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.7;
    final double width = MediaQuery.of(context).size.width * 0.6;
    return SelectionArea(
      selectionControls: CupertinoTextSelectionControls(),
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.villa),
                        Text("Property Type"),
                      ],
                    ),
                    PropertyChart(
                      propertyModel: widget.propertyModel,
                    ),
                    getText(
                        width,
                        "Description",
                        widget.propertyModel.description,
                        ColorManager.LightGrey),
                    getText(
                        width,
                        "Total Price",
                        formatPrice(double.parse(widget.propertyModel.price)),
                        ColorManager.LightGrey),
                    getText(
                        width,
                        "Paid ",
                        formatPrice(double.parse(widget.propertyModel.paid)),
                        ColorManager.Green),
                    getText(
                      width,
                      "Upcoming ",
                      formatPrice(widget.propertyModel.calculateInstallments()),
                      ColorManager.Orange,
                    ),
                    getText(
                      width,
                      "NotPaid ",
                      formatPrice(0),
                      ColorManager.error,
                    ),
                    getText(width, "Buyer Name", widget.propertyModel.buyerName,
                        ColorManager.LightGrey),
                    getText(
                        width,
                        "Buyer Number",
                        widget.propertyModel.buyerNumber,
                        ColorManager.LightGrey),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.9,
                child: VerticalDivider(
                  color: ColorManager.LightSilver,
                  thickness: 0.2,
                ),
              ),
              SizedBox(
                  width: width * 0.3,
                  child: InstallmentsStepperWidget(
                    propertyModel: widget.propertyModel,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getText(double width, String identifier, String data, Color color) {
    return Center(
      child: SizedBox(
        width: width * 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.1,
              child: Text(
                identifier,
                overflow: TextOverflow.fade,
                style: TextStyle(color: color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(":"),
            ),
            Flexible(
              child: SizedBox(
                width: width * 0.3,
                child: Text(
                  data,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ColorManager.LightSilver),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
