import 'package:admin/resources/Managers/strings_manager.dart';
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
  final String id;
  @HiveField(7)
  late String _type = AppStrings.UpcomingType;

  PropertyModel({
    required this.id,
    required this.description,
    required this.price,
    required this.paid,
    required this.buyerName,
    required this.buyerNumber,
    required this.installments,
  });
  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "price": price,
      "paid": paid,
      "buyername": buyerName,
      "buyernumber": buyerNumber,
      "installments": installmentsToJson(installments)
    };
  }

  double calculateInstallments() {
    double total = 0.0;
    installments.forEach((element) {
      total += double.parse(element.amount);
    });
    return total;
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

  Installment({required this.name, required this.date, required this.amount});
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "date": date,
      "paid": amount,
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
    return date.compareTo(DateTime.now()) > 0;
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

List<PropertyModel> demoPropertyModels = [
  PropertyModel(
    id: "1",
    description: "Villa 37 Compound Princess",
    price: "10000000",
    paid: "5000000",
    buyerName: "Mohamed Mostafa Hussein",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
      Installment(name: "1", date: DateTime(2025), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
    ],
  ),
  PropertyModel(
    id: "2",
    description: "Villa 5 Compound Palm Hils",
    price: "7000000",
    paid: "5000000",
    buyerName: "Mahmoud Waheed",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime.now(), amount: "500000"),
      Installment(name: "1", date: DateTime.now(), amount: "500000"),
      Installment(name: "1", date: DateTime.now(), amount: "500000"),
      Installment(name: "1", date: DateTime.now(), amount: "250000"),
      Installment(name: "1", date: DateTime.now(), amount: "250000"),
    ],
  ),
  PropertyModel(
    id: "3",
    description: "Villa 37 Compound Amwaj",
    price: "10000000",
    paid: "5000000",
    buyerName: "Hassan Khalid",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "500000"),
      Installment(name: "1", date: DateTime.now(), amount: "500000"),
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
    ],
  ),
  PropertyModel(
    id: "4",
    description: "Villa 37 Compound Princess",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
    ],
  ),
  PropertyModel(
    id: "5",
    description: "Challet 45 compound Nivada",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime(2025), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime(2025), amount: "1000000"),
    ],
  ),
  PropertyModel(
    id: "6",
    description: "Villa 37 Compound Princess",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
    ],
  ),
  PropertyModel(
    id: "7",
    description: "Villa 37 Compound Princess",
    price: "5000000",
    paid: "1000000",
    buyerName: "Youssef Ammar",
    buyerNumber: "01100888552",
    installments: [
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "2000000"),
      Installment(name: "1", date: DateTime(2025), amount: "1000000"),
      Installment(name: "1", date: DateTime.now(), amount: "1000000"),
    ],
  ),
];
