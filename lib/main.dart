import 'package:flutter/material.dart';
import 'package:listview_json_parse_demo/screens/product_detail_screen.dart';
import 'package:listview_json_parse_demo/screens/products_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Interview Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListScreen(),
        routes: {
          ProductListScreen.routeName: (context) => ProductListScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen()
        },      
    );
  }
}
