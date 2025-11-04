//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:flutter/material.dart';

class UserInformationForm extends StatefulWidget {
  final String? initialName, initialSurname, initialPhoneNumber,userId;

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
    if (widget.initialName != null) _nameController.text = widget.initialName!;
    if (widget.initialSurname != null) {
      _surnameController.text = widget.initialSurname!;
    }
    if (widget.initialPhoneNumber != null) {
      _phoneNumberController.text = widget.initialPhoneNumber!;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              hintText: 'First Name',
              
            ),
            validator:(value)=>value!.isNotEmpty?'Required':null
          ),
          TextFormField(
            controller: _surnameController,
            decoration: const InputDecoration(
              labelText: 'Surname',
              hintText: 'Surname',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value!.isNotEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Phone Number',
              prefixIcon: Icon(Icons.call),
            ),
            validator: (value) => value!.isNotEmpty ? 'Required' : null,
          ),
          SizedBox(height: 30),
          Align(
            alignment:Alignment.centerRight,
            child: ElevatedButton(
              child:Text(widget.userId==null?'':'Update Information'),
              onPressed:(){
                if(!_formKey.currentState!.validate()){
                  widget.onSubmit(_nameController.text,_surnameController.text,_phoneNumberController.text);
                  Navigator.pop(context);
                }
              }
            ),
          )
        ],
      ),
    );
  }
}
