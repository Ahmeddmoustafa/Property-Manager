import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/data/models/MyFiles.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
    required this.width,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    final PropertyCubit cubit = BlocProvider.of<PropertyCubit>(context);
    return Container(
      width: width,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: BlocBuilder<PropertyCubit, PropertyState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Storage Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: defaultPadding),
              StorageChart(),
              StorageCardWidget(
                svgSrc: demoMyFiles[0].svgSrc,
                title: demoMyFiles[0].title,
                color: demoMyFiles[0].color,
                amountOfFiles: chartFormatPrice(cubit.totalAmount) + " EGP",
                numOfFiles: cubit.properties.length,
              ),
              StorageCardWidget(
                svgSrc: demoMyFiles[1].svgSrc,
                title: demoMyFiles[1].title,
                color: demoMyFiles[1].color,
                amountOfFiles: chartFormatPrice(cubit.paidAmount) + " EGP",
                numOfFiles: cubit.paidproperties.length,
              ),
              StorageCardWidget(
                svgSrc: demoMyFiles[2].svgSrc,
                title: demoMyFiles[2].title,
                color: demoMyFiles[2].color,
                amountOfFiles: chartFormatPrice(cubit.totalAmount -
                        cubit.paidAmount -
                        cubit.notPaidAmount) +
                    " EGP",
                numOfFiles: cubit.upcomingproperties.length,
              ),
              StorageCardWidget(
                svgSrc: demoMyFiles[3].svgSrc,
                title: demoMyFiles[3].title,
                color: demoMyFiles[3].color,
                amountOfFiles: chartFormatPrice(cubit.notPaidAmount) + " EGP",
                numOfFiles: cubit.notPaidproperties.length,
              ),
            ],
          );
        },
      ),
    );
  }
}
