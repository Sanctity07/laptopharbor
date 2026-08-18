import '../../models/product.dart';

/// Placeholder wishlist contents for UI-first development.
/// TODO: remove once WishlistProvider pulls from Firestore.
final List<Product> mockWishlistProducts = [
  Product(
    id: 'w1',
    name: 'Harbor Pro X1',
    brand: 'LaptopHarbor',
    category: 'Laptops',
    price: 1899,
    isNew: true,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuARf4eFVf0-gC-69VJzKIR9Mf4bd2uYJO6Lddzj92qAzb2vD7y36Ya84T9M8oOYIAyI580r6bMvdKpiTBU9kfE-Jk9Con9HSNXDAZVDe30iZZpuqA2eiM_jNE9Cb_HRa8c29lBsJzYvaz1SmFduAf0lpnqyS3c3648qI9uf9Y1GpF78jAoj_Qpch_OFDFs1mL9DjSs-jilOj-MTj1LRgF4ONVrarD0GLlaxbcXv96kT6Titwz0_0H9c',
    ],
  ),
  Product(
    id: 'w2',
    name: 'Titan Mechanical',
    brand: 'Titan',
    category: 'Accessories',
    price: 149,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD3_zIBlOrTZbaL2MIvorJ_84jfViDGxWk0d3hYJ1gDY3vQrwEQIG4kX9JM0yPAGJA0NglEKvK8rtM7R_ruo0j6C3CttxDptT09T4JJxwvmD1W24KrGt-TNFrf-mkFbyzBxdJXlrE_wPL02bw4qyPzqGuOcEUbCrHupBw3HH5TDJbai6t6YwpHW96s5hLK1HTZi6fHBdRLGNeaDOpIkGtSOkcY1xVOmZLumc2IJzxq8rsPPH_J4mAXN',
    ],
  ),
  Product(
    id: 'w3',
    name: 'Curved Ultrawide 34"',
    brand: 'LaptopHarbor',
    category: 'Accessories',
    price: 699,
    originalPrice: 849,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDjF1ej-e1Rs4_Y5oktBkAMY5cpag-4zddJF_EqGnv39E2IzgaR_ogXrBnd3nVVFtvhbso1umBRwn_dVlshW3PI-Mds8EkF6thg2QSIDk0l8KbqJ_osWYoVglZdJRYOSK5Bcf7sICFfSEr2ObOzxP4ZxKN9PBAwTj3EUiTS6EDTwF8TdpUPsbksSLS8JLmyPo93GyzEPZKrP8c026D9p5cep5OUJkRcrKY3Lflv-ERc4Yxl9q0IIPz_',
    ],
  ),
  Product(
    id: 'w4',
    name: 'CloudVault SSD 2TB',
    brand: 'CloudVault',
    category: 'Accessories',
    price: 210,
    specs: const {},
    images: const [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBv2kJ5hX92MtdYVXvSNNpZ2c_MoPVpFPQ1FdxEnAghoLmY0vTv0FrLHw4vMz5H09V1YDQAICpoeQUquWsCa16-NAnskcnpfS5lG9xMnemTCn9oFoFpWE7LSllZerMdTFYCKL070PLAzJbQ0IMkUSLkF9TkF0t7zGF66b1anlh9uq39o7d_X36EQCHNu5G8s3hXnTK00APiVUv0_VO8c8SH6ecswTtT3OeCvKuZyUlcpn6dkzNc9iZQ',
    ],
  ),
];

/// Short description line shown under each wishlist card — keyed by
/// product id since Product doesn't carry a description field.
const Map<String, String> mockWishlistDescriptions = {
  'w1': 'M3 Ultra Chip, 32GB RAM, 1TB SSD. Precision engineered for professional workflows.',
  'w2': 'Hot-swappable switches, Gasket mount, CNC Aluminum frame.',
  'w3': '144Hz Refresh Rate, 1ms Response, 99% sRGB Color Gamut.',
  'w4': 'USB 4.0 Interface, Rugged shock-proof design, hardware encryption.',
};