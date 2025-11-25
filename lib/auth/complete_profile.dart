//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  final String uid;
  final String email;
  final String name;

  const CompleteProfilePage({
    super.key,
    required this.uid,
    required this.email,
    required this.name,
  });

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _surnameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF6D7BFF),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CircleAvatar(
                      //   radius: 89,
                      //   // backgroundColor: Colors.white,
                      // ),
                      Icon(
                        Icons.grade_rounded,
                        size: 120,
                        color: Colors.yellow,
                      ),

                      // Image.asset(
                      //   widget.isLogin
                      //       ? 'assets/welcome.png'
                      //       : 'assets/passwd.png',
                      //   height: 160,
                      // ),
                      const SizedBox(height: 16),
                      Text(
                        'Complete Profile',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Enter your information to continue',
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
                                        : () async {
                                          setState(() => _isLoading = true);

                                          final provider =
                                              Provider.of<AuthService>(
                                                context,
                                                listen: false,
                                              );
                                          await provider.createUserCollection(
                                            widget.name,
                                            _surnameController.text.trim(),
                                            widget.email,
                                            _phoneNumberController.text.trim(),
                                            _studentNumberController.text
                                                .trim(),
                                            widget.uid,
                                          );
                                          if (!mounted) return;
                                          Navigator.pushReplacementNamed(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            RouteManager.mainLayout,
                                            arguments: widget.email,
                                          );
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
                                          'Complete Registration',
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
