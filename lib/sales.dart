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

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      body: SalesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to sale form page to add new sale
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSalePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SalesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sales').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
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

        return ListView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            return ListTile(
              title: Text('${sale.quantity} - ${sale.product}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${sale.date.toDate()}'),
                  Text('Prix: \$${sale.price}'),
                  Text('Client: ${sale.customer}'),
                  Text('Commercial: ${sale.username}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class AddSalePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _productController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _customerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajoutez une vente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _productController,
                decoration: InputDecoration(labelText: 'Produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un nom de produit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un prix';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantité'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une quantité';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerController,
                decoration: InputDecoration(labelText: 'Client'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un client';
                  }
                  return null;
                },
              ),
              // Add form fields for other details
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the sale to Firestore
                    FirebaseFirestore.instance.collection('sales').add({
                      'product': _productController.text,
                      'price': double.parse(_priceController.text),
                      'quantity': int.parse(_quantityController.text),
                      'customer': _customerController.text,
                      'date': Timestamp.fromDate(DateTime.now()),
                      'username': 'commercial',
                    });
                    // Navigate back to sales list page
                    Navigator.pop(context);
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
