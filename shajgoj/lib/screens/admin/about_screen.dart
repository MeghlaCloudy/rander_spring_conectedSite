import 'package:flutter/material.dart';
import 'package:shajgoj/core/constanst/app_colors.dart';
import 'package:shajgoj/core/constanst/app_strings.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner / Top Section
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryPink, AppColors.primaryPinkDark],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/logo.png', // তোমার লোগো দাও
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Trusted Beauty Destination',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // About Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Who We Are'),
                  const SizedBox(height: 12),
                  const Text(
                    'My Beauty Shop is Bangladesh\'s leading online beauty store. We bring you authentic, genuine products from top brands at the best prices. Our mission is to make beauty accessible, affordable, and fun for everyone.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Our Promise'),
                  const SizedBox(height: 12),
                  _buildPromiseItem(Icons.verified, '100% Authentic Products'),
                  _buildPromiseItem(
                    Icons.local_shipping,
                    'Fast & Safe Delivery',
                  ),
                  _buildPromiseItem(Icons.payment, 'Secure Payment'),
                  _buildPromiseItem(
                    Icons.support_agent,
                    '24/7 Customer Support',
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Why Choose Us?'),
                  const SizedBox(height: 12),
                  const Text(
                    '• Exclusive deals & flash sales every day\n'
                    '• Genuine products with warranty\n'
                    '• Easy returns & refunds\n'
                    '• Trusted by lakhs of customers',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  // Contact Info
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email, color: AppColors.primaryPink),
                            const SizedBox(width: 8),
                            const Text('support@mybeautyshop.com'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: AppColors.primaryPink),
                            const SizedBox(width: 8),
                            const Text('+880 1234 567890'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryPink,
      ),
    );
  }

  Widget _buildPromiseItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryPink, size: 28),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
