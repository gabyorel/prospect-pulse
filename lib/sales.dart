import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class SalesList extends StatelessWidget {
  final Future<List<Sale>> sales;

  SalesList({required this.sales});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Sale>>(
      future: sales,
      builder: (BuildContext context, AsyncSnapshot<List<Sale>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Aucune vente disponible');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final Sale = snapshot.data![index];
              return ListTile(
                title: Text(Sale.product),
                subtitle: Text('Prix: ${Sale.price} €'),
              );
            },
          );
        }
      },
    );
  }
}

class AddSaleForm extends StatefulWidget {
  @override
  _AddSaleFormState createState() => _AddSaleFormState();
}

class _AddSaleFormState extends State<AddSaleForm> {
  final _formKey = GlobalKey<FormState>();
  String product = '';
  double price = 0;
  int quantity = 0;
  Timestamp date = Timestamp.fromDate(DateTime.now());
  String customer = '';
  String username = 'commercial';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter une vente'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Produit'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir un produit';
                }
                return null;
              },
              onSaved: (value) {
                product = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir un prix';
                }
                return null;
              },
              onSaved: (value) {
                price = double.parse(value!);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir une quantité';
                }
                return null;
              },
              onSaved: (value) {
                quantity = int.parse(value!);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Client'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir un client';
                }
                return null;
              },
              onSaved: (value) {
                quantity = int.parse(value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              final saleRef = FirebaseFirestore.instance.collection('sales');
              await saleRef.add({
                'product': product,
                'price': price,
                'quantity': quantity,
                'date': date,
                'customer': customer,
                'username': username,
              });
              Navigator.of(context).pop();
            }
          },
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des ventes')),
      body: SalesList(
        sales: FirebaseFirestore.instance
            .collection('sales')
            .get()
            .then((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            final data = doc.data();
            return Sale(
              product: data['product'],
              price: data['price'],
              quantity: data['quantity'],
              date: data['date'],
              customer: data['customer'],
              username: data['username'],
            );
          }).toList();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddSaleForm(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
