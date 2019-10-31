import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_widget.dart';
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool isFavs;
  ProductGrid(this.isFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(
        context); //makes only this widget rebuild when it's changed
    final loadedProducts =
        isFavs ? productData.favoriteItems : productData.items;
    return Container(color: Colors.white,
      
      child: loadedProducts.isEmpty
          ? Center(

              child: Image.network(
                  'http://www.esmartstudio.in/no-product-found.jpg',fit: BoxFit.cover,))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: loadedProducts.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: loadedProducts[index],
                  child: ProductItem(),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
    );
  }
}
