import '../../models/cart_item.dart';

/// Placeholder cart contents for UI-first development.
/// TODO: remove once CartProvider pulls from Firestore.
final List<CartItem> mockCartItems = [
  CartItem(
    productId: 'c1',
    name: 'ProStream Ultra 16"',
    subtitle: '32GB RAM, 1TB SSD, M2 Max Chip',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCed7nKOaJEpuLInpqT7zIkoHn4mJVLJuCsYCgUnkrrbrmnfxnd6VpZ6-qYmeQN0MSMKm9BTllJ-84NzUq-YAKmNCeKgR10e0oAzs5bmBWUHdnMME7eLfxq_iq0lZzJBbD7CxwlNjLMEL6FoeGh2_6E-bsvdBjg6olUeXHVoxEBf4GaD4PJKedjnkc3yJtfINsjiwwDsVC4b8UrqflHEAb7PyjQClNK3Ti-LaMJq_h8NkjqppRaxVj6',
    priceAtAdd: 2499,
    quantity: 1,
  ),
  CartItem(
    productId: 'c2',
    name: 'Precision Click V4',
    subtitle: 'Wireless, 26,000 DPI, Teal Accents',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCxqbmDrKelEuM6XRG3aJuzPvcs38E8GFToVt2oCobb8bL5HYHS9xrVDGVoMM55_5xe_yT4K8FguQ22MKjVlziSJg_l1sOxUjsz-wo7Wt2-wwfssEFQ6ZkFRUXmUAqRLglJP-o5jjjrzFE_J4-yI5lKgSKSntr6qkckxJmlRuExl0o0Jckm5f2WJ5Y-Uc4Ecf8IE7lCwfX5ovBcaFVCrbEOiIJSjls54HZ2T2mC7Fyry-FfAWE0q1FR',
    priceAtAdd: 129,
    quantity: 2,
  ),
  CartItem(
    productId: 'c3',
    name: 'Executive Leather Sleeve',
    subtitle: '16" Midnight Indigo, Water-resistant',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC5iQ85VWn1LPXcF8gE-19YvuqKH0NiBuuoh4pAFFmrkChZFkv_-pyNOE-h65Q5I6xPrrdU3et3hLzRnCfHxpnHsH1n_99Ek5SDW0b6_0Ojo1JOcMKYXNJdD1DGPZMPPBeaaboadDeGO4s6puycN7_eGf1a8FKCJ68zIJV9JX6ZySIr8VXj6MUrgoCAhuIDSOGf2Rshs73nnGXAO7rutRgejLpq_F4gs0hpQrD5O7RGRCgMFg9vQBOq',
    priceAtAdd: 89,
    quantity: 1,
  ),
];