# Firebase Setup Guide for LaptopHarbor

## 1. Create a Firebase Project

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → name it `laptopharbor` (or anything you like)
3. Disable Google Analytics if you don't need it, or leave it enabled
4. Click **Create project**

---

## 2. Enable Authentication

1. In the Firebase Console sidebar → **Build → Authentication**
2. Click **Get started**
3. Under **Sign-in method**, enable:
   - **Email/Password** → Enable → Save

---

## 3. Create Firestore Database

1. **Build → Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (you'll add proper rules after setup)
4. Pick your region (e.g., `us-central1`) → **Enable**

### Deploy security rules

Copy `firestore.rules` from this project and paste it in the **Rules** tab, or deploy via CLI:

```bash
firebase deploy --only firestore:rules
```

---

## 4. Add Your App to Firebase

### Android

1. In Firebase Console → **Project settings** → **Add app** → Android icon
2. Android package name: `com.example.laptopharbor`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`
5. The `build.gradle.kts` files already include the Google services plugin

### iOS (optional)

1. Add app → iOS icon
2. iOS bundle ID: `com.example.laptopharbor`
3. Download `GoogleService-Info.plist`
4. Place it at: `ios/Runner/GoogleService-Info.plist`

---

## 5. Generate firebase_options.dart

Install the FlutterFire CLI and run configure — this generates the `firebase_options.dart` file automatically:

```bash
# Install FlutterFire CLI (one time)
dart pub global activate flutterfire_cli

# In your project directory, run:
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This will **replace** the placeholder `lib/firebase_options.dart` with the real one containing your project's keys.

---

## 6. Seed Products into Firestore

The app reads products from the `products` Firestore collection. Add some data manually in the console or use a seed script.

Sample product document structure (collection: `products`):

```json
{
  "name": "ProStream X-15 Workstation",
  "brand": "ProStream",
  "category": "Laptops",
  "price": 2499,
  "originalPrice": 2899,
  "isNew": true,
  "stock": 15,
  "rating": 4.8,
  "reviewCount": 124,
  "images": [
    "https://your-image-url.com/laptop1.jpg"
  ],
  "specs": {
    "CPU": "Intel i9-13900H",
    "RAM": "64GB DDR5",
    "Storage": "2TB NVMe SSD",
    "GPU": "NVIDIA RTX 4090",
    "Display": "16\" 4K OLED",
    "Battery": "99Wh"
  }
}
```

---

## 7. Run the App

```bash
flutter run
```

The app will now:
- Use **Firebase Authentication** for sign up, login, and logout
- Store **cart items** in Firestore under `users/{uid}/cart`
- Store **wishlist** in Firestore under `users/{uid}/wishlist`
- Save **orders** in Firestore under `orders/{orderId}`
- Stream **order updates** in real-time via Firestore
- Auto-login users who are already signed in (persistent auth state)
