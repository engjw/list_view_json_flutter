part of 'products_list_bloc.dart';

@immutable
abstract class ProductsListEvent extends Equatable {
  const ProductsListEvent();
}

class LoadProductsList extends ProductsListEvent {
  const LoadProductsList();

  @override
  List<Object?> get props => [];
}
