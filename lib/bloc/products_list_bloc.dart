import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/products_list_service.dart';
import '../models/product.dart';
part 'products_list_event.dart';
part 'products_list_state.dart';

class ProductsListBloc extends Bloc<ProductsListEvent, ProductsListState> {
  ProductsListBloc() : super(ProductsListLoading()) {
    on<LoadProductsList>(_onLoadProductsList);
  }

  Future<void> _onLoadProductsList(
      LoadProductsList event, Emitter<ProductsListState> emit) async {
    emit(ProductsListLoading());
    await ProductsListService().getProductsList().then((value) => {
          emit(
            ProductsListLoaded(value!),
          )
        });
  }
}
