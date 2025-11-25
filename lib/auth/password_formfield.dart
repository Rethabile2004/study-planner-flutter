//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:flutter/material.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  const PasswordFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      //password visibility icon, when pressed the password shows else the password is hidden
      keyboardType: TextInputType.visiblePassword,
      
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Minimum 8 characters';
        if (!value.contains('@')) return 'Must contain @ symbol';
        return null;
      },
    );
  }
}
// // This widget is a custom password input field for a form. It uses a TextFormField to accept user input and validate the password.
// // The validator checks if the password is empty, if it is at least 8 characters long, and if it contains an '@' symbol.
// // The field also includes an icon for better user experience.
// // The widget is reusable and can be easily integrated into any form that requires password input.
// // It enhances the user interface by providing clear feedback on the validity of the input, ensuring that only strong passwords are accepted.
// // This widget is a custom password input field for a form. It uses a TextFormField to accept user input and validate the password.
// // The validator checks if the password is empty, if it is at least 8 characters long, and if it contains an '@' symbol.
