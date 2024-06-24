import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<dynamic> _streamSubscription;

  bool _available = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    setState(() {
      _available = available;
    });

    if (_available) {
      const Set<String> _kIds = <String>{
        'firsttier',
        'secondtier',
        'thirdtier'
      };
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error here
        print('Products not found: ${response.notFoundIDs}');
      }
      setState(() {
        _products = response.productDetails;
      });

      _streamSubscription = _inAppPurchase.purchaseStream.listen(
          (List<PurchaseDetails> purchases) {
        _onPurchasesUpdated(purchases);
      }, onDone: () {
        _streamSubscription.cancel();
      }, onError: (error) {
        // Handle error here
        print('Error: $error');
      });
    }
  }

  void _onPurchasesUpdated(List<PurchaseDetails> purchases) {
    setState(() {
      _purchases = purchases;
    });

    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _verifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle error
        print('Purchase error: ${purchase.error}');
      } else if (purchase.status == PurchaseStatus.pending) {
        // Handle pending
        print('Purchase pending: ${purchase.pendingCompletePurchase}');
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // Verify the purchase with your server or any other verification logic
    // For now, we assume the purchase is verified
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('In-App Purchases'),
        ),
        body: _available
            ? ListView(
                children: _products.map((ProductDetails product) {
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    trailing: ElevatedButton(
                      onPressed: () {
                        final PurchaseParam purchaseParam =
                            PurchaseParam(productDetails: product);
                        _inAppPurchase.buyNonConsumable(
                            purchaseParam: purchaseParam);
                      },
                      child: Text(product.price),
                    ),
                  );
                }).toList(),
              )
            : Center(
                child: Text('The store is not available'),
              ),
      ),
    );
  }
}
