import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../routes/user_product_screen.dart';
import '../routes/order_screen.dart';
import '../routes/product_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            child: AppBar(
              leading: Icon(
                Icons.person,
                size: 25,
              ),
              title: Text(
                'Hello, User',
                style: TextStyle(color: Colors.white),
              ),
              automaticallyImplyLeading: false,
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(
              Icons.shop,
              size: 30,
            ),
            title: Text('Our Products',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            subtitle: Text('Wish & Buy'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductOverviewScreen.routeName),
          ),
          Divider(height: 10, color: Colors.black45),
          ListTile(
            leading: Icon(Icons.payment, size: 30),
            title: Text('Orders and Payment',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            subtitle: Text('You will find all your orders here.'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
          ),
          Divider(height: 10, color: Colors.black45),
          ListTile(
            leading: Icon(Icons.edit, size: 30),
            title: Text('Manage Products',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            subtitle: Text('You can edit and delete product freely.'),
            onTap: () =>
                Navigator.of(context).pushNamed(UserProductScreen.routeName),
          ),
          Divider(
            height: 10,
            color: Colors.black45,
          ),
          ListTile(
            leading: Icon(
              Icons.room_service,
              size: 30,
            ),
            title: Text('Customer Service',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            subtitle: Text('Just joking, we don\'t have one.'),
          ),
          Divider(
            height: 10,
            color: Colors.black45,
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 30,
            ),
            title: Text('Logout',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context,listen: false).logout();
                },
          ),
          Spacer(),
          Padding(
            child: Text(
              'Feel free to help you with pleasure...',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
              textAlign: TextAlign.start,
            ),
            padding: EdgeInsets.symmetric(vertical: 15),
          )
        ],
      ),
    );
  }
}
