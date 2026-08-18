import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/mock_cart_items.dart';
import '../../core/utils/validators.dart';
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

  double get _subtotal => mockCartItems.fold(0, (sum, item) => sum + item.subtotal);
  double get _shipping => 0; // FREE, matching the design
  double get _tax => _subtotal * 0.08;
  double get _total => _subtotal + _shipping + _tax;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacingOrder = true);
    // TODO: replace with OrderProvider().placeOrder(...) once backend is wired.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.secondary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryFixedDim),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(
              'LaptopHarbor',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryFixedDim,
                    fontSize: 20,
                  ),
            ),
            actions: [
              Row(
                children: [
                  const Icon(Icons.lock, size: 18, color: AppColors.primaryFixedDim),
                  const SizedBox(width: 6),
                  Text(
                    'Secure Checkout',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryFixedDim),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.primaryFixedDim),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 900;

                      final formColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        validator: (v) => Validators.required(v, field: 'First name'),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.stackMd),
                                    Expanded(
                                      child: CheckoutTextField(
                                        label: 'Last Name',
                                        hint: 'Doe',
                                        controller: _lastNameController,
                                        validator: (v) => Validators.required(v, field: 'Last name'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.stackMd),
                                CheckoutTextField(
                                  label: 'Street Address',
                                  hint: '123 Tech Lane',
                                  controller: _streetController,
                                  validator: (v) => Validators.required(v, field: 'Street address'),
                                ),
                                const SizedBox(height: AppSpacing.stackMd),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CheckoutTextField(
                                        label: 'City',
                                        hint: 'San Francisco',
                                        controller: _cityController,
                                        validator: (v) => Validators.required(v, field: 'City'),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.stackMd),
                                    SizedBox(
                                      width: 90,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('State', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: _selectedState,
                                            decoration: const InputDecoration(),
                                            items: const [
                                              DropdownMenuItem(value: 'CA', child: Text('CA')),
                                              DropdownMenuItem(value: 'NY', child: Text('NY')),
                                              DropdownMenuItem(value: 'TX', child: Text('TX')),
                                            ],
                                            onChanged: (v) => setState(() => _selectedState = v ?? _selectedState),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.stackMd),
                                    SizedBox(
                                      width: 100,
                                      child: CheckoutTextField(
                                        label: 'ZIP Code',
                                        hint: '94103',
                                        controller: _zipController,
                                        keyboardType: TextInputType.number,
                                        validator: (v) => Validators.required(v, field: 'ZIP'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.gutter),
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
                                  onTap: () => setState(() => _paymentMethod = _PaymentMethod.card),
                                ),
                                if (_paymentMethod == _PaymentMethod.card) ...[
                                  const SizedBox(height: AppSpacing.stackMd),
                                  CheckoutTextField(
                                    label: 'Card Number',
                                    hint: '4242 4242 4242 4242',
                                    controller: _cardNumberController,
                                    keyboardType: TextInputType.number,
                                    validator: (v) => Validators.required(v, field: 'Card number'),
                                  ),
                                  const SizedBox(height: AppSpacing.stackMd),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckoutTextField(
                                          label: 'Expiry',
                                          hint: 'MM / YY',
                                          controller: _cardExpiryController,
                                          validator: (v) => Validators.required(v, field: 'Expiry'),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.stackMd),
                                      Expanded(
                                        child: CheckoutTextField(
                                          label: 'CVC',
                                          hint: 'CVC',
                                          controller: _cardCvcController,
                                          keyboardType: TextInputType.number,
                                          validator: (v) => Validators.required(v, field: 'CVC'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: AppSpacing.stackMd),
                                PaymentOptionTile(
                                  icon: Icons.account_balance_wallet_outlined,
                                  title: 'PayPal',
                                  subtitle: 'Redirect to your PayPal account',
                                  selected: _paymentMethod == _PaymentMethod.paypal,
                                  onTap: () => setState(() => _paymentMethod = _PaymentMethod.paypal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                      final summary = CheckoutSummaryCard(
                        items: mockCartItems,
                        subtotal: _subtotal,
                        shipping: _shipping,
                        tax: _tax,
                        total: _total,
                        isPlacingOrder: _isPlacingOrder,
                        onPlaceOrder: _placeOrder,
                      );

                      if (!isWide) {
                        return Column(
                          children: [
                            formColumn,
                            const SizedBox(height: AppSpacing.stackLg),
                            summary,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: formColumn),
                          const SizedBox(width: AppSpacing.gutter),
                          Expanded(flex: 4, child: summary),
                        ],
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}