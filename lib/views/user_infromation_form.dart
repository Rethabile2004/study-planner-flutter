import 'package:flutter/material.dart';

class UserInformationForm extends StatefulWidget {
  final String? initialName, initialSurname, initialPhoneNumber, userId;
  final Function(String name, String surname, String phoneNumber) onSubmit;

  const UserInformationForm({
    super.key,
    this.userId,
    this.initialName,
    this.initialSurname,
    this.initialPhoneNumber,
    required this.onSubmit,
  });

  @override
  State<UserInformationForm> createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<UserInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? "";
    _surnameController.text = widget.initialSurname ?? "";
    _phoneNumberController.text = widget.initialPhoneNumber ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              widget.userId != null ? "Update Information" : "Your Info",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(
                labelText: 'Surname',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(
                    _nameController.text,
                    _surnameController.text,
                    _phoneNumberController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(
                widget.userId != null
                    ? "Update Information"
                    : "Save Information",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
