import 'package:dio/dio.dart';
import 'package:dripzy/core/api/api_constants.dart';
import 'package:dripzy/models/product_model.dart';

class ProductService {
  final Dio dio = Dio();

  //get all products
  Future<List<Product>> getAllProducts({required String accessToken}) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl + ApiConstants.getAllProducts,
        options: Options(headers: {'access-token': accessToken}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productData = response.data['products'];
        return productData
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception(
        'Failed to fetch products, status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No products found');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Internal server error');
      } else {
        throw Exception('Failed to fetch products: ${e.message}');
      }
    }
  }

  //get specific product
  Future<Product> getProduct({
    required String id,
    required String accessToken,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl + ApiConstants.getProductById(id),
        options: Options(headers: {'access-token': accessToken}),
      );
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
      throw Exception(
        'Failed to fetch product, status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Product not found');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Internal server error');
      } else {
        throw Exception('Failed to fetch product: ${e.message}');
      }
    }
  }
}
