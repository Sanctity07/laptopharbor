import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> products = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedBrand;
  String sortBy = 'name'; // name | price | rating

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();
    products = await _service.fetchProducts(category: selectedCategory, brand: selectedBrand);
    _applySort();
    isLoading = false;
    notifyListeners();
  }

  void setCategory(String? category) {
    selectedCategory = category;
    loadProducts();
  }

  void setSort(String sort) {
    sortBy = sort;
    _applySort();
    notifyListeners();
  }

  void _applySort() {
    switch (sortBy) {
      case 'price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
  }
}
