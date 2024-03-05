import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:hive/hive.dart';

part 'property_model.g.dart';

@HiveType(typeId: 1)
class PropertyModel {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final double price;
  @HiveField(2)
  double paid;
  @HiveField(3)
  final String buyerName;
  @HiveField(4)
  final String buyerNumber;
  @HiveField(5)
  final List<Installment> installments;
  @HiveField(6)
  late String id;
  @HiveField(7)
  late String type = AppStrings.UpcomingType;
  @HiveField(8)
  final DateTime contractDate;
  @HiveField(9)
  final DateTime submissionDate;
  @HiveField(10)
  double notPaid;

  PropertyModel({
    required this.notPaid,
    required this.submissionDate,
    required this.contractDate,
    required this.id,
    required this.description,
    required this.price,
    required this.paid,
    required this.buyerName,
    required this.buyerNumber,
    required this.installments,
    required this.type,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      submissionDate: DateTime.parse(json['submissiondate']),
      contractDate: DateTime.parse(json['contractdate']),
      id: json['_id'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      paid: json['paid'] as double,
      buyerName: json['buyername'] as String,
      buyerNumber: json['buyernumber'] as String,
      installments: installmentsFromJson(
        json['installments'] as List,
      ),
      notPaid: json['notpaid'] as double,
      type: json['type'] as String,

      // installments: [],
    );
    // return PropertyModel(
    //   submissionDate: DateTime.parse(json['submissiondate']),
    //   contractDate: DateTime.parse(json['contractdate']),
    //   id: json['_id'] as String,
    //   description: json['description'] as String,
    //   price: (json['price'] as int).toDouble(),
    //   paid: (json['paid'] as int).toDouble(),
    //   buyerName: json['buyername'] as String,
    //   buyerNumber: json['buyernumber'] as String,
    //   installments: installmentsFromJson(
    //     json['installments'] as List,
    //   ),
    //   notPaid: (json['notpaid'] as int).toDouble(),
    //   type: json['type'] as String,

    //   // installments: [],
    // );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "type": type,
      "price": price,
      "paid": paid,
      "notpaid": notPaid,
      "buyername": buyerName,
      "buyernumber": buyerNumber,
      "installments": installmentsToJson(installments),
      "contractdate": dateToString(contractDate),
      "submissiondate": dateToString(submissionDate),
    };
  }

  // double calculateInstallments() {
  //   double total = 0.0;
  //   installments.forEach((element) {
  //     total += double.parse(element.amount);
  //   });
  //   return total;
  // }

  double calculateUpcomingInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      if (element.getType() == AppStrings.UpcomingType) total += element.amount;
    });
    return total;
  }

  double calculatePaidInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      if (element.getType() == AppStrings.PaidType) total += element.amount;
    });
    return total;
  }

  double calculateNotPaidInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      if (element.getType() == AppStrings.NotPaidType) total += element.amount;
    });
    return total;
  }

  String getType() {
    return type;
  }

  List<int> isNotPaid() {
    bool isnotPaid = false;
    List<int> notpaidIndices = [];
    int index = 0;
    DateTime currDateWithoutTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime instDate = DateTime.now();
    for (Installment inst in installments) {
      instDate = DateTime(inst.date.year, inst.date.month, inst.date.day);
      if (instDate.compareTo(currDateWithoutTime) <= 0) {
        if (inst.isNotPaid()) {
          type = AppStrings.NotPaidType;
          notPaid += inst.amount;
          isnotPaid = true;
          notpaidIndices.add(index);
          // return;
        }
      } else
        break;
      index++;
    }
    return notpaidIndices;
  }

  void updateType() {
    // bool paid = false;
    bool upcoming = false;
    bool notpaid = false;
    for (Installment installment in installments) {
      if (installment.getType() == AppStrings.NotPaidType) {
        type = AppStrings.NotPaidType;
        notpaid = true;
        break;
      }
      if (installment.getType() == AppStrings.UpcomingType) {
        upcoming = true;
      }
    }
    if (notpaid) return;
    if (upcoming) {
      type = AppStrings.UpcomingType;
      return;
    } else {
      type = AppStrings.PaidType;
    }
  }

  void setType(String type) {
    type = type;
  }
}

@HiveType(typeId: 2)
class Installment {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  late String type = AppStrings.UpcomingType;
  @HiveField(4)
  late bool reminded = false;
  @HiveField(5)
  final String id;
  @HiveField(6)
  late DateTime remindedOn;

  Installment({
    required this.reminded,
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.remindedOn,
    required this.type,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      remindedOn: DateTime.parse(json['remindedon']),
      type: json['type'] as String,
      reminded: json['reminded'] as bool,
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date']),
      amount: json['amount'] as double,
    );
    // return Installment(
    //   remindedOn: DateTime.parse(json['remindedon']),
    //   type: json['type'] as String,
    //   reminded: json['reminded'] as bool,
    //   id: json['id'] as String,
    //   name: json['name'] as String,
    //   date: DateTime.parse(json['date']),
    //   amount: (json['amount'] as int).toDouble(),
    // );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date": dateToString(date),
      "amount": amount,
      "reminded": reminded,
      "remindedon": dateToString(remindedOn),
      "type": type,
    };
  }

  String getType() {
    return type;
    // if (type == AppStrings.PaidType) {
    //   return type;
    // } else if (date.compareTo(DateTime.now()) > 0) {
    //   type = AppStrings.NotPaidType;
    //   return type;
    // }
    // type = AppStrings.UpcomingType;
    // return type;
  }

  bool isNotPaid() {
    print(type);
    if (type == AppStrings.UpcomingType) {
      DateTime currDateWithoutTime = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime instDate = DateTime(date.year, date.month, date.day);
      bool notPaid = instDate.compareTo(currDateWithoutTime) <= 0;
      if (notPaid) {
        type = AppStrings.NotPaidType;
        return notPaid;
      }
    }
    return false;
  }

  void setType(String string) {
    type = string;
  }

  void payInstallment() {
    type = AppStrings.PaidType;
  }
}

List<Map<String, dynamic>> installmentsToJson(List<Installment> installments) {
  List<Map<String, dynamic>> inst = [];
  for (var i in installments) {
    inst.add(i.toJson());
  }

  return inst;
}

List<Installment> installmentsFromJson(List<dynamic> installmentsJson) {
  // print(installmentsJson.length);
  List<Installment> inst = [];
  for (var i in installmentsJson) {
    if (i is Map<String, dynamic>) {
      // print("loop");
      inst.add(Installment.fromJson(i));
    } else {
      // print("INVALID STATMENT");
    }
  }

  return inst;
}

// List<Installment> installmentsFromJson(
//     List<Map<String, dynamic>> installmentsJson) {
//   print(installmentsJson.length);
//   List<Installment> inst = [];
//   for (var i in installmentsJson) {
//     print("loop");
//     inst.add(Installment.fromJson(i));
//   }

//   return inst;
// }

// List<PropertyModel> demoPropertyModels = [
//   PropertyModel(
//     id: "1",
//     description: "Villa 37 Compound Princess",
//     price: 10000000,
//     paid: 5000000,
//     notPaid: 0,
//     buyerName: "Mohamed Mostafa Hussein",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2024, 3, 2),
//           amount: 2000000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2025),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2023),
//           amount: 2000000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
//   PropertyModel(
//     id: "2",
//     description: "Chalet 5 Compound Palm Hils",
//     price: 7000000,
//     paid: 5000000,
//     notPaid: 0,
//     buyerName: "Mahmoud Waheed",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2025),
//           amount: 500000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2024, 5),
//           amount: 500000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2024, 8),
//           amount: 500000),
//       Installment(
//           reminded: false,
//           id: "4",
//           name: "1",
//           date: DateTime(2024, 12),
//           amount: 250000),
//       Installment(
//           reminded: false,
//           id: "5",
//           name: "1",
//           date: DateTime(2025),
//           amount: 250000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
//   PropertyModel(
//     id: "3",
//     description: "Villa 37 Compound Amwaj",
//     price: 10000000,
//     paid: 5000000,
//     notPaid: 0,
//     buyerName: "Hassan Khalid",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2025),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2026),
//           amount: 500000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2028),
//           amount: 500000),
//       Installment(
//           reminded: false,
//           id: "4",
//           name: "1",
//           date: DateTime(2025),
//           amount: 2000000),
//       Installment(
//           reminded: false,
//           id: "5",
//           name: "1",
//           date: DateTime(2023),
//           amount: 1000000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
//   PropertyModel(
//     id: "4",
//     description: "Villa 37 Compound Princess",
//     price: 5000000,
//     paid: 1000000,
//     notPaid: 0,
//     buyerName: "Youssef Ammar",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2024, 5, 8),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 2000000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2024, 3, 8),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "4",
//           name: "1",
//           date: DateTime(2025, 5, 8),
//           amount: 1000000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
//   PropertyModel(
//     id: "5",
//     description: "Challet 45 compound Nivada",
//     price: 5000000,
//     paid: 1000000,
//     notPaid: 0,
//     buyerName: "Youssef Ammar",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2024, 6, 6),
//           amount: 2000000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2024, 4, 4),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "4",
//           name: "1",
//           date: DateTime(2025),
//           amount: 1000000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
//   PropertyModel(
//     id: "6",
//     description: "Villa 37 Compound Princess",
//     price: 5000000,
//     paid: 1000000,
//     notPaid: 0,
//     buyerName: "Youssef Ammar",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 2000000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "4",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 1000000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
//   PropertyModel(
//     id: "7",
//     description: "Villa 37 Compound Princess",
//     price: 5000000,
//     paid: 1000000,
//     notPaid: 0,
//     buyerName: "Youssef Ammar",
//     buyerNumber: "01100888552",
//     installments: [
//       Installment(
//           reminded: false,
//           id: "1",
//           name: "1",
//           date: DateTime(2024, 8, 8),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "2",
//           name: "1",
//           date: DateTime(2025),
//           amount: 2000000),
//       Installment(
//           reminded: false,
//           id: "3",
//           name: "1",
//           date: DateTime(2025),
//           amount: 1000000),
//       Installment(
//           reminded: false,
//           id: "4",
//           name: "1",
//           date: DateTime(2025),
//           amount: 1000000),
//     ],
//     submissionDate: DateTime.now(),
//     contractDate: DateTime.now(),
//   ),
// ];
