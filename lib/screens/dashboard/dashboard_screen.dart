import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/cubit/scroll/scroll_cubit.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:admin/screens/dashboard/components/my_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import 'components/header.dart';

import '../my_properties/my_properties_widget.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  final double width;

  const DashboardScreen({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollCubit scrollCubit = context.read<ScrollCubit>();
    scrollCubit.propertiesScrollController
        .addListener(() => scrollListener(context));
    return Container(
      // padding: EdgeInsets.all(defaultPadding),
      width: width,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollCubit.propertiesScrollController,
          // physics: NeverScrollableScrollPhysics(),
          primary: false,
          // padding: EdgeInsets.all(defaultPadding),
          child: FutureBuilder(
            future: BlocProvider.of<PropertyCubit>(context).fetchData(),
            builder: (contex, snapshot) => Column(
              children: [
                Header(),
                SizedBox(height: defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context) ? width : width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyCategoriesWidget(),
                          SizedBox(height: defaultPadding),
                          MyPropertiesWidget(
                            width: Responsive.isMobile(context)
                                ? width
                                : width * 0.7,
                          ),
                          if (Responsive.isMobile(context))
                            SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context))
                            SizedBox(
                                child: StorageDetails(
                              width: width,
                            )),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      // SizedBox(width: defaultPadding),
                      // On Mobile means if the screen is less than 850 we don't want to show it
                      StorageDetails(
                        width: width * 0.26,
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void scrollListener(BuildContext context) async {
  final ScrollCubit scrollCubit = context.read<ScrollCubit>();
  final PropertyCubit propertyCubit = context.read<PropertyCubit>();
  if (scrollCubit.loading) return;

  if (scrollCubit.propertiesScrollController.position.pixels ==
      scrollCubit.propertiesScrollController.position.maxScrollExtent) {
    print("scrolled");
    scrollCubit.loading = true;
    scrollCubit.page += 1;
    await propertyCubit.getPropertiesByCategory(
      index: propertyCubit.selectedCategory,
      pagination: scrollCubit.page,
    );
    scrollCubit.loading = false;
  }
}
