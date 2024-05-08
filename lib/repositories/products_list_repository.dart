import '../models/product.dart';

abstract class ProductsListRepository {
  const ProductsListRepository();

  Future<ProducsListResponseModel?> getProductsList();
}
