import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'property_model.g.dart';

@HiveType(typeId: 1)
class PropertyModel {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final String price;
  @HiveField(2)
  final String paid;
  @HiveField(3)
  final String buyerName;
  @HiveField(4)
  final String buyerNumber;
  @HiveField(5)
  final List<Installment> installments;
  @HiveField(6)
  late String id;
  @HiveField(7)
  late String _type = AppStrings.UpcomingType;
  @HiveField(8)
  final DateTime contractDate;
  @HiveField(9)
  final DateTime submissionDate;

  PropertyModel({
    required this.submissionDate,
    required this.contractDate,
    required this.id,
    required this.description,
    required this.price,
    required this.paid,
    required this.buyerName,
    required this.buyerNumber,
    required this.installments,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      submissionDate: (json['submissiondate'] as Timestamp).toDate(),
      contractDate: (json['contractdate'] as Timestamp).toDate(),
      id: json['id'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      paid: json['paid'] as String,
      buyerName: json['buyername'] as String,
      buyerNumber: json['buyernumber'] as String,
      installments: installmentsFromJson(json['installments'] as List),
      // installments: [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "price": price,
      "paid": paid,
      "buyername": buyerName,
      "buyernumber": buyerNumber,
      "installments": installmentsToJson(installments),
      "contractdate": Timestamp.fromDate(contractDate),
      "submissiondate": Timestamp.fromDate(submissionDate),
    };
  }

  double calculateInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      total += double.parse(element.amount);
    });
    return total;
  }

  double calculatePaidInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      if (element.getType() == AppStrings.PaidType)
        total += double.parse(element.amount);
    });
    return total;
  }

  double calculateNotPaidInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      if (element.getType() == AppStrings.NotPaidType)
        total += double.parse(element.amount);
    });
    return total;
  }

  String getType() {
    return _type;
  }

  bool isNotPaid() {
    bool notPaid = false;
    installments.forEach((inst) {
      if (inst.isNotPaid()) {
        notPaid = true;
        return;
      }
    });
    return notPaid;
  }

  void updateType() {
    bool paid = false;
    bool upcoming = false;
    bool notpaid = false;
    installments.forEach((installment) {
      if (installment.getType() == AppStrings.NotPaidType) {
        _type = AppStrings.NotPaidType;
        notpaid = true;
        return;
      }
      if (installment.getType() == AppStrings.UpcomingType) {
        upcoming = true;
      }
    });
    if (notpaid) return;
    if (upcoming) {
      _type = AppStrings.UpcomingType;
      return;
    } else {
      _type = AppStrings.PaidType;
    }
  }

  void setType(String type) {
    _type = type;
  }
}

@HiveType(typeId: 2)
class Installment {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String amount;
  @HiveField(3)
  late String _type = AppStrings.UpcomingType;
  @HiveField(4)
  late bool reminded = false;
  @HiveField(5)
  final String id;

  Installment(
      {required this.reminded,
      required this.id,
      required this.name,
      required this.date,
      required this.amount});

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      reminded: json['reminded'] as bool,
      id: json['id'] as String,
      name: json['name'] as String,
      date: (json['date'] as Timestamp).toDate(),
      amount: json['amount'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date": Timestamp.fromDate(date),
      "amount": amount,
      "reminded": reminded,
    };
  }

  String getType() {
    return _type;
    // if (_type == AppStrings.PaidType) {
    //   return _type;
    // } else if (date.compareTo(DateTime.now()) > 0) {
    //   _type = AppStrings.NotPaidType;
    //   return _type;
    // }
    // _type = AppStrings.UpcomingType;
    // return _type;
  }

  bool isNotPaid() {
    if (_type == AppStrings.UpcomingType) {
      bool notPaid = date.compareTo(DateTime.now()) <= 0;
      if (notPaid) {
        _type = AppStrings.NotPaidType;
        return notPaid;
      }
    }
    return false;
  }

  void payInstallment() {
    _type = AppStrings.PaidType;
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
  print(installmentsJson.length);
  List<Installment> inst = [];
  for (var i in installmentsJson) {
    if (i is Map<String, dynamic>) {
      print("loop");
      inst.add(Installment.fromJson(i as Map<String, dynamic>));
    } else {
      print("INVALID STATMENT");
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

List<PropertyModel> demoPropertyModels = [
  PropertyModel(
    id: "1",
    description: "Villa 37 Compound Princess",
    price: "10000000",
    paid: "5000000",
    buyerName: "Mohamed Mostafa Hussein",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2024, 3, 2),
          amount: "2000000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2025),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2023),
          amount: "2000000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
  PropertyModel(
    id: "2",
    description: "Chalet 5 Compound Palm Hils",
    price: "7000000",
    paid: "5000000",
    buyerName: "Mahmoud Waheed",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2025),
          amount: "500000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2024, 5),
          amount: "500000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2024, 8),
          amount: "500000"),
      Installment(
          reminded: false,
          id: "4",
          name: "1",
          date: DateTime(2024, 12),
          amount: "250000"),
      Installment(
          reminded: false,
          id: "5",
          name: "1",
          date: DateTime(2025),
          amount: "250000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
  PropertyModel(
    id: "3",
    description: "Villa 37 Compound Amwaj",
    price: "10000000",
    paid: "5000000",
    buyerName: "Hassan Khalid",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2025),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2026),
          amount: "500000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2028),
          amount: "500000"),
      Installment(
          reminded: false,
          id: "4",
          name: "1",
          date: DateTime(2025),
          amount: "2000000"),
      Installment(
          reminded: false,
          id: "5",
          name: "1",
          date: DateTime(2023),
          amount: "1000000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
  PropertyModel(
    id: "4",
    description: "Villa 37 Compound Princess",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2024, 5, 8),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "2000000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2024, 3, 8),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "4",
          name: "1",
          date: DateTime(2025, 5, 8),
          amount: "1000000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
  PropertyModel(
    id: "5",
    description: "Challet 45 compound Nivada",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2024, 6, 6),
          amount: "2000000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2024, 4, 4),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "4",
          name: "1",
          date: DateTime(2025),
          amount: "1000000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
  PropertyModel(
    id: "6",
    description: "Villa 37 Compound Princess",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "2000000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "4",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "1000000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
  PropertyModel(
    id: "7",
    description: "Villa 37 Compound Princess",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(
          reminded: false,
          id: "1",
          name: "1",
          date: DateTime(2024, 8, 8),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "2",
          name: "1",
          date: DateTime(2025),
          amount: "2000000"),
      Installment(
          reminded: false,
          id: "3",
          name: "1",
          date: DateTime(2025),
          amount: "1000000"),
      Installment(
          reminded: false,
          id: "4",
          name: "1",
          date: DateTime(2025),
          amount: "1000000"),
    ],
    submissionDate: DateTime.now(),
    contractDate: DateTime.now(),
  ),
];
