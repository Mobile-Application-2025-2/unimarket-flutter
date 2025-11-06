import 'package:flutter/material.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  String selectedMethod = 'Efectivo';
  final List<String> methods = ['Efectivo', 'Nequi', 'Daviplata'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Método de pago',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            GestureDetector(
              child: const Text(
                'Editar',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFFFFC107),
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () => notImplementedFunctionalitySnackbar(context),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMethod,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedMethod = newValue;
                  });
                }
              },
              items: methods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
