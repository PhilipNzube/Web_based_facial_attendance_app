import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black),
          dropdownColor: Colors.white,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
