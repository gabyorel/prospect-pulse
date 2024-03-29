import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospect_pulse/firebase_models.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Sales'),
          backgroundColor: Colors.white,
      ),
      body: const SalesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSalePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SalesList extends StatelessWidget {
  const SalesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sales').orderBy('date', descending: true).snapshots(),
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
  AddSalePage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajoutez une vente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(labelText: 'Produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un nom de produit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un prix';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantité'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une quantité';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerController,
                decoration: const InputDecoration(labelText: 'Client'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un client';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection('sales').add({
                      'product': _productController.text,
                      'price': double.parse(_priceController.text),
                      'quantity': int.parse(_quantityController.text),
                      'customer': _customerController.text,
                      'date': Timestamp.fromDate(DateTime.now()),
                      'username': FirebaseAuth.instance.currentUser!.email,
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
