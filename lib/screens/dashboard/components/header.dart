import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/cubit/change_password/change_password_cubit.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:admin/screens/change_password/change_password_widget.dart';
import 'package:admin/screens/dashboard/components/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin/Core/injection_control.dart' as di;

import '../../../constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.BackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            // if (!Responsive.isDesktop(context))
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<MenuAppController>().controlMenu,
            ),
            if (!Responsive.isMobile(context))
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            if (!Responsive.isMobile(context))
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            Expanded(child: SearchField()),
            ProfileCard()
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: PopupMenuButton(
        tooltip: "",
        position: PopupMenuPosition.under,
        child: Row(
          children: [
            Icon(Icons.account_circle),
            // Image.asset(
            //   "assets/images/profile_pic.png",
            //   height: 38,
            // ),
            if (!Responsive.isMobile(context))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text("Edit Account"),
              ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
        color: secondaryColor,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: '1',
            child: Text('CHANGE PASSWORD'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => BlocProvider(
                  create: (context) => di.sl<ChangePasswordCubit>(),
                  child: Dialog(
                      backgroundColor: ColorManager.BackgroundColor,
                      clipBehavior: Clip.antiAlias,
                      insetAnimationDuration: const Duration(milliseconds: 500),
                      insetAnimationCurve: Curves.easeIn,
                      child: ChangePasswordWidget()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PropertyCubit cubit = BlocProvider.of<PropertyCubit>(context);
    return TextField(
      onChanged: (value) async {
        if (context.mounted) {
          await cubit.setFilterQuery(value);
        }
      },
      decoration: InputDecoration(
        prefixIcon: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Dialog(
                    backgroundColor: ColorManager.BackgroundColor,
                    clipBehavior: Clip.antiAlias,
                    insetAnimationDuration: const Duration(milliseconds: 500),
                    insetAnimationCurve: Curves.easeIn,
                    child: FilterWidget(),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.3),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: ColorManager.BackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(Icons.filter_list),
          ),
        ),
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
            // Navigator.pushReplacementNamed(context, Routes.homeRoute);
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
