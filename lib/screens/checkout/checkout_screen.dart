import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/utils/validators.dart';
import '../../models/order.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import 'order_confirmation_screen.dart';
import 'widgets/checkout_section.dart';
import 'widgets/checkout_text_field.dart';
import 'widgets/payment_option_tile.dart';
import 'widgets/checkout_summary_card.dart';

enum _PaymentMethod { card, paypal }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String _selectedState = 'CA';

  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvcController = TextEditingController();

  _PaymentMethod _paymentMethod = _PaymentMethod.card;
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvcController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to place an order.'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);
    try {
      final cart = context.read<CartProvider>();
      final address =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}, '
          '${_streetController.text.trim()}, '
          '${_cityController.text.trim()}, $_selectedState ${_zipController.text.trim()}';

      final order = OrderModel(
        id: '',
        userId: uid,
        items: List.of(cart.items),
        totalAmount: cart.total,
        tax: cart.tax,
        shipping: cart.shipping,
        status: OrderStatus.placed,
        shippingAddress: address,
        createdAt: DateTime.now(),
      );

      final orderId =
          await context.read<OrderProvider>().placeOrder(order);
      await cart.clearCart(uid);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => OrderConfirmationScreen(orderId: orderId)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.navBackground,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.primaryFixedDim),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                title: Text(
                  'LaptopHarbor',
                  style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryFixedDim,
                            fontSize: 20,
                          ),
                ),
                actions: [
                  Row(children: [
                    const Icon(Icons.lock,
                        size: 18, color: AppColors.primaryFixedDim),
                    const SizedBox(width: 6),
                    Text('Secure Checkout',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.primaryFixedDim)),
                    const SizedBox(width: 16),
                  ]),
                  IconButton(
                    icon: const Icon(Icons.search,
                        color: AppColors.primaryFixedDim),
                    onPressed: () {},
                  ),
                ],
              ),

              SliverLayoutBuilder(
                builder: (context, sc) {
                  final w = sc.crossAxisExtent;
                  final hPad = responsiveHPadding(w);
                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Center(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: 1280),
                            child: Form(
                              key: _formKey,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide =
                                      constraints.maxWidth >= 900;
                                  final formCol =
                                      _buildFormColumn(context);
                                  final summary = CheckoutSummaryCard(
                                    items: cart.items,
                                    subtotal: cart.subtotal,
                                    shipping: cart.shipping,
                                    tax: cart.tax,
                                    total: cart.total,
                                    isPlacingOrder: _isPlacingOrder,
                                    onPlaceOrder: _placeOrder,
                                  );
                                  if (!isWide) {
                                    return Column(children: [
                                      formCol,
                                      const SizedBox(height: 32),
                                      summary,
                                    ]);
                                  }
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 8, child: formCol),
                                      const SizedBox(width: 24),
                                      Expanded(
                                          flex: 4, child: summary),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section 1: Shipping ───────────────────────────────────────
        CheckoutSection(
          number: 1,
          title: 'Shipping Address',
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckoutTextField(
                      label: 'First Name',
                      hint: 'John',
                      controller: _firstNameController,
                      validator: (v) =>
                          Validators.required(v, field: 'First name'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CheckoutTextField(
                      label: 'Last Name',
                      hint: 'Doe',
                      controller: _lastNameController,
                      validator: (v) =>
                          Validators.required(v, field: 'Last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CheckoutTextField(
                label: 'Street Address',
                hint: '123 Tech Lane',
                controller: _streetController,
                validator: (v) =>
                    Validators.required(v, field: 'Street address'),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckoutTextField(
                      label: 'City',
                      hint: 'San Francisco',
                      controller: _cityController,
                      validator: (v) =>
                          Validators.required(v, field: 'City'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('State',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedState,
                          decoration: const InputDecoration(),
                          items: const [
                            DropdownMenuItem(
                                value: 'CA', child: Text('CA')),
                            DropdownMenuItem(
                                value: 'NY', child: Text('NY')),
                            DropdownMenuItem(
                                value: 'TX', child: Text('TX')),
                          ],
                          onChanged: (v) => setState(
                              () => _selectedState = v ?? _selectedState),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: CheckoutTextField(
                      label: 'ZIP Code',
                      hint: '94103',
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          Validators.required(v, field: 'ZIP'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Section 2: Payment ────────────────────────────────────────
        CheckoutSection(
          number: 2,
          title: 'Payment Method',
          child: Column(
            children: [
              PaymentOptionTile(
                icon: Icons.credit_card,
                title: 'Credit or Debit Card',
                subtitle: 'Secure, encrypted payment via Stripe',
                selected: _paymentMethod == _PaymentMethod.card,
                onTap: () => setState(
                    () => _paymentMethod = _PaymentMethod.card),
              ),
              if (_paymentMethod == _PaymentMethod.card) ...[
                const SizedBox(height: 16),
                CheckoutTextField(
                  label: 'Card Number',
                  hint: '4242 4242 4242 4242',
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      Validators.required(v, field: 'Card number'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CheckoutTextField(
                        label: 'Expiry',
                        hint: 'MM / YY',
                        controller: _cardExpiryController,
                        validator: (v) =>
                            Validators.required(v, field: 'Expiry'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CheckoutTextField(
                        label: 'CVC',
                        hint: 'CVC',
                        controller: _cardCvcController,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            Validators.required(v, field: 'CVC'),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              PaymentOptionTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'PayPal',
                subtitle: 'Redirect to your PayPal account',
                selected: _paymentMethod == _PaymentMethod.paypal,
                onTap: () => setState(
                    () => _paymentMethod = _PaymentMethod.paypal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
