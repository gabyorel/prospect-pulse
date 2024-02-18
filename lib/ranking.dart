import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:prospect_pulse/sales.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingView();
}

class _RankingView extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sales').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final sales = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map;
            return Sale(
              product: data['product'],
              price: data['price'],
              quantity: data['quantity'],
              date: data['date'],
              customer: data['customer'],
              username: data['username'],
            );
          }).toList();

          Map<String, double> userSales = {};
          for (var sale in sales) {
            userSales[sale.username] = (userSales[sale.username] ?? 0.0) +
                (sale.price * sale.quantity);
          }

          final leaderBoard = userSales.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('LeaderBoard'),
                backgroundColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userSales.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 10.0,
                              ),
                              child: Row(
                                children: [
                                  ProfilePicture(
                                    name: leaderBoard[index].key,
                                    radius: 25,
                                    fontsize: 16,
                                    random: true,
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    '${index + 1}.'.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      leaderBoard[index].key,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Text(
                                    '\$${leaderBoard[index].value.toString()}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
