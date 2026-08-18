# LaptopHarbor — App Navigation & Page Flow

## Overview

The app uses a two-tier navigation model:
- **Shell navigation** — a persistent bottom navigation bar (`RootShell`) for the 5 main tabs.
- **Push navigation** — `Navigator.push` / `pushReplacement` for detail screens, auth, and checkout flows.

---

## 1. App Start

```
main.dart
  └── LaptopHarborApp (MaterialApp)
        └── SplashScreen
              │  (2.5s animated logo reveal)
              └── OnboardingScreen  (fade transition)
                    │
                    ├── LoginScreen       (Skip / Sign In)
                    └── SignupScreen      (Create Account)
```

### SplashScreen
- Plays a scale + opacity animation on the LaptopHarbor logo.
- After 2.5 s, cross-fades to `OnboardingScreen`.

### OnboardingScreen
- Auto-advancing 3-slide carousel (5 s per slide).
- Dot indicators + manual swipe.
- **Next Step / Get Started** → `LoginScreen`.
- **Create Account** → `SignupScreen`.
- **Sign In** text link → `LoginScreen`.
- **Skip** → `LoginScreen`.

### LoginScreen
- Email + password form with validation.
- "Forgot Password?" → snackbar (placeholder).
- **Sign In** button → on success → `RootShell` (replaces stack).
- **Create Account** link → `SignupScreen` (replaces current).
- Google / Apple buttons → stub (no-op).

### SignupScreen
- Name + email + password form with T&C checkbox.
- **Create Account** → on success → `RootShell` (replaces stack).
- **Sign In** link → `LoginScreen` (replaces current).

---

## 2. Main Shell (RootShell)

Once authenticated, all 5 tabs live inside `RootShell` using `IndexedStack` — meaning each tab preserves its state when switching.

```
RootShell (bottom NavigationBar)
  ├── [0] HomeScreen          (icon: home)
  ├── [1] SearchScreen        (icon: search)
  ├── [2] WishlistScreen      (icon: favorite)
  ├── [3] CartScreen          (icon: shopping_cart)
  └── [4] ProfileScreen       (icon: person)
```

The bottom bar is rendered **only** by `RootShell`. No child screen renders its own nav bar.

---

## 3. Home Tab

```
HomeScreen
  ├── App bar search icon  ──────────────────┐
  ├── Search bar tap  ────────────────────── push → ProductListingScreen
  ├── "View All" button  ─────────────────── push → ProductListingScreen
  │
  ├── Category chips (Laptops / Gaming / …)  (local filter, no navigation)
  │
  ├── DealBanner  →  "Shop Now" (stub)
  │
  ├── Product grid cards (HomeProductCard)
  │     └── tap  ──────────────────────────── push → ProductDetailsScreen(product)
  │
  └── Bento cards
        ├── "Learn More" (stub)
        └── (no action on Gear Up card)
```

---

## 4. Search Tab

```
SearchScreen
  ├── Text field (auto-focused)
  │     └── submit / Enter  ─────────────────── push → ProductListingScreen(initialQuery: q)
  │
  ├── Recent searches list
  │     └── tap any term  ──────────────────── push → ProductListingScreen(initialQuery: term)
  │
  ├── Browse by Category chips
  │     └── tap any chip  ──────────────────── push → ProductListingScreen(initialQuery: label)
  │
  └── Inline suggestions (while typing)
        └── tap any suggestion  ─────────────── push → ProductListingScreen(initialQuery: match)
```

---

## 5. Product Listing Screen

Reachable via push from: Home (search bar, "View All"), Search (any entry point).

```
ProductListingScreen(initialQuery?)
  ├── Grid / List toggle  (local state)
  ├── Filters button  (stub)
  ├── Sort dropdown  (local state)
  ├── Active filter chips (removable)
  │
  ├── Product cards (grid mode — ListingProductCard isGridMode: true)
  │     └── tap  ──────────────────────────── push → ProductDetailsScreen(product)
  │
  ├── Product rows (list mode — ListingProductCard isGridMode: false)
  │     └── "View Details" button  ───────── push → ProductDetailsScreen(product)
  │
  └── Skeleton cards (ProductSkeletonCard) shown when _isLoading = true
```

---

## 6. Product Details Screen

Reachable via push from: Home product cards, Listing grid cards, Listing list rows.

```
ProductDetailsScreen(product)
  ├── Breadcrumb: Category → Professional Series → Product Name
  ├── Image gallery (thumbnail selector)
  ├── Info card
  │     ├── SpecTable (zebra-striped specs)
  │     └── ColorSwatchSelector (finish picker)
  ├── Reviews section
  │     ├── Star rating summary
  │     ├── ReviewCard grid
  │     └── "Write a Review" button (stub)
  │
  └── Floating action bar (bottom overlay)
        ├── "Add to Cart" → snackbar confirmation
        └── Wishlist heart toggle (local state)
```

---

## 7. Cart Tab

```
CartScreen
  ├── CartItemCard list (quantity +/− , remove)
  ├── OrderSummaryCard (subtotal, tax, shipping, total)
  └── "Proceed to Checkout" button  ──────── push → CheckoutScreen
```

---

## 8. Checkout Flow

```
CheckoutScreen
  ├── Shipping address fields (CheckoutTextField)
  ├── Payment option tiles (Credit Card / PayPal / Apple Pay)
  ├── CheckoutSummaryCard (order total breakdown)
  └── "Place Order" button  ───────────────── push → OrderConfirmationScreen
                                               (replaces checkout from stack)

OrderConfirmationScreen
  ├── ConfettiOverlay (animated celebration)
  ├── Order number + summary
  ├── "Track Order" button  ───────────────── push → OrderTrackingScreen
  └── "Continue Shopping" button  ─────────── pop back to RootShell (Home tab)
```

---

## 9. Orders

```
OrderHistoryScreen  (accessible from ProfileScreen → Orders link)
  └── RecentOrderCard list
        └── "Track" button  ─────────────────── push → OrderTrackingScreen

OrderTrackingScreen
  ├── OrderStatusBadge (placed / processing / shipped / delivered)
  ├── TrackingRoutePanel (origin → destination progress bar)
  ├── OrderTimeline (step-by-step delivery history)
  └── Sidebar info cards (estimated delivery, carrier, address, support)
```

---

## 10. Wishlist Tab

```
WishlistScreen
  └── (stub — build UI here)
```

---

## 11. Profile Tab

```
ProfileScreen
  ├── Avatar + name + Pro Member badge
  ├── Stats grid (Orders / Reviews / Saved / Points)
  ├── Account settings group
  │     ├── Edit Profile (stub)
  │     ├── Saved Addresses (stub)
  │     └── Password (stub)
  ├── Logout  ──────────────────────────────── pushAndRemoveUntil → LoginScreen
  └── Support card (Chat Now — stub)
```

---

## 12. Navigation Summary Table

| From | Action | Destination | Method |
|---|---|---|---|
| SplashScreen | auto (2.5 s) | OnboardingScreen | `pushReplacement` |
| OnboardingScreen | Skip / Sign In | LoginScreen | `push` |
| OnboardingScreen | Create Account | SignupScreen | `push` |
| OnboardingScreen | Get Started | LoginScreen | `push` |
| LoginScreen | Sign In (success) | RootShell | `pushReplacement` |
| LoginScreen | Create Account | SignupScreen | `pushReplacement` |
| SignupScreen | Create Account (success) | RootShell | `pushReplacement` |
| SignupScreen | Sign In | LoginScreen | `pushReplacement` |
| HomeScreen | Search bar / icon / View All | ProductListingScreen | `push` |
| HomeScreen | Product card tap | ProductDetailsScreen | `push` |
| SearchScreen | Submit / chip / suggestion | ProductListingScreen | `push` |
| ProductListingScreen | Card / row tap | ProductDetailsScreen | `push` |
| CartScreen | Proceed to Checkout | CheckoutScreen | `push` |
| CheckoutScreen | Place Order | OrderConfirmationScreen | `push` |
| OrderConfirmationScreen | Track Order | OrderTrackingScreen | `push` |
| OrderConfirmationScreen | Continue Shopping | RootShell | `pop` |
| OrderHistoryScreen | Track button | OrderTrackingScreen | `push` |
| ProfileScreen | Logout | LoginScreen | `pushAndRemoveUntil` |

---

## 13. Folder Structure Reference

```
lib/
├── core/
│   ├── constants/   app_colors.dart, app_routes.dart, app_strings.dart
│   ├── mock/        mock_products, mock_listing_products, mock_reviews,
│   │                mock_cart_items
│   ├── theme/       app_theme.dart, app_spacing.dart
│   └── utils/       formatters.dart, validators.dart
│
├── models/          product.dart, app_user.dart, cart_item.dart,
│                    order.dart, review.dart
│
├── providers/       auth_provider.dart, product_provider.dart,
│                    cart_provider.dart, order_provider.dart,
│                    wishlist_provider.dart
│
├── services/        auth_service.dart, product_service.dart,
│                    cart_service.dart, order_service.dart,
│                    review_service.dart, storage_service.dart,
│                    wishlist_service.dart
│
├── screens/
│   ├── splash/      splash_screen.dart
│   ├── onboarding/  onboarding_screen.dart, onboarding_slide.dart
│   ├── auth/        login_screen.dart, signup_screen.dart
│   │                widgets/: auth_text_field, social_button,
│   │                          auth_branding_panel
│   ├── home/        home_screen.dart
│   │                widgets/: category_chip, deal_banner,
│   │                          home_product_card, bento_card
│   ├── search/      search_screen.dart
│   ├── product/     product_listing_screen.dart,
│   │                product_details_screen.dart
│   │                widgets/: listing_product_card, product_skeleton_card,
│   │                          filter_chip_pill, spec_table,
│   │                          color_swatch_selector, review_card,
│   │                          pro_nav_drawer
│   ├── cart/        cart_screen.dart
│   │                widgets/: cart_item_card, order_summary_card
│   ├── checkout/    checkout_screen.dart, order_confirmation_screen.dart
│   │                widgets/: checkout_section, checkout_text_field,
│   │                          payment_option_tile, checkout_summary_card,
│   │                          confetti_overlay
│   ├── orders/      order_history_screen.dart, order_tracking_screen.dart
│   │                widgets/: order_timeline, recent_order_card,
│   │                          tracking_route_panel
│   ├── wishlist/    wishlist_screen.dart
│   ├── profile/     profile_screen.dart
│   │                widgets/: profile_stat_card, settings_list_tile
│   └── support/     support_screen.dart
│
├── widgets/         (shared)
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── empty_state.dart
│   ├── loading_indicator.dart
│   ├── order_status_badge.dart
│   ├── product_card.dart
│   ├── rating_stars.dart
│   └── section_title.dart
│
├── root_shell.dart
└── main.dart
```
