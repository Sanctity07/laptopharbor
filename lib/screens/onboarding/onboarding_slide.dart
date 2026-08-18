class OnboardingSlide {
  final String imageUrl;
  final String title;
  final String description;

  const OnboardingSlide({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

const List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBnjOy0KGhGlrrhXpXNgqOls6Y62_drt9NTmd0Ptn2xvR5xRh1kgHJuXAiQxc2cqs310BW2WIRL9lSQV7ZJBJOE_WqcDtHiFIqJbX0E5kC5xAvqlujM3s1Zgs-IlhdKWLU0UWsFT4qCeII1V5B-Zv9b7oVPE1qY0f-4DeFQ2kaOLi047a6kRbg8PXVCH-AbHn8JkvUGcYtxzcrgnhZUqGq4rAa6goaMgsmGs_RotCpyNqAB0J9_LQsE',
    title: 'Browse Premium Hardware',
    description:
        "Discover a curated selection of the world's most powerful laptops, built for creators and professionals who demand excellence.",
  ),
  OnboardingSlide(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCaf90v1FvvSg3JCtdrTa74JD66mxmoiGqpFG7eAwTYuk63CM3PDQj6fDYnDt4F3iw2QazWRX3bH-1vlanMrkU1wYVm92ckPevmNumpL1-xMVjqyfn8mGoBg0ch5Dluh05Qm3ludLAiAfMUr46xkh0OQQQQIqeN9B9Qvl9wJ5YcpI-N5A9uomodGJmQZn-tv4pIMfOYhQW_ujxZE6wSYz9jWW7ZYyFFt7-p4cSX6beSz2nQohbPL4j7',
    title: 'Compare with Precision',
    description:
        'Dive deep into technical specifications with our side-by-side comparison tool. Every detail matters when performance is the priority.',
  ),
  OnboardingSlide(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA_xE_bor9p8RwAiZEDXrLXPq9zUWweqGW3D3G89D53OMJ9yvq7pTmD8mp5zQSuyvZqMxWXhFX1cw04rXz_IcuEvpWRm0HsqXKR9lzTHZi9SOwvaro0przJtwc8WbiXFLbzporuqBY4HVCyVL_gP7UXzhmlH4mc2cLbvkspN2l-P2OiU5fXjKl6NLudP4SwHargU45BWBkzhHisr-b0_du832R6sJA_W0XFW7x9tfTJsT1My52_jF_L',
    title: 'Lightning-Fast Checkout',
    description:
        'Secure, seamless, and optimized for speed. Get your next powerhouse delivered to your door with a single, effortless transaction.',
  ),
];
