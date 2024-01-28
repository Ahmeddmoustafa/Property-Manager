import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // We want this side menu only for large screen
            // if (Responsive.isDesktop(context))
            //   SizedBox(
            //     width: width * 0.15,
            //     // default flex = 1
            //     // and it takes 1/6 part of the screen
            //     child: SideMenu(),
            //   ),
            // LoadPage()
            DashboardScreen(
              width: Responsive.isDesktop(context) ? width : width,
            )
          ],
        ),
      ),
    );
  }
}
