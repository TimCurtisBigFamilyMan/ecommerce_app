import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Connection failed');
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _products;
    // return Stream.value(_products);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  // debugPrint('created productsListStreamProvider');
  final producstRepository = ref.watch(productsRepositoryProvider);
  return producstRepository.watchProductsList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final producstRepository = ref.watch(productsRepositoryProvider);
  return producstRepository.fetchProductsList();
});

final productProvider = StreamProvider.autoDispose.family<Product?, String>(
  (ref, id) {
    // debugPrint('created productProvider with id: $id');
    // ref.onDispose(() => debugPrint('Disposed productProvider'));

    final productsRepository = ref.watch(productsRepositoryProvider);
    return productsRepository.watchProduct(id);
  },
  // disposeDelay:10  ,
  // cacheTime:10,
);
