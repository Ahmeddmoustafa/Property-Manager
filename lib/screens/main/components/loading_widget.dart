import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 70,
            child: SpinKitPumpingHeart(
              itemBuilder: (context, index) => Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent overlay to prevent interaction with buttons

        // Centered loading indicator
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ColorManager.Transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}

class AddPropertyLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        if (context.read<AddPropertyCubit>().loading == false) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: ColorManager.Transparent,
          // Set the inset padding to zero to make the loading indicator take up the full screen
          insetPadding: EdgeInsets.zero,
          child: Container(
            color: ColorManager.Transparent,
            // Use MediaQuery to get the screen size
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                // SizedBox(height: 16),
                // Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PropertyLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyModalCubit, PropertyModalState>(
      listener: (context, state) {
        if (context.read<PropertyModalCubit>().loading == false) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: ColorManager.Transparent,
          // Set the inset padding to zero to make the loading indicator take up the full screen
          insetPadding: EdgeInsets.zero,
          child: Container(
            color: ColorManager.Transparent,
            // Use MediaQuery to get the screen size
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                // SizedBox(height: 16),
                // Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }
}
