import 'package:dripzy/core/utils/result.dart';
import 'package:dripzy/models/product_model.dart';
import 'package:dripzy/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository {
  final ProductService _productService = ProductService();

  Future<Result<List<Product>>> getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access-token') ?? '';

    try {
      final products = await _productService.getAllProducts(
        accessToken: accessToken,
      );
      return Result.success(products);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Product>> getProductById({required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access-token') ?? '';
    try {
      final product = await _productService.getProduct(
        id: productId,
        accessToken: accessToken,
      );
      return Result.success(product);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
