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
    final double height = MediaQuery.of(context).size.height * 0.8;
    final double width = MediaQuery.of(context).size.width * 0.6;
    final PropertyModalCubit cubit = context.read<PropertyModalCubit>();
    return SelectionArea(
      selectionControls: CupertinoTextSelectionControls(),
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: BlocBuilder<PropertyModalCubit, PropertyModalState>(
            builder: (context, state) {
              final bool active = cubit.paidInstallmentsIndex.length > 0;
              return Row(
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: active
                                  ? () {
                                      cubit.saveProperty();
                                    }
                                  : null,
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    color: active
                                        ? ColorManager.White
                                        : ColorManager.LightGrey),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  active
                                      ? ColorManager.Green
                                      : ColorManager.DarkGrey,
                                ),
                              ),
                              // color: ColorManager.Green,
                              // highlightColor: ColorManager.Green,
                              // focusColor: ColorManager.Green,
                            ),
                            TextButton(
                                onPressed: active
                                    ? () {
                                        cubit.reset();
                                      }
                                    : null,
                                child: Text("UNDO")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.villa),
                            Text("Property"),
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
                            formatPrice(
                                double.parse(widget.propertyModel.price)),
                            ColorManager.LightGrey),
                        getText(
                            width,
                            "Paid ",
                            formatPrice(
                                double.parse(widget.propertyModel.paid) +
                                    cubit.upcomingToPaid +
                                    cubit.notpaidToPaid),
                            ColorManager.Green),
                        getText(
                          width,
                          "Upcoming ",
                          formatPrice(
                              widget.propertyModel.calculateInstallments() -
                                  cubit.upcomingToPaid),
                          ColorManager.Orange,
                        ),
                        getText(
                          width,
                          "NotPaid ",
                          formatPrice(widget.propertyModel
                                  .calculateNotPaidInstallments() -
                              cubit.notpaidToPaid),
                          ColorManager.error,
                        ),
                        getText(
                            width,
                            "Buyer Name",
                            widget.propertyModel.buyerName,
                            ColorManager.LightGrey),
                        getText(
                            width,
                            "Buyer Number",
                            widget.propertyModel.buyerNumber,
                            ColorManager.LightGrey),
                        getText(
                            width,
                            "Contract",
                            formatDate(widget.propertyModel.contractDate),
                            ColorManager.LightGrey),
                        getText(
                            width,
                            "Submission",
                            formatDate(widget.propertyModel.submissionDate),
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
              );
            },
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
                  overflow: TextOverflow.fade,
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
