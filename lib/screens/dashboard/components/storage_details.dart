import 'package:admin/data/models/MyFiles.dart';
import 'package:flutter/material.dart';

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
    return Container(
      width: width,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
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
          Chart(),
          StorageCardWidget(
            svgSrc: demoMyFiles[0].svgSrc,
            title: demoMyFiles[0].title,
            color: demoMyFiles[0].color,
            amountOfFiles: demoMyFiles[0].totalMoney.toString() + " EGP",
            numOfFiles: 1328,
          ),
          StorageCardWidget(
            svgSrc: demoMyFiles[1].svgSrc,
            title: demoMyFiles[1].title,
            color: demoMyFiles[1].color,
            amountOfFiles: demoMyFiles[1].totalMoney.toString() + " EGP",
            numOfFiles: 1328,
          ),
          StorageCardWidget(
            svgSrc: demoMyFiles[2].svgSrc,
            title: demoMyFiles[2].title,
            color: demoMyFiles[2].color,
            amountOfFiles: demoMyFiles[2].totalMoney.toString() + " EGP",
            numOfFiles: 1328,
          ),
          StorageCardWidget(
            svgSrc: demoMyFiles[3].svgSrc,
            title: demoMyFiles[3].title,
            color: demoMyFiles[3].color,
            amountOfFiles: demoMyFiles[3].totalMoney.toString() + " EGP",
            numOfFiles: 140,
          ),
        ],
      ),
    );
  }
}
