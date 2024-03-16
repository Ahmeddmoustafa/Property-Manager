import 'package:admin/resources/Managers/assets_manager.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String title;
  final String svgSrc, totalMoney;
  final int numOfProperties, percentage;
  final Color color;

  CloudStorageInfo({
    required this.svgSrc,
    required this.title,
    required this.totalMoney,
    required this.numOfProperties,
    required this.percentage,
    required this.color,
  });
}

List<CloudStorageInfo> demoMyFiles = [
  CloudStorageInfo(
    title: "All Properties",
    numOfProperties: 1328,
    svgSrc: AssetsManager.AllPropertiesIcon,
    totalMoney: "128M",
    color: primaryColor,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Paid",
    numOfProperties: 200,
    svgSrc: AssetsManager.PaidPropertiesIcon,
    totalMoney: "50M",
    color: ColorManager.Green,
    percentage: 78,
  ),
  CloudStorageInfo(
    title: "Upcoming Payment",
    numOfProperties: 700,
    svgSrc: AssetsManager.UpcomingPropertiesIcon,
    totalMoney: "30M",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "NOT PAID",
    numOfProperties: 500,
    svgSrc: AssetsManager.NotPaidPropertiesIcon,
    totalMoney: "48M",
    color: Color.fromARGB(255, 199, 54, 90),
    percentage: 10,
  ),
  // REMOVED IN PRODUCTION
  CloudStorageInfo(
    title: "UnSold",
    numOfProperties: 1328,
    svgSrc: AssetsManager.AllPropertiesIcon,
    totalMoney: "128M",
    color: ColorManager.DarkGrey,
    percentage: 35,
  ),
];
