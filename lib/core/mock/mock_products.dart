import '../../models/product.dart';

/// Placeholder catalog for UI-first development.
/// TODO: remove once ProductProvider pulls from Firestore.
final List<Product> mockProducts = [
  Product(
    id: 'p1',
    name: 'XPS 13 Plus 9320',
    brand: 'Dell',
    category: 'Laptops',
    price: 1299,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBsKLl2_wpqAMdTLtOa4MlUT9I8pJyeCckTX4SRByknqTJ27B_wj-4dgi1fFII8rcRhEdb9FTjj_AJey_WieTQxFtlJXemnz3qGFgM4Uuv-ftnicFCFm-jvCJBk_ubtb30X-u2u0U1NIKcQY55dXilFx84XNE8cxGlBsA79Xqlc0nRcmx3ACRd-57sJIDNctwc2uDthQllAh9qh6T59dukW1Cbftec45GlZ9i0TDZ193e55Ty-pMyNu',
    ],
    rating: 4.8,
    reviewCount: 124,
    stock: 12,
  ),
  Product(
    id: 'p2',
    name: 'Blade 16 Gaming Laptop',
    brand: 'Razer',
    category: 'Gaming',
    price: 2899,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBOXWreMXLZxCFUrX4aicWXCo-3jWqgRkEfVmC0UYHxMg0Z9loIUATRB_ixpPj0g5Wq1vX9xIP8mbiWKoREKaOxA4lxfTQ42yEzeynRhs5sAvfZ_XnuuSarpOYvY-Do983m8prYHVUVqZbUUcjzeRC5J05-Bt_exnJJ6WWv08Pdd24NKUeDu8mtZTWl3nYlHlcC6EeA_VWK81eHeQNsh1XAaGhiojTfXkjhYpxTaT7bNxgTaLehrrr9',
    ],
    rating: 4.9,
    reviewCount: 89,
    stock: 6,
  ),
  Product(
    id: 'p3',
    name: 'MacBook Pro 14-inch',
    brand: 'Apple',
    category: 'Laptops',
    price: 1999,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCgJz0abq-vBvxOfWn3MQPRDA_dq3LRETsKSJZLkiEZaFKZ8SYHqaASQTyfdqAIEQAlqyrg3dO5KsUAuPuvEEuetkdv5rklgPNbAkoE0GNPNvVFwqdOMJNoUzYeJf0OU0uh50vUCq6S_4HB0DHVFNKAQl2ZCm8UmVnrQJkwEWZJx12pSjqJczxTQ2M2G7YT6ParEiT0GsXCfZoL3LTIzLLEOFwdgxbRclhqnIKmK_Gf3fZRGJrBS2IW',
    ],
    rating: 5.0,
    reviewCount: 542,
    stock: 20,
  ),
  Product(
    id: 'p4',
    name: 'Spectre x360 14',
    brand: 'HP',
    category: 'Business',
    price: 1449,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDs47T83wY_FGEUCeFTL3EXE3HSsPEj4SFB5bebRSAP0mXBlVO0_RKzUBJoB3xxhaL5fF_LCpJZF7fDLTg5vhfrN3BRjvtiLhYAF2Bs898oAwSttXefI_Qy5uZKf9mMujndmA1kHw-MFHMnhYWad7TvZOsurgplPbR066-dHbNb2DOgGEgJhHWN0SslVIUZUUyZTjWDfpv4DVSzkgw0b_PdcAfvAA_Jc6613zzeIBjPUyJdfcABbuv0',
    ],
    rating: 4.7,
    reviewCount: 215,
    stock: 15,
  ),
];

const List<String> mockCategories = [
  'Laptops',
  'Accessories',
  'Gaming',
  'Business',
  'Workstations',
];