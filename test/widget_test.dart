import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:laptopharbor/main.dart';
import 'package:laptopharbor/providers/auth_provider.dart';
import 'package:laptopharbor/providers/product_provider.dart';
import 'package:laptopharbor/providers/cart_provider.dart';
import 'package:laptopharbor/providers/order_provider.dart';
import 'package:laptopharbor/providers/wishlist_provider.dart';
import 'package:laptopharbor/screens/splash/splash_screen.dart';

void main() {
  testWidgets('App renders SplashScreen on launch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: const LaptopHarborApp(),
      ),
    );

    // The first frame should show the SplashScreen.
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('SplashScreen shows LaptopHarbor branding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashScreen()),
    );

    // Pump one frame to let the animation controller initialize.
    await tester.pump();

    expect(find.text('LaptopHarbor'), findsOneWidget);
    expect(find.byIcon(Icons.laptop_mac_rounded), findsOneWidget);
  });
}
