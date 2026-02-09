

import 'package:flutter/material.dart';
import 'package:shajgoj/core/constanst/app_colors.dart';

import 'package:shajgoj/services/database_helper.dart';
import 'order_details_screen.dart'; // ← এটা অবশ্যই import করো

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _shippingMethod = 'outside';
  double _shippingCharge = 99.00;

  String? _paymentMethod = 'cod';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _orderNoteController = TextEditingController();
  final _couponController = TextEditingController();

  String? _selectedCity = 'Dhaka';
  String? _selectedArea;

  Future<Map<String, dynamic>> _getCartSummary() async {
    final items = await DatabaseHelper.instance.getCartItems();
    double subTotal = 0.0;

    for (var item in items) {
      final price =
          (item['discountPrice'] > 0 ? item['discountPrice'] : item['price'])
              as double;
      final qty = item['quantity'] as int;
      subTotal += price * qty;
    }

    return {
      'subTotal': subTotal,
      'items': items,
      'itemCount': items.fold(
        0,
        (sum, item) => sum + (item['quantity'] as int),
      ),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _orderNoteController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getCartSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartData =
              snapshot.data ??
              {
                'subTotal': 0.0,
                'items': <Map<String, dynamic>>[],
                'itemCount': 0,
              };
          final subTotal = cartData['subTotal'] as double;
          final totalAmount = subTotal + _shippingCharge;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${cartData['itemCount']} ITEM • ৳${subTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'BILLING & SHIPPING',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField('Name', _nameController),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Phone',
                    _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: InputDecoration(
                      labelText: 'Select City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Dhaka', child: Text('Dhaka')),
                      DropdownMenuItem(
                        value: 'Chittagong',
                        child: Text('Chittagong'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedCity = value),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: _selectedArea,
                    hint: const Text('Select Area'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Mirpur', child: Text('Mirpur')),
                      DropdownMenuItem(value: 'Uttara', child: Text('Uttara')),
                    ],
                    onChanged: (value) => setState(() => _selectedArea = value),
                  ),
                  const SizedBox(height: 12),

                  _buildTextField('Address', _addressController, maxLines: 3),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Email (optional)',
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Order Note (optional)',
                    _orderNoteController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Coupon
                  const Text(
                    'Have Coupon / Voucher?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            hintText: 'Enter coupon code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coupon applied!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Shipping
                  const Text(
                    'Choose Shipping Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Delivery Outside Dhaka'),
                    subtitle: const Text('৳99.00'),
                    value: 'outside',
                    groupValue: _shippingMethod,
                    onChanged: (value) {
                      setState(() {
                        _shippingMethod = value;
                        _shippingCharge = 99.00;
                      });
                    },
                    activeColor: AppColors.primaryPink,
                  ),
                  RadioListTile<String>(
                    title: const Text('Delivery Inside Dhaka'),
                    subtitle: const Text('৳66.00'),
                    value: 'inside',
                    groupValue: _shippingMethod,
                    onChanged: (value) {
                      setState(() {
                        _shippingMethod = value;
                        _shippingCharge = 66.00;
                      });
                    },
                    activeColor: AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),

                  // Total
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total MRP', style: TextStyle(fontSize: 16)),
                      Text(
                        '৳${subTotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping Charge',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '৳${_shippingCharge.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '৳${totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Payment
                  const Text(
                    'Choose Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Cash on Delivery'),
                    value: 'cod',
                    groupValue: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value),
                    activeColor: AppColors.primaryPink,
                  ),
                  RadioListTile<String>(
                    title: const Text('Bkash'),
                    value: 'bkash',
                    groupValue: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value),
                    activeColor: AppColors.primaryPink,
                  ),
                  RadioListTile<String>(
                    title: const Text('Pay with Card/Mobile Wallet'),
                    value: 'card',
                    groupValue: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value),
                    activeColor: AppColors.primaryPink,
                  ),
                  const SizedBox(height: 32),

                  // Place Order
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.trim().isEmpty ||
                            _phoneController.text.trim().isEmpty ||
                            _addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                          return;
                        }

                        final order = {
                          'order_number':
                              '#${DateTime.now().millisecondsSinceEpoch}',
                          'customer_name': _nameController.text.trim(),
                          'phone': _phoneController.text.trim(),
                          'email': _emailController.text.trim().isEmpty
                              ? 'N/A'
                              : _emailController.text.trim(),
                          'delivery_type': _shippingMethod == 'outside'
                              ? 'Outside Dhaka'
                              : 'Inside Dhaka',
                          'payment_method': _paymentMethod == 'cod'
                              ? 'Cash on Delivery'
                              : (_paymentMethod == 'bkash'
                                    ? 'Bkash'
                                    : 'Card/Wallet'),
                          'note': _orderNoteController.text.trim().isEmpty
                              ? 'N/A'
                              : _orderNoteController.text.trim(),
                          'address': _addressController.text.trim(),
                          'area': _selectedArea ?? 'N/A',
                          'city': _selectedCity ?? 'N/A',
                          'sub_total': subTotal,
                          'delivery_fee': _shippingCharge,
                          'total': totalAmount,
                          'status': 'PROCESSING',
                          'order_date': DateTime.now()
                              .toIso8601String()
                              .split('T')
                              .first,
                          'order_time': TimeOfDay.now().format(context),
                        };

                        try {
                          final orderId = await DatabaseHelper.instance
                              .insertOrder(order);

                          final cartItems = cartData['items'] as List<dynamic>;
                          for (var item in cartItems) {
                            final itemMap = item as Map<String, dynamic>;
                            await DatabaseHelper.instance
                                .insertOrderItems(orderId, {
                                  'product_id': itemMap['id'],
                                  'name': itemMap['name'],
                                  'image_url': itemMap['imageUrl'],
                                  'price': itemMap['discountPrice'] > 0
                                      ? itemMap['discountPrice']
                                      : itemMap['price'],
                                  'qty': itemMap['quantity'],
                                  'total':
                                      (itemMap['discountPrice'] > 0
                                          ? itemMap['discountPrice']
                                          : itemMap['price']) *
                                      (itemMap['quantity'] as int),
                                });
                          }

                          await DatabaseHelper.instance.clearCart();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order Placed Successfully!'),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(orderData: order),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error placing order: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'PLACE ORDER',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
