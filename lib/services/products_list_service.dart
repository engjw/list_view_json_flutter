import 'package:dio/dio.dart';

import '../models/product.dart';
import '../repositories/products_list_repository.dart';

class ProductsListService implements ProductsListRepository {
  final Dio _dio = Dio();

  @override
  Future<ProducsListResponseModel?> getProductsList() async {
    try {
      final response = await _dio.get('https://api.jsonserve.com/Ibwq3i');
      if (response.statusCode == 200) {
        return ProducsListResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      return null;
    }
  }
}
