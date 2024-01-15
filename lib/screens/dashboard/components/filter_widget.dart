import 'package:admin/constants.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/resources/Managers/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  int selectedOption = 1; // Default selected option
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedOption = BlocProvider.of<PropertyCubit>(context).filterOption;
    print("the index initialy $selectedOption");
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        return Container(
          // margin: EdgeInsets.symmetric(vertical: AppSize.s30),
          height: 250,
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text("Search By:"),
              ),
              buildCheckbox(1, 'Property Description'),
              buildCheckbox(2, 'Buyer Name'),
              buildCheckbox(3, 'Buyer Number'),
            ],
          ),
        );
      },
    );
  }

  Widget buildCheckbox(int value, String label) {
    final PropertyCubit propertyCubit = context.read<PropertyCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Checkbox(
            value: selectedOption == value,
            onChanged: (bool? newValue) {
              setState(() {
                if (newValue != null && newValue) {
                  selectedOption = value;
                  propertyCubit.setFilter(value);
                  print(propertyCubit.filterOption);
                }
              });
            },
          ),
        ),
        Expanded(flex: 5, child: Text(label)),
      ],
    );
  }
}
