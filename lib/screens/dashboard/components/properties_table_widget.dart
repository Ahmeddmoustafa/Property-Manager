import 'package:admin/constants.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/values_manager.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/add_property_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PropertiesTableWidget extends StatefulWidget {
  final double width;
  final List<PropertyModel> properties;
  const PropertiesTableWidget(
      {super.key, required this.width, required this.properties});

  @override
  State<PropertiesTableWidget> createState() => _PropertiesTableWidgetState();
}

class _PropertiesTableWidgetState extends State<PropertiesTableWidget> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tableText(flex: 3, text: "Property Description", padding: 0),
            tableText(flex: 1, text: "Price in EGP", padding: 0),
            tableText(flex: 1, text: "Installment Date", padding: 0),
            tableText(flex: 2, text: "Buyer Name", padding: 0),
            tableText(flex: 2, text: "Buyer Number", padding: 0),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: defaultPadding),
          child: Divider(
            // height: 25,
            color: ColorManager.LightSilver,
            thickness: 0.2,
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.properties.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                onEnter: (event) => setState(() {
                  _hoveredIndex = index;
                }),
                onExit: (event) => setState(() {
                  _hoveredIndex = -1;
                }),
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: ColorManager.BackgroundColor,
                      clipBehavior: Clip.antiAlias,
                      insetAnimationDuration: const Duration(milliseconds: 500),
                      insetAnimationCurve: Curves.easeIn,
                      child: AddPropertyModal(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width * 0.6
                            : MediaQuery.of(context).size.width * 0.9,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: AppSize.s20),
                        decoration: BoxDecoration(
                          color: _hoveredIndex == index
                              ? ColorManager.BackgroundColor
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: double.maxFinite,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            iconText(
                              context: context,
                              flex: 3,
                              text: widget.properties[index].description,
                              padding: 10.0,
                            ),
                            tableText(
                              flex: 1,
                              text: formatPrice(
                                  double.parse(widget.properties[index].price)),
                              padding: 8.0,
                            ),
                            tableText(
                              flex: 1,
                              text: formatDate(widget
                                  .properties[index].installments[0].date),
                              padding: 8.0,
                            ),
                            tableText(
                              flex: 2,
                              text: widget.properties[index].buyerName,
                              padding: 8.0,
                            ),
                            tableText(
                              flex: 2,
                              text: widget.properties[index].buyerNumber,
                              padding: 8.0,
                            ),
                          ],
                        ),
                      ),
                      if (!(index == widget.properties.length - 1))
                        Divider(
                          // height: 25,
                          height: 0,
                          color: ColorManager.LightSilver,
                          thickness: 0.2,
                        ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget tableText(
      {required int flex, required String text, required double padding}) {
    return SizedBox(
      width: flex / 10 * widget.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  Widget iconText(
      {required BuildContext context,
      required int flex,
      required String text,
      required double padding}) {
    return SizedBox(
      width: flex / 10 * widget.width,
      child: Row(
        children: [
          SvgPicture.asset(
            context.read<PropertyCubit>().icon,
            colorFilter: ColorFilter.mode(
                context.read<PropertyCubit>().categoryColor, BlendMode.srcIn),
            height: 30,
            width: 30,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  String formatPrice(double price) {
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(price);
  }
}
