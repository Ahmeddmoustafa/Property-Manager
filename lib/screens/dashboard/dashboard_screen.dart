import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/cubit/scroll/scroll_cubit.dart';
import 'package:admin/resources/Managers/assets_manager.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:admin/screens/dashboard/components/my_categories_widget.dart';
import 'package:admin/screens/main/components/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../constants.dart';
import 'components/header.dart';

import '../my_properties/my_properties_widget.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  final double width;
  // late ScrollCubit scrollCubit = ScrollCubit();

  DashboardScreen({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit>();
    scrollCubit.page = 1;
    scrollCubit.propertiesScrollController
        .addListener(() async => await scrollListener(context, scrollCubit));

    // widget.scrollCubit.propertiesScrollController
    //     .addListener(() => scrollListener(context, widget.scrollCubit));
    return Container(
      // padding: EdgeInsets.all(defaultPadding),
      width: width,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollCubit.propertiesScrollController,
          // physics: NeverScrollableScrollPhysics(),
          primary: false,
          // padding: EdgeInsets.all(defaultPadding),
          child: BlocListener<PropertyCubit, PropertyState>(
            listener: (context, state) {
              print("refresh ${context.read<PropertyCubit>().loading}");
              if (context.read<PropertyCubit>().loading) {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent users from dismissing the dialog by tapping outside
                  builder: (BuildContext context) {
                    return GetPropertiesLoadingScreen();
                  },
                );
              }
              if (BlocProvider.of<PropertyCubit>(context).foundNotPaid) {
                _showNotPaidAlarm(context);
              }
            },
            child: FutureBuilder(
              future: BlocProvider.of<PropertyCubit>(context).fetchData(),
              builder: (contex, snapshot) =>
                  BlocListener<PropertyCubit, PropertyState>(
                listener: (context, state) {},
                child: Column(
                  children: [
                    const Header(),
                    const SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Responsive.isMobile(context)
                              ? width
                              : width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const MyCategoriesWidget(),
                              SizedBox(height: defaultPadding),
                              MyPropertiesWidget(
                                width: Responsive.isMobile(context)
                                    ? width
                                    : width * 0.7,
                              ),
                              if (Responsive.isMobile(context))
                                const SizedBox(height: defaultPadding),
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
        ),
      ),
    );
  }
}

//  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (mounted && context.mounted) {
//       final scrollCubit = context.read<ScrollCubit>();
//       scrollCubit.propertiesScrollController = ScrollController();
// scrollCubit.propertiesScrollController!
//     .addListener(() => scrollListener(context, scrollCubit));
//     }
//   }

//   @override
//   void dispose() {
//     final scrollCubit = context.read<ScrollCubit>();
//     scrollCubit.propertiesScrollController!
//         .removeListener(() => scrollListener);
//     scrollCubit.propertiesScrollController!.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     if (mounted && context.mounted) {
//       final scrollCubit = context.read<ScrollCubit>();
//       // scrollCubit.propertiesScrollController = ScrollController();
//       scrollCubit.propertiesScrollController!
//           .addListener(() => scrollListener(context, scrollCubit));
//     }
//     super.didChangeDependencies();
//   }

void _showNotPaidAlarm(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ColorManager.BackgroundColor,
        icon: SvgPicture.asset(
          AssetsManager.NotPaidPropertiesIcon,
          colorFilter: ColorFilter.mode(ColorManager.error, BlendMode.srcIn),
          width: 70,
          height: 70,
        ),
        content: Text(
          'Found Not Paid Properties',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                // Perform action when "Yes" is pressed
                Navigator.of(context)
                    .pop(true); // Close the dialog and return true
              },
              child: Text('OK'),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> scrollListener(
    BuildContext context, ScrollCubit scrollCubit) async {
  // final ScrollCubit scrollCubit = context.read<ScrollCubit>();
  final PropertyCubit propertyCubit = context.read<PropertyCubit>();
  if (scrollCubit.loading) return;

  if (scrollCubit.propertiesScrollController!.position.pixels ==
      scrollCubit.propertiesScrollController!.position.maxScrollExtent) {
    print("scrolled");
    // scrollCubit.loading = true;

    scrollCubit.toogleLoading();
    print("fetching new data");

    if (scrollCubit.incrementPagination()) {
      await Future.delayed(Duration(seconds: 1));
      await propertyCubit.getPropertiesByCategory(
        index: propertyCubit.selectedCategory,
        pagination: scrollCubit.page,
      );
    }

    scrollCubit.toogleLoading();

    // scrollCubit.loading = false;
  }
}
