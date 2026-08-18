# LaptopHarbor — Architecture & Implementation Plan

## 1. Overview
LaptopHarbor is a mobile app for browsing, comparing, and purchasing laptops and accessories. This plan turns the eProject brief into a buildable Flutter application.

**Stack choice:** Flutter (UI) + Firebase (Auth, Firestore, Storage, Cloud Functions, Cloud Messaging). Firebase is chosen over a raw SQL backend because it gives auth, real-time data, storage, and push notifications out of the box, which maps directly onto the brief's requirements (secure login, real-time order tracking, order status notifications) without standing up separate server infrastructure. A relational (SQL) backend via a REST API is a valid alternative if a custom backend is preferred later — the service layer below is written so that swap is possible without touching the UI.

## 2. Architecture

```
┌─────────────────────────────┐
│         Flutter App          │
│  Screens → Providers → Services │
└───────────────┬───────────────┘
                │
   ┌────────────┼─────────────┐
   ▼            ▼             ▼
Firebase Auth  Firestore   Firebase Storage
(login/signup) (products,  (product images,
                orders,     profile pics)
                reviews,
                wishlists)
   │
   ▼
Cloud Functions (order total calc, confirmation emails,
                 order status push notifications)
```

**Pattern:** MVVM-ish — Screens (View) → Providers (ViewModel/state) → Services (data access). Keeps Firebase calls out of widgets, so the backend can be swapped later.

**State management:** `provider` package (simple, well-documented, matches project scope). Can migrate to Riverpod later if needed.

## 3. Data Model (Firestore collections)

- **users**: uid, name, email, photoUrl, phone, addresses[]
- **products**: id, name, brand, category, price, specs{}, images[], rating, reviewCount, stock
- **reviews**: id, productId, userId, rating, comment, createdAt
- **cart** (subcollection under user): productId, quantity, priceAtAdd
- **orders**: id, userId, items[], totalAmount, tax, shipping, status (placed/processing/shipped/delivered), shippingAddress, createdAt, statusHistory[]
- **wishlist** (subcollection under user): productId, addedAt

## 4. Feature-to-module mapping

| Brief requirement | Module |
|---|---|
| Registration & secure login | `services/auth_service.dart`, `screens/auth/` |
| Product listings, filter/sort | `services/product_service.dart`, `screens/home/`, `screens/search/` |
| Product details & reviews | `screens/product/`, `models/review.dart` |
| Shopping cart | `services/cart_service.dart`, `screens/cart/` |
| Checkout & payment | `screens/checkout/`, Cloud Function for total calc |
| Order tracking & notifications | `services/order_service.dart`, `screens/orders/`, FCM |
| Profile & settings | `screens/profile/` |
| Search | `screens/search/` |
| Wish list | `services/wishlist` logic in `product_service.dart`, `screens/wishlist/` |
| Feedback/support | `screens/support/` |

## 5. Implementation Plan (phased, laddered — matching the brief's "laddered approach")

**Phase 1 — Foundation (Week 1)**
- Flutter project setup, folder structure, theming, routing
- Firebase project setup (Auth, Firestore, Storage)
- Data models + Firestore security rules draft

**Phase 2 — Auth & Product Browsing (Week 2)**
- Sign up / login / password reset
- Product listing, category/brand/price filters, sorting
- Product details screen + reviews display

**Phase 3 — Cart & Checkout (Week 3)**
- Add/remove/update cart items
- Checkout flow: shipping info, order total (incl. tax/shipping), confirmation email via Cloud Function

**Phase 4 — Orders, Profile, Search, Wishlist (Week 4)**
- Order history + real-time status tracking + push notifications
- Profile editing, password change
- Search with filters
- Wishlist add/remove

**Phase 5 — Polish & Non-functional requirements (Week 5)**
- Error handling & empty/loading states across all screens
- Performance pass (target 1-2s interaction response)
- Accessibility pass (font scaling, contrast, tap targets)
- Support/feedback form
- User + developer documentation, demo video

## 6. Folder structure (already scaffolded)

```
lib/
  core/           # constants, theme, utils, shared config
  models/         # data classes (Product, User, Order, CartItem, Review)
  services/       # Firebase/data access layer
  providers/      # state management (ChangeNotifier per feature)
  screens/        # one folder per feature area
  widgets/        # shared reusable widgets (ProductCard, CustomButton, etc.)
main.dart
```
