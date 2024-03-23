import 'package:admin/data/models/property_model.dart';
import 'dart:math';

import 'package:admin/resources/Managers/strings_manager.dart';

List<String> firstName = [
  "Mahmoud",
  "Ahmed",
  "Hussein",
  "Samir",
  "Khalid",
  "Youssef",
  "Hamdy",
  "Hany",
  "Seif",
  "Nagib"
];
List<String> middleName = [
  "Abdelreheem",
  "Sultan",
  "Omar",
  "Rady",
  "Khalid",
  "Sayed",
  "Hamdy",
  "Hassan",
  "Khalifa",
  "Nagib"
];
List<String> lastName = [
  "Kareem",
  "Abdelrahman",
  "Hisham",
  "Akram",
  "Ziad",
  "Saeed"
];
List<String> compoundNames = [
  "Porto Golf",
  "Porto Sokhna",
  "Princess",
  "Amwaj",
  "Marassi",
  "Mountain View",
  "Jasmine",
  "Beverly Hills",
];
List<String> cityNames = [
  "North Coast",
  "Sheikh Zayed",
  "5th Settlement",
];

List<PropertyModel> getRandomData() {
  List<PropertyModel> models = [];
  Random random = Random();

  for (int i = 1; i <= 50; i++) {
    String id = i.toString();
    String description =
        "Chalett $i in Compound ${compoundNames[random.nextInt(compoundNames.length)]} in ${cityNames[random.nextInt(cityNames.length)]}";
    // double price = (random.nextInt(5000000) + 1000000).toDouble();
    // double paid = (random.nextInt(price.toInt() + 1)).toDouble();
    double price = (random.nextInt(20) + 1) *
        250000.toDouble(); // Generates numbers like 25000, 50000, ..., 500000
    double paid = (random.nextInt((price ~/ 500).toInt())) * 500.toDouble();
    String buyerName =
        "${firstName[random.nextInt(firstName.length)]} ${middleName[random.nextInt(middleName.length)]} ${lastName[random.nextInt(lastName.length)]}";
    String buyerNumber = "01100${random.nextInt(99999999)}";
    int notPaid = (price - paid).toInt();
    List<Installment> installments = [];

    int installmentCount = random.nextInt(20) + 1;
    // int year = random.nextInt(3) + 2023;
    DateTime lastInstallmentDate =
        DateTime(2024, random.nextInt(2) + 2, random.nextInt(28) + 1);

    for (int j = 1; j <= installmentCount; j++) {
      String installmentId = j.toString();
      String installmentName = j.toString();
      // DateTime installmentDate =
      //     lastInstallmentDate.add(Duration(days: random.nextInt(30) + 1));

      DateTime installmentDate = lastInstallmentDate.add(Duration(days: 5));

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
      lastActiveIndex: -1,
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