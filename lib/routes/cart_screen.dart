import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_widget.dart';
import './order_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      backgroundColor: cart.itemCount == 0 ? Colors.white : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.itemCount == 0
          ? Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: Image.asset(
                    'assets/images/box.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'You didn\'t add anything to your cart yet :( ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )
          : Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        new OrderButton(cart: cart)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (ctx, i) {
                      return CartItem(
                        cart.items.values.toList()[i].id,
                        cart.items.keys.toList()[i],
                        cart.items.values.toList()[i].title,
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black12,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'To remove an item from your cart just swipe it to the left',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(), widget.cart.totalAmount);

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please check your orders\' list'),
          duration: Duration(seconds: 4),
        ));

        setState(() {
          _isLoading = false;
        });
        
         widget.cart.clearData();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
