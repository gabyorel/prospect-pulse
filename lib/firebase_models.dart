import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  final String product;
  final double price;
  final int quantity;
  final Timestamp date;
  final String customer;
  final String username;

  Sale({
    required this.product,
    required this.price,
    required this.quantity,
    required this.date,
    required this.customer,
    required this.username,
  });
}