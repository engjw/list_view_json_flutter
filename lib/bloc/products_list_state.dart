part of 'products_list_bloc.dart';

@immutable
abstract class ProductsListState extends Equatable {}

class ProductsListLoading extends ProductsListState {
  @override
  List<Object?> get props => [];
}

class ProductsListLoaded extends ProductsListState {
  final ProducsListResponseModel productsListResponseData;

  ProductsListLoaded(this.productsListResponseData);

  @override
  List<Object?> get props => [productsListResponseData];
}
