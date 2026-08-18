import '../../models/product.dart';

/// Placeholder catalog for the Pro Laptops listing screen.
/// TODO: remove once ProductProvider pulls from Firestore.
final List<Product> mockListingProducts = [
  Product(
    id: 'l1',
    name: 'Blade Pro 16 X',
    brand: 'Razor Systems',
    category: 'Laptops',
    price: 2499,
    originalPrice: 2899,
    isNew: true,
    specs: const {
      'CPU': 'Intel Core i9 14th Gen',
      'GPU': 'RTX 4080 (12GB)',
      'RAM': '32GB DDR5',
    },
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAHr0hQKEajtFg5ADThx0jSlK3K-fbmODm20bLSotNNv_S8UScBpIwSb9h8P5jBf61kjzKtspLen52HUq5mdaxZQFkr9gRRqLgiwE6RJtEOwqzVL8n5UKu93CaMyxjFEojrY5WIPOusis5v-T17Ni2tA5RlcTMTSDKqF3xEY4hkbFdP1Y66H7W3zGWWYimMvMUnR7-RJj73lw6YJpQgfGvtLdbrmQjAgjvrpLcVwmtymU08Ml6MqNJQ',
    ],
    rating: 4.8,
    reviewCount: 96,
    stock: 8,
  ),
  Product(
    id: 'l2',
    name: 'Zenith Workstation',
    brand: 'Apex Machines',
    category: 'Workstations',
    price: 1899,
    specs: const {
      'CPU': 'AMD Ryzen 9 7945HX',
      'GPU': 'RTX 4070 (8GB)',
      'RAM': '64GB DDR5',
    },
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDoReD-1TboH2GP4sYVJ9cne0X-pFRUY-4pZfu_od852kuszA0KrYVi0muzgWcwfnH6pSJpUBrXECSl5Zsf7NNCgfV4qdLD9C43yQFI_tPcsSbsmczXfv3aEvJwAEZ7tTmj1cqaVwQ_AUPxskNgmAwnr8yfh3V05MIHtCqk40c0d_s41hudB_P4gOHjzmfiLO3P4uMr2B4SRxmZ30v-xRisrrZ0bhSNCGOys-YNdU6HBr4azJSqgdQx',
    ],
    rating: 4.6,
    reviewCount: 58,
    stock: 11,
  ),
  Product(
    id: 'l3',
    name: 'XPS 13 Plus 9320',
    brand: 'Dell',
    category: 'Laptops',
    price: 1299,
    specs: const {
      'CPU': 'Intel Core i7 13th Gen',
      'GPU': 'Intel Iris Xe',
      'RAM': '16GB LPDDR5',
    },
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBsKLl2_wpqAMdTLtOa4MlUT9I8pJyeCckTX4SRByknqTJ27B_wj-4dgi1fFII8rcRhEdb9FTjj_AJey_WieTQxFtlJXemnz3qGFgM4Uuv-ftnicFCFm-jvCJBk_ubtb30X-u2u0U1NIKcQY55dXilFx84XNE8cxGlBsA79Xqlc0nRcmx3ACRd-57sJIDNctwc2uDthQllAh9qh6T59dukW1Cbftec45GlZ9i0TDZ193e55Ty-pMyNu',
    ],
    rating: 4.8,
    reviewCount: 124,
    stock: 12,
  ),
  Product(
    id: 'l4',
    name: 'MacBook Pro 14-inch',
    brand: 'Apple',
    category: 'Laptops',
    price: 1999,
    specs: const {
      'CPU': 'Apple M3 Pro',
      'GPU': '18-core GPU',
      'RAM': '18GB Unified',
    },
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCgJz0abq-vBvxOfWn3MQPRDA_dq3LRETsKSJZLkiEZaFKZ8SYHqaASQTyfdqAIEQAlqyrg3dO5KsUAuPuvEEuetkdv5rklgPNbAkoE0GNPNvVFwqdOMJNoUzYeJf0OU0uh50vUCq6S_4HB0DHVFNKAQl2ZCm8UmVnrQJkwEWZJx12pSjqJczxTQ2M2G7YT6ParEiT0GsXCfZoL3LTIzLLEOFwdgxbRclhqnIKmK_Gf3fZRGJrBS2IW',
    ],
    rating: 5.0,
    reviewCount: 542,
    stock: 20,
  ),
];