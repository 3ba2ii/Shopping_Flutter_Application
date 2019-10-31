import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderWidget extends StatefulWidget {
  final OrderItem order;

  OrderWidget(this.order);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return  Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Your Order Total : \$${widget.order.amount}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy/hh:mm')
                        .format(widget.order.dateTime),
                  ),
                  trailing: IconButton(
                    icon:
                        Icon(expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                  ),
                ),
                if (expanded)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    height: min(widget.order.products.length * 20.0 + 20, 180),
                    child: ListView.builder(
                      itemCount: widget.order.products.length,
                      itemBuilder: (ctx, i) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.order.products[i].title,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Text(
                                  '\$${(widget.order.products[i].price * widget.order.products[i].quantity)}'),
                              Text('x${widget.order.products[i].quantity}'),
                            ],
                          ),
                    ),
                  )
              ],
            ),
          );
  }
}
