import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts({String? category, String? brand}) async {
    Query query = _products;
    if (category != null) query = query.where('category', isEqualTo: category);
    if (brand != null) query = query.where('brand', isEqualTo: brand);
    final snap = await query.get();
    return snap.docs
        .map((d) => Product.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Product?> fetchProductById(String id) async {
    final doc = await _products.doc(id).get();
    if (!doc.exists) return null;
    return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<List<Product>> searchProducts(String queryText) async {
    // Simple prefix search; swap for Algolia/Typesense for production-grade search.
    final snap = await _products
        .orderBy('name')
        .startAt([queryText])
        .endAt(['\$queryText\uf8ff'])
        .get();
    return snap.docs
        .map((d) => Product.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }
}
