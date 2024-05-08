import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_detail_screen.dart';
import 'dart:convert';

import '../bloc/products_list_bloc.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  static const String routeName = '/product-list';

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  int currentMax = 4;
  int itemsPerPage = 4;
  int totalDataCount = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  // Future<void> readJsonFile() async {
  //   final String response = await rootBundle.loadString('assets/product.json');
  //   final productData = await json.decode(response);

  //   var list = productData["items"] as List<dynamic>;

  //   setState(() {
  //     allProducts = [];
  //     allProducts = list.map((e) => Product.fromJson(e)).toList();
  //     filteredProducts = allProducts;
  //   });
  // }

  void _runFilter(String searchKeyword) {
    List<Product> results = [];

    if (searchKeyword.isEmpty) {
      results = allProducts;
    } else {
      results = allProducts
          .where((element) =>
              element.name.toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();
    }

    // refresh the UI
    setState(() {
      filteredProducts = results;
      if (filteredProducts.length < 4) {
        currentMax = filteredProducts.length;
      } else {
        currentMax = 4;
      }

      totalDataCount = filteredProducts.length;
    });
  }

  Future<void> _onScroll() async {
    if (_isBottom) {
      //because with existing data, it will load very fast, so add one sec to view the loading icon
      await Future.delayed(const Duration(seconds: 1));
      if (currentMax < totalDataCount) {
        setState(() {
          if (currentMax + itemsPerPage > totalDataCount) {
            currentMax = totalDataCount;
          } else {
            currentMax += itemsPerPage;
          }
        });
      }
    }
  }

  bool get _isBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("First Gen MINI R50/R52/R53 Guide"),
        ),
        body: BlocProvider(
          create: (context) => ProductsListBloc()..add(LoadProductsList()),
          child: BlocConsumer<ProductsListBloc, ProductsListState>(
            listener: (context, state) {
              if (state is ProductsListLoaded) {
                totalDataCount = state.productsListResponseData.items.length;
                allProducts = state.productsListResponseData.items;

                if (allProducts.length < 4) {
                  currentMax = allProducts.length;
                } else {
                  currentMax = 4;
                }
                filteredProducts = allProducts;
              }
            },
            builder: (context, state) {
              if (state is ProductsListLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ProductsListLoaded) {
                return Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(15.0),
                    //   child: ElevatedButton(onPressed: readJsonFile, child: Text("Load Data")),
                    // ),

                    // if (allProducts.length > 0)

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: Column(
                        children: [
                          // SizedBox(
                          //   height: 10,
                          // ),
                          TextField(
                            onChanged: (value) => _runFilter(value),
                            decoration: InputDecoration(
                                labelText: 'Search',
                                suffixIcon: Icon(Icons.search)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<ProductsListBloc>(context).add(
                          LoadProductsList(),
                        );
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: currentMax + 1,
                        itemBuilder: (BuildContext context, index) {
                          if (index == currentMax) {
                            return (index < totalDataCount)
                                ? Center(child: CircularProgressIndicator())
                                : Text("End of list");
                          } else {
                            return Dismissible(
                              key: ValueKey(
                                  filteredProducts[index].id.toString()),
                              background: Container(
                                color: Colors.redAccent,
                                child: Icon(Icons.delete,
                                    color: Colors.white, size: 40),
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.all(8.0),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Please Confirm"),
                                    content: Text(
                                        "Are you sure you want to delete?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                          child: Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop(true);
                                          },
                                          child: Text("Delete")),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (DismissDirection direction) {
                                if (direction == DismissDirection.endToStart) {
                                  filteredProducts.removeAt(index);
                                }
                              },
                              child: Card(
                                  margin: EdgeInsets.all(5.0),
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        filteredProducts[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              filteredProducts[index].image,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            filteredProducts[index]
                                                .shortdes
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // print(jsonEncode(products[index]));
                                      Navigator.of(context).pushNamed(
                                          ProductDetailScreen.routeName,
                                          arguments: jsonEncode(
                                              filteredProducts[index]));
                                    },
                                  )),
                            );
                          }
                        },
                      ),
                    )),
                    SizedBox(
                      height: 30,
                    )

                    // else
                    // Container(child: Text("No products"),)
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
