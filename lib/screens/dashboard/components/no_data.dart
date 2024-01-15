import 'package:admin/constants.dart';
import 'package:admin/resources/Managers/assets_manager.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AssetsManager.SadImage,
            width: 100,
            height: 100,
            // color: ColorManager.BackgroundColor,
            colorBlendMode: BlendMode.srcIn,
          ),
          Container(
              margin: EdgeInsets.all(
                defaultPadding,
              ),
              child: Text("No Data Available")),
        ],
      ),
    );
  }
}
