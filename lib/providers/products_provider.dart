import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:my_test/models/http_exceptions.dart';
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'assets/images/t-shirt.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl: 'assets/images/trouser.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'assets/images/scarf.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'assets/images/iron-pan.jpg',
    ), 
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  bool get noProducts {
    var noProduct = false;
    if (items == []) {
      noProduct = true;
    } else {
      noProduct = false;
    }
    notifyListeners();
    return noProduct;
  }

  Future<void> fetchAndSetProduct([bool filterByUser=false]) async {
    final filterString = filterByUser ?'orderBy="creatorId"&equalTo="$userId"':'' ;
    var url =
        'https://flutter-upgrade.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url); //just get data
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-upgrade.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      if (extractedData != null) {
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              description: prodData['description'],
              title: prodData['title'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
              imageUrl: prodData['imageUrl'],
            ),
          );
        });
      }

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final String url =
        'https://flutter-upgrade.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'id': product.id,
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product product, String id) async {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      final String url =
          'https://flutter-upgrade.firebaseio.com/products/$id.json?auth=$authToken';
      http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[index] = product;
    }

    notifyListeners();
  }

  Future<void> deleteProdct(String id) async {
    final url =
        'https://flutter-upgrade.firebaseio.com/products/$id.json?auth?=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product :( ');
    }
    existingProduct = null;
  }
}
