//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final AppUser? user = await auth.getUserData(auth.currentUser!.uid);

      if (user != null) {
        _nameController.text = user.name;
        _surnameController.text = user.surname;
        _phoneController.text = user.phoneNumber;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading user data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Profile Avatar
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: theme.colorScheme.primary
                                    .withOpacity(0.2),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: FloatingActionButton.small(
                                  backgroundColor: theme.colorScheme.primary,
                                  onPressed: () {
                                    // Future: add image picker logic here
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Input fields
                        _buildTextField(
                          controller: _nameController,
                          label: 'First Name',
                          icon: Icons.person_outline,
                          validator:
                              (v) =>
                                  v!.isEmpty
                                      ? 'Please enter your first name'
                                      : null,
                        ),
                        const SizedBox(height: 18),

                        _buildTextField(
                          controller: _surnameController,
                          label: 'Surname',
                          icon: Icons.badge_outlined,
                          validator:
                              (v) =>
                                  v!.isEmpty
                                      ? 'Please enter your surname'
                                      : null,
                        ),
                        const SizedBox(height: 18),

                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator:
                              (v) =>
                                  v!.isEmpty
                                      ? 'Please enter your phone number'
                                      : null,
                        ),

                        const SizedBox(height: 32),

                        _isSaving
                            ? const CircularProgressIndicator()
                            : ElevatedButton.icon(
                              onPressed: _saveProfile,
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('Save Changes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.blueGrey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.updateUserInfo(
        _nameController.text.trim(),
        _surnameController.text.trim(),
        _phoneController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }
}
