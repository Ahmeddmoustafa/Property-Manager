// ignore_for_file: must_be_immutable

import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/data/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class FileInfoCard extends StatefulWidget {
  FileInfoCard({
    Key? key,
    required this.info,
    required this.index,
  }) : super(key: key);

  final CloudStorageInfo info;
  bool selected = false;
  final int index;

  @override
  State<FileInfoCard> createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {
  @override
  Widget build(BuildContext context) {
    // final PropertyCubit cubit = BlocProvider.of<PropertyCubit>(context);
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PropertyCubit>(context)
            .getPropertiesByCategory(widget.index);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: BlocBuilder<PropertyCubit, PropertyState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: widget.index ==
                          context.read<PropertyCubit>().selectedCategory
                      ? primaryColor.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(defaultPadding * 0.3),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: widget.info.color.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          widget.info.svgSrc,
                          colorFilter: ColorFilter.mode(
                              widget.info.color, BlendMode.srcIn),
                        ),
                        // child: Image(
                        //   image: AssetImage(widget.info.svgSrc),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      Icon(Icons.more_vert, color: Colors.white54)
                    ],
                  ),
                  Text(
                    widget.info.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  categoryInfo(widget.index),
                  // ProgressLine(
                  //   color: info.color,
                  //   percentage: info.percentage,
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget categoryInfo(int index) {
    final PropertyCubit cubit = BlocProvider.of<PropertyCubit>(context);
    String length = "50";
    String price = "1M";

    switch (index) {
      case 0:
        length = cubit.properties.length.toString();
      case 1:
        length = cubit.paidproperties.length.toString();
      case 2:
        length = cubit.upcomingproperties.length.toString();
      case 3:
        length = cubit.notPaidproperties.length.toString();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$length Property",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white70),
        ),
        Text(
          price,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
