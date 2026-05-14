import 'package:flutter/material.dart';

class DynamicAuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String submitButtonText;
  final VoidCallback onSubmit;

  const DynamicAuthForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.submitButtonText,
    required this.onSubmit
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...fields.map((field) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: field,
          )),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: onSubmit,
            child: Text(submitButtonText),
          ),
        ],
      ),
    );
  }
}