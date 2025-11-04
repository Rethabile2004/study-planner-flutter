//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'email_formfield.dart';
import 'password_formfield.dart';

class AuthPage extends StatefulWidget {
  final bool isLogin;
  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _surnameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  final _mainFormKey = GlobalKey<FormState>();
  final _detailsFormKey = GlobalKey<FormState>();

  Future<void> _showPersonalDetailsDialog(BuildContext context) async {
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.person_outline, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text(
              "Enter Personal Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 320,
            child: Form(
              key: _detailsFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _surnameController,
                    label: 'Surname',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _studentNumberController,
                    label: 'Student Number',
                    icon: Icons.school_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _phoneNumberController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _isLoading
                ? null
                : () {
                    if (_detailsFormKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      _submit(context);
                    }
                  },
            child: _isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Save Details',
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_mainFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(
          context,
          RouteManager.mainPage,
          arguments: _emailController.text.trim(),
        );
      } else {
        await authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _surnameController.text.trim(),
          _studentNumberController.text.trim(),
          _phoneNumberController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, RouteManager.loginPage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "Enter your email"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please enter your email")));
                return;
              }

              try {
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                await authService.resetPassword(email);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Password reset link sent to your email")));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
            child: const Text("Send Reset Link"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              color: Colors.white.withOpacity(0.95),
              shadowColor: Colors.black26,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Form(
                  key: _mainFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        widget.isLogin
                            ? 'assets/welcome.png'
                            : 'assets/passwd.png',
                        height: 160,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.isLogin
                            ? 'Welcome Back 👋'
                            : 'Create Your Account ✨',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      EmailFormField(controller: _emailController),
                      const SizedBox(height: 14),
                      PasswordFormField(controller: _passwordController),
                      if (widget.isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                _showForgotPasswordDialog(context),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (!_mainFormKey.currentState!.validate()) {
                                    return;
                                  } else if (!widget.isLogin) {
                                    _showPersonalDetailsDialog(context);
                                  } else {
                                    _submit(context);
                                  }
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  widget.isLogin ? 'Login' : 'Register',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          widget.isLogin
                              ? RouteManager.registrationPage
                              : RouteManager.loginPage,
                        ),
                        child: Text(
                          widget.isLogin
                              ? "Don't have an account? Sign up"
                              : "Already have an account? Login",
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
