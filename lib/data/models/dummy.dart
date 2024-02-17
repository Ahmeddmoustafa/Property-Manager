import 'package:admin/data/models/property_model.dart';
import 'dart:math';

import 'package:admin/resources/Managers/strings_manager.dart';

List<PropertyModel> getRandomData() {
  List<PropertyModel> models = [];
  Random random = Random();

  for (int i = 1; i <= 500; i++) {
    String id = i.toString();
    String description = "Villa $i in Compound $i beside city $i";
    double price = (random.nextInt(5000000) + 1000000).toDouble();
    double paid = (random.nextInt(price.toInt() + 1)).toDouble();
    String buyerName = "Buyer $i";
    String buyerNumber = "01100${random.nextInt(99999999)}";
    int notPaid = (price - paid).toInt();
    List<Installment> installments = [];

    int installmentCount = random.nextInt(20) + 1;
    int year = random.nextInt(3) + 2023;
    DateTime lastInstallmentDate =
        DateTime(year, random.nextInt(12) + 1, random.nextInt(28) + 1);

    for (int j = 1; j <= installmentCount; j++) {
      String installmentId = j.toString();
      String installmentName = j.toString();
      DateTime installmentDate =
          lastInstallmentDate.add(Duration(days: random.nextInt(30) + 1));

      // Ensure ascending order of installment dates
      lastInstallmentDate = installmentDate;

      // Distribute remaining amount among installments
      double installmentAmount = j == installmentCount
          ? notPaid.toDouble()
          : random.nextInt(notPaid + 1).toDouble();
      notPaid -= installmentAmount.toInt();

      installments.add(Installment(
        type: AppStrings.UpcomingType,
        remindedOn: DateTime.now(),
        reminded: false,
        id: installmentId,
        name: installmentName,
        date: installmentDate,
        amount: installmentAmount,
      ));
    }

    DateTime submissionDate = DateTime.now();
    DateTime contractDate = DateTime.now();

    models.add(PropertyModel(
      id: id,
      type: AppStrings.UpcomingType,
      description: description,
      price: price,
      paid: paid,
      buyerName: buyerName,
      buyerNumber: buyerNumber,
      notPaid: double.parse(notPaid.toString()),
      installments: installments,
      submissionDate: submissionDate,
      contractDate: contractDate,
    ));
  }
  return models;
}


  // Print the generated models
  // models.forEach((model) {
  //   print(model);
  // });