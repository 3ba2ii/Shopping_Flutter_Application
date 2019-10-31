import 'package:flutter/material.dart';
import 'package:my_test/routes/edit_product_screen.dart';
import 'package:my_test/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_proudct_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'userProductScreen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: products.items.isEmpty
            ? Container(
                color: Colors.white,
                child: Center(
                    child: Image.network(
                  'http://www.esmartstudio.in/no-product-found.jpg',
                  fit: BoxFit.cover,
                )))
            : Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: products.items.length,
                  itemBuilder: (ctx, i) => UserProductItem(
                        products.items[i].title,
                        products.items[i].imageUrl,
                        products.items[i].price,
                        products.items[i].id,
                      ),
                ),
              ),
      ),
    );
  }
}
