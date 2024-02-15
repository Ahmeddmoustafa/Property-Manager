import 'package:admin/Core/injection_control.dart' as di;
import 'package:admin/constants.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/cubit/scroll/scroll_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:admin/screens/property_modal/property_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
  void initState() {
    super.initState();
    context
        .read<ScrollCubit>()
        .propertiesScrollController
        .addListener(scrollListener);
  }

  Future<void> scrollListener() async {
    if (!context.mounted && !mounted) return;
    final ScrollCubit scrollCubit = context.read<ScrollCubit>();
    final PropertyCubit propertyCubit = context.read<PropertyCubit>();
    if (scrollCubit.loading) return;

    if (scrollCubit.propertiesScrollController.position.pixels ==
        scrollCubit.propertiesScrollController.position.maxScrollExtent) {
      print("scrolled");
      scrollCubit.loading = true;
      scrollCubit.page += 1;
      if (mounted) {
        await propertyCubit.getPropertiesByCategory(
          index: propertyCubit.selectedCategory,
          pagination: scrollCubit.page,
        );
      }
      scrollCubit.loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollCubit scrollCubit = context.read<ScrollCubit>();
    final PropertyCubit propertyCubit = context.read<PropertyCubit>();

    return Column(
      children: [
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tableText(
                flex: 3,
                color: ColorManager.White,
                text: "Property Description",
                padding: 0),
            tableText(
                flex: 1, color: ColorManager.White, text: "PAID", padding: 0),
            tableText(
                flex: 1,
                color: ColorManager.White,
                text: "Total Price",
                padding: 0),
            tableText(
                flex: 1,
                color: ColorManager.White,
                text: "Next Date",
                padding: 0),
            tableText(
                flex: 2,
                color: ColorManager.White,
                text: "Buyer Name",
                padding: 0),
            tableText(
                flex: 2,
                color: ColorManager.White,
                text: "Buyer Number",
                padding: 0),
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
            itemCount: scrollCubit.loading
                ? widget.properties.length + 1
                : widget.properties.length,
            itemBuilder: (context, index) {
              if (index <= widget.properties.length)
                return StatefulBuilder(builder: (context, stateSetter) {
                  return MouseRegion(
                    cursor: MaterialStateMouseCursor.clickable,
                    onEnter: (event) {
                      // scrollCubit.updateHover(index);
                      stateSetter(() {
                        _hoveredIndex = index;
                      });
                    },
                    onExit: (event) {
                      // scrollCubit.updateHover(index);
                      stateSetter(() {
                        _hoveredIndex = -1;
                      });
                    },
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => BlocProvider(
                          create: (context) => di.sl<PropertyModalCubit>(),
                          child: Dialog(
                            backgroundColor: ColorManager.BackgroundColor,
                            clipBehavior: Clip.antiAlias,
                            insetAnimationDuration:
                                const Duration(milliseconds: 500),
                            insetAnimationCurve: Curves.easeIn,
                            child: PropertyModalWidget(
                              propertyModel: widget.properties[index],
                            ),
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
                                  color: propertyCubit.sortBy ==
                                          AppStrings.SortByPaidAmount
                                      ? propertyCubit.categoryColor
                                      : ColorManager.White,
                                  text: formatPrice(
                                      widget.properties[index].paid),
                                  padding: 8.0,
                                ),
                                tableText(
                                  flex: 1,
                                  color: propertyCubit.sortBy ==
                                          AppStrings.SortByPrice
                                      ? propertyCubit.categoryColor
                                      : ColorManager.White,
                                  text: formatPrice(
                                      widget.properties[index].price),
                                  padding: 8.0,
                                ),
                                tableText(
                                  flex: 1,
                                  color: propertyCubit.sortBy ==
                                          AppStrings.SortByDate
                                      ? propertyCubit.categoryColor
                                      : ColorManager.White,
                                  text: widget.properties[index].installments
                                              .length >
                                          0
                                      ? formatDate(widget.properties[index]
                                          .installments[0].date)
                                      : "NA",
                                  padding: 8.0,
                                ),
                                tableText(
                                  flex: 2,
                                  color: ColorManager.White,
                                  text: widget.properties[index].buyerName,
                                  padding: 8.0,
                                ),
                                tableText(
                                  flex: 2,
                                  color: ColorManager.White,
                                  text: widget.properties[index].buyerNumber,
                                  padding: 0,
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
                });
              else
                return Center(
                  child: const CircularProgressIndicator(),
                );
            }),
      ],
    );
  }

  Widget tableText(
      {required int flex,
      required String text,
      required double padding,
      required Color color}) {
    return SizedBox(
      width: flex / 10 * widget.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: TextStyle(color: color),
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
}
