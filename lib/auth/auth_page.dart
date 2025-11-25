//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:cloud_firestore/cloud_firestore.dart';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your email")),
                    );
                    return;
                  }

                  try {
                    final authService = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    await authService.resetPassword(email);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password reset link sent to your email"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: const Text("Send Reset Link"),
              ),
            ],
          ),
    );
  }

  Widget _socialButton({required String asset, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        width: 210,
        height: 60,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.2),
          // shape: BoxShape.circle,
          // ignore: deprecated_member_use
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.3),),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(asset, width: 32, height: 32),
              const Text("Sign in with Google"),
            ],
          ),
        ),
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
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 218, 218, 218),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Form(
                key: _mainFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CircleAvatar(
                    //   radius: 89,
                    //   // backgroundColor: Colors.white,
                    // ),
                    Icon(Icons.grade_rounded, size: 120, color: Colors.yellow),

                    // Image.asset(
                    //   widget.isLogin
                    //       ? 'assets/welcome.png'
                    //       : 'assets/passwd.png',
                    //   height: 160,
                    // ),
                    const SizedBox(height: 16),
                    Text(
                      widget.isLogin ? 'Welcome Back' : 'New Account',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.isLogin
                          ? 'Enter your credintials to login'
                          : 'Register to continue',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    Container(
                      width: 300,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          if (!widget.isLogin)
                            _buildInputField(
                              controller: _nameController,
                              label: 'Full Name',
                              icon: Icons.badge_outlined,
                            ),
                          const SizedBox(height: 14),
                          if (!widget.isLogin)
                            _buildInputField(
                              controller: _surnameController,
                              label: 'Surname',
                              icon: Icons.person_outline,
                            ),
                          const SizedBox(height: 14),
                          if (!widget.isLogin)
                            _buildInputField(
                              controller: _studentNumberController,
                              label: 'Student Number',
                              icon: Icons.school_outlined,
                            ),
                          const SizedBox(height: 14),
                          if (!widget.isLogin)
                            _buildInputField(
                              controller: _phoneNumberController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                          const SizedBox(height: 14),
                          EmailFormField(controller: _emailController),
                          const SizedBox(height: 14),
                          PasswordFormField(controller: _passwordController),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            // width: 160,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () {
                                        if (!_mainFormKey.currentState!
                                            .validate()) {
                                          return;
                                        } else if (!widget.isLogin) {
                                          // _showPersonalDetailsDialog(context);
                                          _submit(context);
                                        } else {
                                          _submit(context);
                                        }
                                      },
                              child:
                                  _isLoading
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _socialButton(
                      asset: 'assets/google.png',
                      onTap: () async {
                        final auth = Provider.of<AuthService>(
                          context,
                          listen: false,
                        );
                    
                        try {
                          final result = await auth.signInWithGoogle();
                          final user = result.user;
                    
                          final doc =
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user!.uid)
                                  .get();
                    
                          if (doc.exists) {
                            // Profile already created
                            Navigator.pushReplacementNamed(
                              // ignore: use_build_context_synchronously
                              context,
                              RouteManager.completeProfile,
                              arguments: user.email,
                            );
                          } else {
                            Navigator.pushReplacementNamed(
                              // ignore: use_build_context_synchronously
                              context,
                              RouteManager.mainPage,
                              arguments: {
                                "email": user.email,
                                "name": user.displayName ?? "",
                                "uid": user.uid,
                              },
                            );
                          }
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 14),
                    TextButton(
                      onPressed:
                          () => Navigator.pushReplacementNamed(
                            context,
                            widget.isLogin
                                ? RouteManager.registrationPage
                                : RouteManager.loginPage,
                          ),
                      child: Text(
                        widget.isLogin ? "Sign up" : "Sign in",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (widget.isLogin)
                      TextButton(
                        onPressed: () => _showForgotPasswordDialog(context),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
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
    );
  }
}
