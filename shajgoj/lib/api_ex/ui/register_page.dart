// pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:shajgoj/api_ex/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final authService = AuthService();

  bool isLoading = false;

  Future<void> registerMethod() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final success = await authService.register(
        username: usernameCtrl.text.trim(),
        password: passwordCtrl.text,
        email: emailCtrl.text.trim(),
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Registration successful")),
        );
        Navigator.pop(context); // back to login
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Create Account 🚀",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              _input(usernameCtrl, "Username"),
              _input(emailCtrl, "Email",
                  keyboard: TextInputType.emailAddress),
              _input(firstNameCtrl, "First Name"),
              _input(lastNameCtrl, "Last Name"),
              _input(passwordCtrl, "Password",
                  obscure: true, minLen: 4),
              _input(confirmCtrl, "Confirm Password",
                  obscure: true,
                  validator: (v) =>
                      v != passwordCtrl.text
                          ? "Passwords do not match"
                          : null),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : registerMethod,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("REGISTER"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    int minLen = 1,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
            (v) =>
                v == null || v.length < minLen ? "Required" : null,
      ),
    );
  }
}
